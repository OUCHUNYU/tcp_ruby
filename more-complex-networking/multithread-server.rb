require 'socket'

def client_handler(c)
  while true   # keeps the connection with a client
    input = c.gets.chop  # trims the client's input
    break if !input  # break if no input
    break if input == "quit"  # or if client says quit
    c.puts(input.reverse) #otherwise response the client
    c.flush # force it out
  end
  c.close   # make sure to close a client socket
end

server = TCPServer.open(2000) # listen to port 2000

while true      # loops forever to keep server open
  client = server.accept  # wait for a client to connect
  Thread.new(client) do |c|  # start a new thread for a new client
    client_handler(c)  # and handle client's request
  end
end

