#! /bin/sh
### BEGIN INIT INFO
# Provides:          PersonalFirewall
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Personal Firewall
# Description:
### END INIT INFO

# programme iptables IPV4 et IPV6
IPT=/sbin/iptables
IP6T=/sbin/ip6tables

# fonction qui démarre le firewall
do_start() {

    # Efface toutes les règles en cours. -F toutes. -X utilisateurs
    $IPT -t filter -F
    $IPT -t filter -X
    $IPT -t nat -F
    $IPT -t nat -X
    $IPT -t mangle -F
    $IPT -t mangle -X
    #
    $IP6T -t filter -F
    $IP6T -t filter -X
    # Il n'y a pas de NAT en IPV6
    #$IP6T -t nat -F
    #$IP6T -t nat -X
    $IP6T -t mangle -F
    $IP6T -t mangle -X

    # stratégie (-P) par défaut : bloc tout l'entrant le forward et autorise le sortant
    $IPT -t filter -P INPUT DROP
    $IPT -t filter -P FORWARD DROP
    $IPT -t filter -P OUTPUT ACCEPT
    #
    $IP6T -t filter -P INPUT DROP
    $IP6T -t filter -P FORWARD DROP
    $IP6T -t filter -P OUTPUT ACCEPT

    # Loopback
    $IPT -t filter -A INPUT -i lo -j ACCEPT
    $IPT -t filter -A OUTPUT -o lo -j ACCEPT
    #
    $IP6T -t filter -A INPUT -i lo -j ACCEPT
    $IP6T -t filter -A OUTPUT -o lo -j ACCEPT

    # Permettre à une connexion ouverte de recevoir du trafic en entrée
    $IPT -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IPT -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    #
    $IP6T -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IP6T -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # On autorise le ping
    $IPT -t filter -A INPUT -p icmp -j ACCEPT
    $IPT -t filter -A OUTPUT -p icmp -j ACCEPT
    #
    $IP6T -t filter -A INPUT -p icmp -j ACCEPT
    $IP6T -t filter -A OUTPUT -p icmp -j ACCEPT

    # On autorise le SSH (a adapter suivant votre cas)
    $IPT -t filter -A INPUT -p tcp --dport 6060 -j ACCEPT
    $IP6T -t filter -A OUTPUT -p tcp --dport 6060 -j ACCEPT

    # On autorise le RSYNC (a adapter suivant votre cas)
    #IPT -t filter -A INPUT -p tcp --dport 873 -j ACCEPT
    #IPT -t filter -A OUTPUT -p tcp --dport 873 -j ACCEPT

    # DNS:53
    # /!\ Il faut autoriser le DNS AVANT de déclarer des hosts sinon pas de résolution de nom possible
    $IPT -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
    $IPT -t filter -A INPUT -p udp --dport 53 -j ACCEPT
    $IPT -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
    $IPT -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
    #
    $IP6T -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
    $IP6T -t filter -A INPUT -p udp --dport 53 -j ACCEPT
    $IP6T -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
    $IP6T -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT

    # Activation du port IRC securiser (ssl; standard) (hexchat; irssi)
    $IPT -t filter -A OUTPUT -p tcp --dport 6697 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 6697 -j ACCEPT
    $IPT -t filter -A OUTPUT -p tcp --dport 6667 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 6667 -j ACCEPT

    # NTP (pour avoir un serveur à l'heure)
    #$IPT -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

    # HTTP and HTTPS
    $IPT -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
    $IPT -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
    #$IPT -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT

    # FTP
    $IPT -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
    $IPT -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
    $IPT -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
    #$IPT -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    ############### MAIL ################
    ## SMTP
    #$IPT -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
    #$IPT -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT

    ## POP3
    #$IPT -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
    #$IPT -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

    ## IMAP
    #$IPT -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
    #$IPT -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
    # trafic IMAP sur le port 143 autorisé"

    ## POP3S
    #$IPT -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
    #$IPT -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT

    echo "firewall started [OK]"
}

# fonction qui arrête le firewall
do_stop() {

    # Efface toutes les règles
    $IPT -t filter -F
    $IPT -t filter -X
    $IPT -t nat -F
    $IPT -t nat -X
    $IPT -t mangle -F
    $IPT -t mangle -X
    #
    $IP6T -t filter -F
    $IP6T -t filter -X
    #$IP6T -t nat -F
    #$IP6T -t nat -X
    $IP6T -t mangle -F
    $IP6T -t mangle -X

    # remet la stratégie
    $IPT -t filter -P INPUT ACCEPT
    $IPT -t filter -P OUTPUT ACCEPT
    $IPT -t filter -P FORWARD ACCEPT
    #
    $IP6T -t filter -P INPUT ACCEPT
    $IP6T -t filter -P OUTPUT ACCEPT
    $IP6T -t filter -P FORWARD ACCEPT

    #
    echo "firewall stopped [OK]"
}

# fonction status firewall
do_status() {

    # affiche les règles en cours
    clear
    echo Status IPV4
    echo -----------------------------------------------
    $IPT -L -n -v
    echo
    echo -----------------------------------------------
    echo
    echo status IPV6
    echo -----------------------------------------------
    $IP6T -L -n -v
    echo
}

case "$1" in
    start)
        do_start
        # quitte sans erreur
        exit 0
    ;;

    stop)
        do_stop
        # quitte sans erreur
        exit 0
    ;;

    restart)
        do_stop
        sleep 2
        do_start
        # quitte sans erreur
        exit 0
    ;;

    status)
        do_status
        # quitte sans erreurs
        exit 0
    ;;

    *)
        # Si on ne tape ni "start" ni "stop"... on affiche une erreur
        echo "Usage: /etc/init.d/firewall {start|stop|restart|status}"
        # quitte le script avec un etat "en erreur"
        exit 1
    ;;

esac