import HTTP
using Dashboards

include("bigquery.jl")
include("bitmex.jl")
using .BigQuery
using .BitMEX

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

data_frame = load_dataframe("2020-01-01", "2020-01-01")

@async open_websocket()

app = Dash("Test app", external_stylesheets=external_stylesheets) do
    html_div() do
        html_h1("Hello Dashboards"),
        html_div("Dashboards: Julia interface for Dash"; id = "live-update-text"),
        dcc_graph(
            id = "example-graph",
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
        ),
        dcc_interval(
            id = "interval-component",
            interval = 1 * 1000,
            n_intervals = 0
        )
    end
end


callback!(app, callid"interval-component.n_intervals => live-update-text.children") do n_intervals
    if length(trades) > 0
      price = trades[1]["price"]
      return [ html_span(price) ]
    end

    return []
end

handler = make_handler(app, debug = true)
HTTP.serve(handler, "0.0.0.0", port)
