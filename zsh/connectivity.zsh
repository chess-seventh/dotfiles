
# =========================
# CONNECTIVITY
# =========================

alias powerhub='sudo netctl-auto switch-to wlp61s0-PowerHub'
alias powerhorse='sudo netctl-auto switch-to wlp61s0-PowerHorse'

stopcon() {
        sudo protonvpn d
        sudo ip link set wlp61s0 down
        sudo macchanger -p wlp61s0
}

homecon() {
        sudo protonvpn d
        sudo ip link set wlp61s0 down
        sudo macchanger -p wlp61s0
        sudo ip link set wlp61s0 up
        sudo netctl-auto switch-to wlp61s0-PowerHub
}

phonecon() {
        sudo protonvpn d
        sudo ip link set wlp61s0 down
        sudo macchanger -p wlp61s0
        sudo netctl-auto switch-to wlp61s0-Hulabaloo
}


wifipublic() {
        set -e
        sudo protonvpn d
        sudo ip link set wlp61s0 down
        sudo macchanger -r wlp61s0
        sudo ip link set wlp61s0 up
        sudo wifi-menu
        while [[ -z $(ip add | grep wlp61s0 | awk -F 'inet' '{ print $2 }' | awk '{ print $1 }') ]]; do
                sleep 1
        done
        sudo protonvpn c --sc
        sudo protonvpn s
}

lip() {
        echo $(ip add | grep inet | grep -v '::' | grep -v '/16' | grep -v '/8' | awk '{ print $2 }')
}

macreset() {
        sudo protonvpn d
        sudo ip link set wlp61s0 down
        sudo macchanger -p wlp61s0
        sudo ip link set wlp61s0 up
}

## CONNECT TO BM VPN
#

amiconnected() {
        if [[ -z $(pidof openvpn) ]]; then
                echo false
        else
                echo true
        fi
}

vpn_bm () {
        set -e
        echo $(pass work/bestmile/user) > /home/seventh/.vpns/bm.txt
        echo $(pass work/bestmile/jumpcloud) >> /home/seventh/.vpns/bm.txt
        chmod 0600 /home/seventh/.vpns/bm.txt
        sudo openvpn --config /home/seventh/.vpns/gate-TCP4-1194-vpn.bestmile.ch.ovpn --pkcs12 /home/seventh/.vpns/gate-TCP4-1194-vpn.bestmile.ch.p12 --tls-auth /home/seventh/.vpns/gate-TCP4-1194-vpn.bestmile.ch-tls.key --auth-user-pass /home/seventh/.vpns/bm.txt --daemon
        rm /home/seventh/.vpns/bm.txt
}

discon_vpn () {
        sudo cp /etc/resolv.conf-home /etc/resolv.conf
        sudo kill -9 $(pidof openvpn)
}

