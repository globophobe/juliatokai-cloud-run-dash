import HTTP
using Dashboards

include("chart.jl")
using .Chart
include("bigquery.jl")
using .BigQuery
include("bitmex.jl")
using .BitMEX
include("constants.jl")
using .Constants
include("css.jl")
using .CSS

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

@async open_websocket()

data_frame = load_dataframe(DATE_FROM)

app = Dash("XBTUSD") do
    html_div() do
        dcc_interval(
            id = "interval",
            interval = 250,
            n_intervals = 0
        ),
        html_div( style = header ) do
            html_h1( id = "header" )
        end,
        dcc_slider( id = "slider", min = 0, max = 10, step = 0.5, value = 0 ),
        html_div( style = flex_row ) do
            html_div( style = flex_column ) do
                dcc_graph( id = "chart", figure = get_figure(data_frame) )
            end,
            html_div( style = flex_column ) do
                html_div( id = "trades" )
            end
        end
    end
end


callback!(app, callid"slider.value => header.children") do value
    if isnothing(value) throw(PreventUpdate()) end

    "XBUSD $value notional"
end


callback!(app, callid"slider.value => chart.figure") do value
    if isnothing(value) throw(PreventUpdate()) end 
   
    df = data_frame[( data_frame.notional .> value ), :]

    if size(data_frame, 1) == 0 throw(PreventUpdate()) end

    get_figure(df)
end


callback!(app, callid"""
          { slider.value } interval.n_intervals => trades.children"""
    ) do value, n_intervals

    if length(trades) == 0 throw(PreventUpdate()) end

    filtered = [ trade for trade in trades if trade["notional"] >= value ]

    if length(filtered) > MAX_TRADES
        filtered = view(filtered, 1:MAX_TRADES)
    end

    [ html_table() do
        html_tr( style = trade["tickDirection"] in UP_TICKS ? up : down) do
            html_td( trade["price"] ),
            html_td( trade["size"] ) 
        end
      end

      for trade in filtered
   ]
end


handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
