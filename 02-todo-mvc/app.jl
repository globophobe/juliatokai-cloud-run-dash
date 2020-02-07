import HTTP
import UUIDs
using Dashboards

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port


ALL = "All"
ACTIVE = "Active"
COMPLETED = "Completed"

INIT_STATE = Dict( "todos" => [], "activeState" => ALL )


app = Dash("Todo MVC", ) do
    html_div() do
        dcc_radioitems(
            id = "todo-filter",
            options = [
                Dict( "label" => label, "value" => label ) 
                for label in ( ALL, ACTIVE, COMPLETED )
            ],
            value = ALL
        ),
        dcc_input( 
            id = "add-todo", 
            placeholder = "What needs to be done?", 
            debounce = true 
        ),
        html_div( id = "todo-container", children = (
            dcc_checklist( id = "todo-list" )
        )),
				html_div( id = "fuck-you" ),
				dcc_store( id = "todo-state", data = INIT_STATE )
  end
end



callback!(app, callId"""
        { todo-state.data } add-todo.value => fuck-you.children
    """) do data, value
    uuid = UUIDs.uuid4()
    todo = Dict( "uuid" => "$(uuid)", "todo" => value, "state": ACTIVE )
    push!(data["todos"], todo)
end


callback!(app, callId"todo-state.data => todo-list.options") do data
    states = data["activeState"] == ALL ? ( ACTIVE, COMPLETED) : ( data["activeState"], )
    [ 
        ( label = todo["label"], value = todo["uuid"] )
        for todo in data["todos"] if todo["state"] in states
    ]
end

handler = make_handler(app, debug = false)
HTTP.serve(handler, "0.0.0.0", port)
