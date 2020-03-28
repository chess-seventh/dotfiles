
alias bigdirs='du -a ./ | sort -n -r | head -n 5'


# =========================
# PROTON / HOME VPN connections
# =========================

alias pvpn='sudo  protonvpn c --sc'
alias pvpnr='sudo protonvpn c -r'
alias pvpnrr='sudo protonvpn reconnect'
alias pvpnd='sudo protonvpn d'
alias pvpns='sudo protonvpn s'
alias pvpne='sudo protonvpn examples'
alias pvpnch='sudo protonvpn c --cc CH'

# =========================
# AWS / KUBECTL ALIASES
# =========================

alias tf='terraform'
alias kb='kubectl'


# =========================
# EMAIL
# =========================

alias off_bm='offlineimap -a Bestmile 1>& /dev/null & disown'
alias off_fp='offlineimap -a FrancescoOnline 1>& /dev/null & disown'

