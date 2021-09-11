#/bin/bash
/usr/bin/consul agent -config-dir=/etc/consul.d/ &
/usr/bin/nomad agent -config=/etc/nomad.d