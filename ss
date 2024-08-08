---
tags: [ networking ]
---

# description
ss: socket statistics is an alternative / update to netstat
used to dump socket statistics and displays information in similar fashion (although simpler and faster) to netstat. The ss command can also display even more TCP and state information than most other tools. Because ss is the new netstat, we’re going to take a look at how to make use of this tool so that you can more easily gain information about your Linux machine and what’s going on with network connections.

# install

# command args
-4/-6 list ipv4/ipv6 sockets
-n numeric addresses instead of hostnames
-l list listing sockets
-u/-t/-x list udp/tcp/unix sockets
-p Show process(es) that using socket

# show all listening tcp sockets including the corresponding process
ss -tlp

# show all sockets connecting to 192.168.2.1 on port 80
ss -t dst 192.168.2.1:80

# show all ssh related connection
ss -t state established '( dport = :ssh or sport = :ssh )'

# list all connections
ss

# listening and non-listening ports
ss -a

# listening sockets
ss -l

# list all TCP connections
ss -t

# all listencing TCP connections
ss -lt

# all UDP
ss -ua

# all listening UDP
ss -lu

# display PID of sockets
ss -p

# summary stats
ss -s

# ipv4
ss -4

# ipv6
ss -6

# filter by port
ss -at '( dport = :22 or sport = :22 )'
##or
ss -at '( dport = :ssh or sport = :ssh )'
