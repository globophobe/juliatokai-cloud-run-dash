import HTTP
using Dashboards

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

ALL = "All"
ACTIVE = "Active"
COMPLETED = "Completed"

MAX_TODOS = 10
INIT_STATE = Dict( "todos" => [nothing for i in 1:MAX_TODOS], "active_state" => ALL )


function all_todos(todos)
    [
        html_div(
            id = "todo-container-$index",
            style = Dict( "display" => isnothing(todo) ? "none" : "block" ),
            children = [
                html_span( children = isnothing(todo) ? "" : todo.value ; id = "todo-display-$index" ),
                html_button( "Done" ; id = "todo-check-$index" )
            ]
        )

        for (index, todo) in enumerate(todos)
    ]
end


app = Dash("App") do
    html_div() do
        dcc_input( id = "add-todo", debounce = true ),
        html_div( id = "todo-list", children = all_todos(INIT_STATE["todos"]) ),
        dcc_store( id = "store", data = INIT_STATE )
    end
end

callback!(app, callid"{ todo-list.children } add-todo.value => todo-list.children") do children, value           
    if !isa(value, String)
        throw(PreventUpdate())
    end

    bound_todos = [child for child in children if child.props.style != "none"]
    index = length(bound_todos) + 1

    if index > 10
        throw(PreventUpdate())
    end

    data.todos[id] = Dict( "id" => id , "value" => value, "state" => 1)

    return data
end


for index in 1:MAX_TODOS
    input = Symbol("todo-check-$index"), :value
    output = Symbol("todo-display-$index"), :children
    callback!(app, CallbackId( input = input, output = output )) do value
        if value

        end
    end
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
