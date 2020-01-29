using HTTP

port = get(ENV, "PORT", 8080)
port = port isa String ? parse(Int64, port) : port

HTTP.listen("0.0.0.0", port, verbose = true) do http
  write(http,  "OK")
end
