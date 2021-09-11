datacenter = "dc1"
data_dir = "/opt/nomad"

client {
  enabled = true
  servers = ["server0", "server1", "server2"]
  server_join {
    retry_join = ["server0", "server1", "server2"]
  }
}