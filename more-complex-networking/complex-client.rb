require 'socket'
host, port = ARGV

begin   # begin for exception handling
  #giving user feedback when connecting
  STDOUT.print "Connecting..."  #saying we are connecting
  STDOUT.flush                  #make sure its visible
  s = TCPSocket.open(host, port)#connect
  STDOUT.puts "Done"            # say we connected

  #now display info about the connection
  local, peer = s.addr, s.peeraddr
  STDOUT.print "Connected to #{peer[2]}: #{peer[1]}"
  STDOUT.puts "using local port #{local[1]}"

  #Wait a little, to see if the sever sends any initial message.
  begin
    sleep(0.5)                # wait for half a second
    msg = s.read_nonblock(4096) # read whatever is ready
    STDOUT.puts msg.chop        # display the thing we read
  rescue SystemCallError
    # If nothing was ready to read, just ignore the exception
  end

  # above code just simply display the info from sever
  # now begin a loop for client and server interaction
  loop do
    STDOUT.print ">"   # give a prompt
    STDOUT.flush       # make sure it is visible
    local = STDIN.gets # read line from the console
    break if !local    # break if no input from console

    s.puts(local)      # send the prompt we get from console to server
    s.flush            # force it out

    # Read the server's response and print out.
    # The server may send more than one line, so use readpartial
    # to read whatever it sends(as long as it all come in onc chunk)
    response = s.readpartial(4096) # read server's response
    puts(response.chop)            # display to user
  end
rescue      # if anything gose wrong
  puts $!   # display the exception to user
ensure
  s.close if s # close the socket
end

