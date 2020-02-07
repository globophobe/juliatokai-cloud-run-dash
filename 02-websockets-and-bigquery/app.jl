import HTTP
using Dashboards
using Dates

include("chart.jl")
using .Chart
include("bitmex.jl")
using .BitMEX

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

@async open_websocket()

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
        dcc_store( id = "state", data = Dict( "min_size" => 0 )),
        dcc_interval(
            id = "candle-interval",
            interval = 5000,
            n_intervals = 0
        ),
        dcc_interval(
            id = "trade-interval",
            interval = 250,
            n_intervals = 0
        ),
        html_div( style = row_css ) do
            html_div( style = column_css ) do
                dcc_datepickersingle( 
                    id = "datepicker", 
                    min_date_allowed = Dates.Date(2016, 5, 13),
                    max_date_allowed = Dates.today()
                ),
                dcc_graph( id = "chart", figure = get_figure("2019-01-01") )
            end,
            html_div( style = column_css ) do
                html_div( id = "trades" )
            end
        end
    end
end


callback!(app, callid"datepicker.date => chart.figure") do date
    if isnothing(date) throw(PreventUpdate()) end 
    
    figure = get_figure(date)

    if isnothing(figure) 
        throw(PreventUpdate()) 
    else
        return figure
    end
end



callback!(app, callid"interval.n_intervals => trades.children") do n_intervals
    if length(trades) == 0 throw(PreventUpdate()) end

    price = trades[1]["price"]

    [ html_table() do
        html_tr( style = trade["tickDirection"] in UP_TICKS ? up_css : down_css) do
            html_td( trade["price"] ),
            html_td( trade["size"] ) 
        end
      end

      for trade in trades
    ]
end


handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
