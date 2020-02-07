module BitMEX

export open_websocket, trades

import JSON
using WebSockets

uri = "wss://www.bitmex.com/realtime?subscribe=trade:XBT"

trades = []

function open_websocket() 
  WebSockets.open(uri) do ws
    while isopen(ws)
      data, success = readguarded(ws)
      if success
        data = JSON.parse(String(data))

        table = get(data, "table", nothing)
        action = get(data, "action", nothing)

        if table == "trade" && action == "insert"
          trade_data = get(data, "data", nothing)

          for trade in trade_data
            pushfirst!(trades, trade)
            if length(trades) > 25
              pop!(trades) 
            end
          end

        end
      end
    end

    if !isopen(ws)
      @async open_websocket()
    end

  end
end

end
