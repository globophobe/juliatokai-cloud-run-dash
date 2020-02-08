import HTTP
using Dashboards
using Dates

include("chart.jl")
using .Chart
include("bigquery.jl")
using .BigQuery
include("bitmex.jl")
using .BitMEX

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

@async open_websocket()

LAST_WEEK = Dates.today() - Dates.Week(1)
DATE_FROM = Dates.format(LAST_WEEK, "Y-mm-dd")

data_frame = load_dataframe(DATE_FROM)

UP_TICKS = ("PlusTick", "ZeroPlusTick")

row_css = Dict( 
    "display" => "flex", 
    "flex-direction" => "row", 
    "flex-wrap" => "wrap", 
    "width" => "100%"
)

column_css = Dict(
    "display" => "flex", 
    "flex-direction" => "column", 
    "flex-basis" => "100%", 
    "flex" => 1 
)

up_css = Dict( "color" => "green" )
down_css = Dict( "color" => "red" )

app = Dash("XBTUSD") do
    html_div() do
        dcc_interval(
            id = "interval",
            interval = 250,
            n_intervals = 0
        ),
        dcc_slider( id = "slider", min = 0, max = 10, step = 0.5, value = 0 ),
        html_div( style = row_css ) do
            html_div( style = column_css ) do
                dcc_graph( id = "chart", figure = get_figure(data_frame) )
            end,
            html_div( style = column_css ) do
                html_div( id = "trades" )
            end
        end
    end
end


callback!(app, callid"slider.value => chart.figure") do value
    if isnothing(value) throw(PreventUpdate()) end 
   
    df = data_frame[( data_frame.notional .> value ), :]
    figure = get_figure(df)
    
    println(figure)
  
    figure
end


callback!(app, callid"""
          { slider.value } interval.n_intervals => trades.children"""
    ) do value, n_intervals

    if length(trades) == 0 throw(PreventUpdate()) end

    filtered = [ trade for trade in trades if trade["notional"] >= value ]

    if length(filtered) > 50
        filtered = view(filtered, 1:50)
    end

    [ html_table() do
        html_tr( style = trade["tickDirection"] in UP_TICKS ? up_css : down_css) do
            html_td( trade["price"] ),
            html_td( trade["size"] ) 
        end
      end

      for trade in filtered
   ]
end


handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
