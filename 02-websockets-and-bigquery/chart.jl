module Chart

using PlotlyBase

include("bigquery.jl")
using .BigQuery

export get_figure
  
function get_figure(date)
    data_frame = load_dataframe(date)
    if size(data_frame, 1) > 0
        return (
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
            layout = (title = "XBTUSD",)
        )
    end
end

end
