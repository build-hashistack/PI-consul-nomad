datacenter = "dc1"
data_dir = "/opt/consul"

server = true
bootstrap_expect = 3

ui_config {
    enabled = true
    }
    
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

retry_join = ["server3", "server4", "server5"]