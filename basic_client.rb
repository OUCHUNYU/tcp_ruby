require 'socket'

host, port = ARGV

TCPSocket.open(host, port) do |s|
  while line = s.gets
    puts line.chop
  end
end