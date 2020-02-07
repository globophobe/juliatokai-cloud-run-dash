module Chart

export get_figure
  
function get_figure(data_frame)
    if size(data_frame, 1) > 0
        return (
            data = [
                ( x = data_frame.timestamp, 
                  open = data_frame.level, 
                  high = data_frame.level, 
                  low = data_frame.level, 
                  close = data_frame.level, 
                  type = "candlestick", 
                  name = "XBTUSD"
                ),
            ],
            layout = (title = "Dash Data Visualization",)
        )
    end
end

end
