#!/bin/bash

PORT_SSH=2222
PORT_REDIRECT=6666
PORT_MYSQL=3306
IP_SSH=10.65.0.24
IP_REMOTE=10.65.0.83

./firewall_reset.sh

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP


iptables -A INPUT -s $IP_REMOTE -p tcp --dport $PORT_SSH -j ACCEPT #SSH Client
iptables -A OUTPUT -d $IP_REMOTE -p tcp --sport $PORT_SSH -j ACCEPT #SSH Client

iptables -A INPUT -s $IP_SSH -p tcp --dport $PORT_SSH -j ACCEPT #SSH Owner
iptables -A OUTPUT -d $IP_SSH -p tcp --sport $PORT_SSH -j ACCEPT #SSH Owner


iptables -A INPUT -s localhost -p tcp --dport $PORT_MYSQL -j ACCEPT #MYSQL to local
iptables -A OUTPUT -d localhost -p tcp --sport $PORT_MYSQL -j ACCEPT #MYSQL to local


iptables -A INPUT -s $IP_REMOTE -p tcp --dport $PORT_REDIRECT -j ACCEPT # Accept Port Prerouting Mysql
iptables -A OUTPUT -d $IP_REMOTE -p tcp --sport $PORT_REDIRECT -j ACCEPT # Accept Port Prerouting Mysql

iptables -t nat -A PREROUTING -p tcp --dport $PORT_REDIRECT -j REDIRECT --to-port $PORT_MYSQL
iptables -t nat -A PREROUTING -p tcp --sport $PORT_MYSQL -j REDIRECT --to-port $PORT_REDIRECT

iptables -t nat -A PREROUTING -s $IP_REMOTE -p tcp --dport $PORT_REDIRECT -j SNAT --to 127.0.0.1:3306
iptables -t nat -A PREROUTING -s 127.0.0.1 -p tcp --dport $PORT_MYSQL -j DNAT --to 10.65.0.83:6666
