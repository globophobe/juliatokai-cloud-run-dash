module Chart

using PlotlyBase

export get_figure
  
function get_figure(data_frame)
    if size(data_frame, 1) > 0
        return (
            data = [
                ( x = [ sum( data_frame.buyVolume ) ], 
                  type = "bar", 
                  name = "Buy"
                ),
                ( x = [ sum( data_frame.sellVolume ) ], 
                  type = "bar", 
                  name = "Sell"
                ),
            ],
            layout = (title = "XBTUSD",)
        )
    end
end

end
