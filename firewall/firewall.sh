#!/bin/sh

# On vide les regles deja existantes
iptables -t filter -F
iptables -t filter -X

# On refuse toutes les connexions
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP

# On autorise les connexions déjà établie
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# On autorise le loop-back (localhost)
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# On autorise le ping
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT

# On autorise le SSH (a adapter suivant votre cas)
iptables -t filter -A INPUT -p tcp --dport 6060 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 6060 -j ACCEPT

# On autorise le RSYNC (a adapter suivant votre cas)
#iptables -t filter -A INPUT -p tcp --dport 873 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 873 -j ACCEPT

# Si on a un serveur DNS
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

# Activation du port IRC securiser (ssl; standard) (hexchat; irssi)
iptables -t filter -A OUTPUT -p tcp --dport 6697 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 6697 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 6667 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 6667 -j ACCEPT

# NTP (pour avoir un serveur à l'heure)
#iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

# HTTP and HTTPS
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
#iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT

# FTP
iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
#iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

############### MAIL ################
## SMTP
#iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

## POP3
#iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

## IMAP
#iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
## trafic IMAP sur le port 143 autorisé"

## POP3S
#iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
#iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
