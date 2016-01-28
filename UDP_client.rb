require 'socket'

host, port, request = ARGV

ds = UDPSocket.new
ds.connect(host, port)
ds.send(request, 0) #when using send method this second argu 0 must show up
response, address = ds.recvfrom(1024)
puts response
