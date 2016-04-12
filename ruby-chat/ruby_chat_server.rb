require 'socket'

class Server

  attr_accessor :server, :users   # personal preference, i don't like seeing @@@@@

  def initialize(host, port)
    @server = TCPServer.open(host, port)  # connecting to the host name and ip
    @users = []                 # This is an array to store another client object
  end

  def run
    loop {             # This Server works forever.
      Thread.new(server.accept) do |client|        # Create a new thread for each user
        users << client                         # Push the every client to the array
        client.puts "Now connected to Server."    # Give a message you are in
        another_user(client)                   # This is function below
      end
    }.join                   # Make sure it runs to complete.
  end

  def another_user(client)
    loop {                    # The connection between 2 users forever
      msg = client.gets.chomp   # read a client message
      users.reject {|user| user == client}.each {|x| x.puts "#{msg}"}  # reject the user that
      puts "#{msg}"
                                                      # is the user who sent the message. And send msg to another user.
    }
  end
end

server = Server.new("172.16.50.84", 3366)
server.run