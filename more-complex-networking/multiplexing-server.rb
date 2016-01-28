# This server reads a line from a client input and reverse it
# and sends it back. If the client sends the string "quit"
# it disconnects. it uses Kernel.select to handle multiple sessions.

require 'socket'

server = TCPServer.open(2000) # Listen to port 2000
sockets = [server]            # an array of sockets we monitor
log = STDOUT                  # send log message to stdout
while true                    # server loops forever
  ready = select(sockets)      # wait for a socket to be ready
  readable = ready[0]         # These sockets are readable

  readable.each do |socket|   # loop thru readable sockets
    if socket == server       # if the server socket is ready
      client = server.accept  # wait for a new client and accept it
      sockets << client       # add it to the set of sockets
      # tell the client what and where it has connected
      client.puts "Reversal service v0.01 running on #{Socket.gethostname}"
      # and log the fact that the client connected
      log.puts "Accepted connection from #{client.peeraddr[2]}"
    else               # otherwise, a client is ready for interaction
      input = socket.gets     # read input from the client

      # If no input, the client has disconnected
      if !input
        log.puts "Client on #{socket.peeraddr[2]} disconnected."
        sockets.delete(socket)   # stop monitoring this socket
        socket.close             # and close it
        next                  # move on to next in the set of sockets
      end

      input.chop!     # Trim client input
      if (input == "quit") # if the client asks to quit
        socket.puts("Bye!");   # say bye
        log.puts "Closing connection to #{socket.peeraddr[2]}"
        sockets.delete(socket)  # stop monitoring it
        socket.close         # ternimate
      else         # otherwise the client is still with us
        socket.puts(input.reverse)    # reverse input and send it back
      end
    end
  end
end

