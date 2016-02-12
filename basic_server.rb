require 'socket'

server = TCPServer.open(2000)
loop {
  client = server.accept
  client.puts(Time.now.ctime)
  client.puts("my name is chunyu")
  client.close
}