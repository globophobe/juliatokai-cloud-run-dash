import HTTP
using Dashboards
using Dates

include("chart.jl")
using .Chart
include("bigquery.jl")
using .BigQuery
include("bitmex.jl")
using .BitMEX
include("validation.jl")
using .InputValidation

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

@async open_websocket()

initial_data_frame = load_dataframe("2020-01-01", "2020-01-01")
initial_figure = get_figure(initial_data_frame)


DATE_PICKER_RANGE = 



app = Dash("XBTUSD") do
    html_div() do
				html_h1("Hello Dashboards"),
				html_div("Dashboards: Julia interface for Dash")
				html_div( id = "trades" ),
				dcc_datepickerrange( 
						id = "date-range", 
						min_date_allowed = Dates.Date(2016, 5, 13),
						max_date_allowed = Dates.today()
				),
				dcc_graph( id = "chart" ),
				dcc_interval(
						id = "interval",
						interval = 200,
						n_intervals = 0
				),
				dcc_state( id = "loading-state", data = Dict( "loading" => false ) )
    end
end


callback!(app, callid"""
        date-range.start_date, date-range.end_date => loading-state.data
    """) do start_date, end_date, figure

    start_d, end_d = parse_dates(start_date, end_date)

    if !isnothing(start_d) && !isnothing(end_d)
        return Dict( "loading" => true )
		else
        throw(PreventUpdate())  
    end
end


callback!(app, callid"loading-state.data => date-range.disabled") do data

    if valid_dates(start_date, end_date)
        data_frame = load_dataframe(start_date, end_date) 
        return get_figure(data_frame)
    else 
        throw(PreventUpdate())  
    end
end

callback!(app, callid"""chart.figure => loading-state.data""") do figure
			
end


callback!(app, callid"interval.n_intervals => trades.children") do n_intervals
    if length(trades) > 0
      price = trades[1]["price"]
      return [ html_span(price) ]
    else
      throw(PreventUpdate())  
    end
end


handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
