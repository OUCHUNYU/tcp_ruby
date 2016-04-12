require "socket"

class Client
  def initialize(server)
    @server = server     # create server
    @request = nil       # each time refresh
    @response = nil
    listen               # call the funtion
    send                 # call another function
    @request.join        # make sure everything runs untill the end
    @response.join
  end

  def listen
    @response = Thread.new do      # For each function we create a new thread so
      loop {                       # that a user can use all functions at the same
        msg = @server.gets.chomp   # time. Otherwise, the user can send message only
        puts "#{msg}"              # after the other user has sent back something.
      }
    end
  end

  def send
    @request = Thread.new do
      loop {                       # Both loops forever.
        msg = $stdin.gets.chomp
        @server.puts "#{msg}"
      }
    end
  end
end

server = TCPSocket.open( "172.16.50.84", 3366 )   # Connecting to server
Client.new(server)