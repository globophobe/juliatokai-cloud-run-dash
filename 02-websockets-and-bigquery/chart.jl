module Chart

import StatsBase: fit, Histogram
using Plotly

include("constants.jl")
using .Constants: LEVEL

export get_figure


function get_figure(data_frame)
    buy_df = data_frame[( data_frame.buyVolume .> 0, :]
    sell_df = data_frame[( data_frame.sellVolume .> 0, :]

    buy_histogram = get_histogram(buy_df.price)
    sell_histogram = get_histogram(sell_df.price)

    buy_trace = get_trace(buy_histogram)
    sell_trace = get_trace(sell_histogram)

    data = [ buy_trace, sell_trace ]
    layout = ( title = "XBTUSD", )

    return data, layout
end


function get_trace(histogram)
    ( y = histogram.weights, ybins = 
end


function get_histogram(series)
    min_price = minimum(series)
    max_price = maximum(series)

    start = floor(series / LEVEL) * LEVEL
    stop = (floor(series / LEVEL) * LEVEL) + LEVEL

    edges = start:LEVEL:stop

    fit(Histogram, series, edges)
end


end
