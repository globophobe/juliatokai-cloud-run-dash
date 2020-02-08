module CSS

export header, flex_column, flex_row, up, down

header = Dict( "width" => "80%" )

flex_row = Dict( 
    "display" => "flex", 
    "flex-direction" => "row", 
    "flex-wrap" => "wrap", 
    "width" => "100%"
)

flex_column = Dict(
    "display" => "flex", 
    "flex-direction" => "column", 
    "flex-basis" => "100%", 
    "flex" => 1 
)

up = Dict( "color" => "green" )

down = Dict( "color" => "red" )

end
