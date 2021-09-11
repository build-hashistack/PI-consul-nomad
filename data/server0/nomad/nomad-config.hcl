datacenter = "dc1"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 3
   retry_join = [ "server0", "server1", "server2" ]
}

consul {
  address = "127.0.0.1:8500"
}