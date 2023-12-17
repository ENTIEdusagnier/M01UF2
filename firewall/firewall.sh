#!/bin/bash

iptables -F

iptables -P DROP

iptables -A INPUT -s 10.65.0.15 -p tcp --dport 2222 -j ACCEPT

iptables -A OUTPUT -d 10.65.0.15 -p tcp --sport 2222 -j ACCEPT

iptables -A INPUT -p tcp --dport 3333 -j ACCEPT

iptables -A OUTPUT -p tcp --sport 3333 -j ACCEPT
