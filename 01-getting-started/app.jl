import HTTP
using Dashboards

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]

app = Dash("Test app", external_stylesheets=external_stylesheets) do
    html_div() do
        html_h1("Hello Dashboards"),
        html_div("Dashboards: Julia interface for Dash"),
        dcc_graph(
            id = "example-graph",
            figure = (
                data = [
                    (x = [1, 2, 3], y = [4, 1, 2], type = "bar", name = "SF"),
                    (x = [1, 2, 3], y = [2, 4, 5], type = "bar", name = "Montréal"),
                ],
                layout = (title = "Dash Data Visualization",)
            )
        )
    end
end

handler = make_handler(app, debug = true)
HTTP.serve(handler, "0.0.0.0", port)
