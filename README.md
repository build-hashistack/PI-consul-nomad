# Nomad starter kit
*it's suggested that this will be used to test features, not to be used for production*

# Topology
```
    **********************************************************************************************************************
    *                                                                                                                    *
    *   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     *
    *   x                                                                                                          x     *
    *   x       xxxxxxxxxxxxxxxxxx                  xxxxxxxxxxxxxxxxxx                  xxxxxxxxxxxxxxxxxx         x     *
    *   x       x                x                  x                x                  x                x         x     *
    *   x       x     SERVER3    x                  x     SERVER4    x                  x     SERVER5    x         x     *
    *   x       x  CONSUL-server x                  x  CONSUL-server x                  x  CONSUL-server x         x     *
    *   x       x    container   x                  x    container   x                  x    container   x         x     *
    *   x       xxxxxxxxxxxxxxxxxx                  xxxxxxxxxxxxxxxxxx                  xxxxxxxxxxxxxxxxxx         x     *
    *   x               |                                   |                                    |                 x     *
    *   x               |-----------------------------------|------------------------------------|-------------|   x     *
    *   x                                                   |                                                  |   x     *
    *   x                                                   |                                                  |   x     *
    *   x                                                   |                                                  |   x     *
    *   x                                                   |                                                  |   x     *
    *   x                        --------------------------------------------------------                      |   x     *
    *   x                        |                                   |                  |                      |   x     *
    *   x  xxxxxxxxxxxxxxxxxxxxxxxxxxx         xxxxxxxxxxxxxxxxxxxxxxxxxxx         xxxxxxxxxxxxxxxxxxxxxxxxx   |   x     *
    *   x  x                | CONSUL x         x                | CONSUL x         x CONSUL |              x   |   x     *
    *   x  x     SERVER0    | client x         x     SERVER1    | client x         x client |   SERVER2    x   |   x     *
    *   x  x  NOMAD-server  ---------x         x  NOMAD-server  ---------x         x--------- NOMAD-server x   |   x     *
    *   x  x   container             x         x   container             x         x           container   x   |   x     *
    *   x  xxxxxxxxxxxxxxxxxxxxxxxxxxx         xxxxxxxxxxxxxxxxxxxxxxxxxxx         xxxxxxxxxxxxxxxxxxxxxxxxx   |   x     *
    *   x                        +              +                                       +                      |   x     *
    *   x                        +              +                                       +                      |   x     *
    *   x                        +              +  ++++++++++++++++++++++++++++++++++++++                      |   x     *
    *   x                        +              +  +                                                           |   x     *
    *   x                        +          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                                |   x     *
    *   x                        +          x NOMAD  |               | CONSUL x--------------------------------|   x     *
    *   x                        ++++++++++-x client |               | client x                                    x     *
    *   x                                   x --------               |--------x             xxxxxxxxxxxxxxxxxxxxxxxx     *
    *   x                                   x             CLIENT0             x             x                      x     *
    *   x                                   x            container            x             x    DOCKER NETWORK    x     *
    *   x                                   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx             x MACVLAN network type x     *
    *   x                                                                                   x                      x     *
    *   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     *
    *                                                                                                      | L |         *
    *        .~~.   .~~.                                                                                   | O |         *
    *       '. \ ' ' / .'                          88                         88                           | G |         *
    *        .~ .~~~..~.                           88                         88                           | I |         *
    *       : .~.'~'.~. :                 88   88  88,888,  88   88  ,88888, 88888  88   88                | C |         *
    *      ~ (   ) (   ) ~                88   88  88   88  88   88  88   88  88    88   88                | A |         *
    *     ( : '~'.~.'~' : )               88   88  88   88  88   88  88   88  88    88   88                | L |         *
    *      ~ .~ (   ) ~. ~                88   88  88   88  88   88  88   88  88    88   88                |   |         *
    *       (  : '~' :  )                 '88888'  '88888'  '88888'  88   88  '8888 '88888'                | B |         *
    *        '~ .~~~. ~'                                                                                   | R |         *
    *                                                                                                      | I |         *
    *                   _                           _                                                      | D |         *
    *   ___ ___ ___ ___| |_ ___ ___ ___ _ _     ___|_|                                                     | G |         *
    *  |  _| .'|_ -| . | . | -_|  _|  _| | |   | . | |                                                     | E |         *
    *  |_| |__,|___|  _|___|___|_| |_| |_  |   |  _|_|                                                xxxxxxxxxxxxxx     *
    *              |_|                 |___|   |_|                                                    x            x     *
    *                                                                                                 x    ETH0    x     *
    *                                                                                                 x            x     *
    **********************************************************************************************************************
                                                                                                           |   |
    *******************************************                                                            | P |
    *    .~~.   .~~.        |--------|--------*                                                            | H |
    *   '. \ ' ' / .'       | CONSUL | NOMAD  *           **********************************               | Y |
    *    .~ .~~~..~.        | client | client *           *                  _             *               | S |
    *   : .~.'~'.~. :       |--------|--------*           *   PHYSICAL      | |            *               | I |
    *  ~ (   ) (   ) ~          _             *-----------*  _ __ ___  _   _| |_ ___ _ __  *               | C |
    * ( : '~'.~.'~' : )     ___|_|            * ETH CABLE * | '__/ _ \| | | | __/ _ \ '__| *               | A |
    *  ~ .~ (   ) ~. ~     | . | |            *-----------* | | | (_) | |_| | ||  __/ |    *---------------| L |
    *   (  : '~' :  )      |  _|_|            *           * |_|  \___/ \__,_|\__\___|_|    * ETHERNET CABLE    |
    *    '~ .~~~. ~'   _   |_|                *           *                                *--------------------
    *  ___ ___ ___ ___| |_ ___ ___ ___ _ _    *           **********************************
    * |  _| .'|_ -| . | . | -_|  _|  _| | |   *                           | E |
    * |_| |__,|___|  _|___|___|_| |_| |_  |   *                           | T |
    *             |_|                 |___|   *                           | H |
    *                                         *                           |   |
    *******************************************                           | C |
                                                                          | A |
                                                                          | B |
                                                        _________________________________________
                                                       / _____________________________________   \
                                                      |                                           |
                                                      | ||--------|--------|                  |   |
                                                      | || CONSUL | NOMAD  |                  |   |
                                                      | || client | client |                  |   |
                                                      | ||--------|--------|                  |   |
                                                      | |                                     |   |
                                                      | |       OLD DELL LAPTOP               |   |
                                                      | |              CAN RUN VMs/CONTAINERS |   |
                                                      | |_____________________________________|   |
                                                      |                                           |
                                                       \__________________________________________/
                                                            \_______________________________/
                                                            __________________________________
                                                            _-'    .-.-.-.-.-.-.-.  --- `-_
                                                         _-'.-.-. .---.-.-.-.-.-.--.  .-.-.`-_
                                                      _-'.-.-.-. .---.-.-.-.-.-.-`__`. .-.-.-.`-_
                                                   _-'.-.-.-.-. .-----.-.-.-.-.-.-----. .-.-.-.-.`-_
                                                _-'.-.-.-.-.-. .---.-. .-------.-.-.---. .---.-.-.-.`-_
                                               :-------------------------------------------------------:
                                               `---._.-------------------------------------------._.---'
```

# How To Use

clone the repository
```bash
git clone git@github.com:build-hashistack/lab.git
```

navigate into the downloaded repo
```bash
cd laba
```

Use docker-compose to bring up or down the containers. Logs will be redirected to the console and thus wouldn't matter if you put & to send the job in the background or not. I use the & to get access of the prompt.
```bash
# You can omit & at the end to if you are not interested in the console logs
# docker-compose is looking for compose.yml in current directory
docker-compose up &
docker-compose down
```

Open a new terminal and list the containers
```bash
⏚ [ion:~/Documents/tmp/nomad] main ± docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                                       NAMES
95f7d3f5f1ce   nomad_server1   "/bin/sh -c 'consul …"   8 minutes ago   Up 8 minutes   0.0.0.0:4001->4646/tcp, :::4001->4646/tcp   nomad_server1_1
c7e3c5b7dea5   nomad_server2   "/bin/sh -c 'consul …"   8 minutes ago   Up 8 minutes   0.0.0.0:4002->4646/tcp, :::4002->4646/tcp   nomad_server2_1
b9a74c27cdad   nomad_server0   "/bin/sh -c 'consul …"   8 minutes ago   Up 8 minutes   0.0.0.0:4000->4646/tcp, :::4000->4646/tcp   nomad_server0_1
ede153f9f09b   nomad_client0   "/bin/sh -c 'consul …"   8 minutes ago   Up 8 minutes                                               nomad_client0_1
d8d403c40db8   nomad_server3   "consul agent --conf…"   8 minutes ago   Up 8 minutes   0.0.0.0:8500->8500/tcp, :::8500->8500/tcp   nomad_server3_1
```

If you have many containers running filter by nomad_
```bash
# https://docs.docker.com/engine/reference/commandline/ps/#filtering
docker container ls --format='{{  $.Names }}' --filter "name=nomad_*"
``` 

You can connect to each individual servers from a new terminal, for example:
```bash
docker container exec -it <CONTAINTER-NAME> bash

```
### About directory structure
Everything starts with compose.yml file.
Contaiers under service stanza will look for the dockerfile in the current directory.
Configuration for nomad and consul binaries are passed by attaching to containers config from data directory.

```
.
├── LICENSE
├── README.md
├── compose.yml
├── consul.dockerfile
├── data
│   ├── client0
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   │       └── nomad-config.hcl
│   ├── client1
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   │       └── nomad-config.hcl
│   ├── server0
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   │       └── nomad-config.hcl
│   ├── server1
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   │       └── nomad-config.hcl
│   ├── server2
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   │       └── nomad-config.hcl
│   ├── server3
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   ├── server4
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   ├── server5
│   │   ├── consul
│   │   │   └── consul-config.hcl
│   │   └── nomad
│   └── start_container.sh
└── nomad.dockerfile
```


 