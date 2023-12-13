
`iptables -F`

`iptables -A INPUT -s 10.65.0.59 -p tcp --dport 3333 -j ACCEPT`

`iptables -A INPUT -p tcp --dport 3333 -j DROP`
