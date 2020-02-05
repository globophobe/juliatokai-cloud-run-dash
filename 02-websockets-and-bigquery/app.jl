import HTTP
using Dashboards
using Dates

include("bigquery.jl")
include("bitmex.jl")
using .BigQuery
using .BitMEX

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]


@async open_websocket()

app = Dash("XBTUSD", external_stylesheets=external_stylesheets) do
    html_div() do
        html_h1("Hello Dashboards"),
        html_div("Dashboards: Julia interface for Dash"; id = "table"),
        dcc_datepickerrange( 
            id = "date-range", 
            min_date_allowed = Dates.Date(2016, 5, 13),
            max_date_allowed = Dates.today()
        ),
        dcc_graph( id = "chart" ),
        dcc_interval(
            id = "interval",
            interval = 1000,
            n_intervals = 0
        )
    end
end

callback!(app, callid"""
        date-range.start_date, date-range.end_date => chart.figure
    """) do start_date, end_date

    data_frame = load_dataframe(start_date, end_date)
    figure = (
        data = [
            ( x = data_frame.timestamp, 
              open = data_frame.open, 
              high = data_frame.high, 
              low = data_frame.low, 
              close = data_frame.close, 
              type = "candlestick", 
              name = "XBTUSD"
            ),
        ],
        layout = (title = "Dash Data Visualization",)
    )
    return figure
end


callback!(app, callid"""
        interval.n_intervals => table.children
    """) do n_intervals

    if length(trades) > 0
      price = trades[1]["price"]
      return [ html_span(price) ]
    end

    return []
end

handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
