# VPN Autocomplete for Bash (MacPorts)
# Paste by typing sudo nano ~/.bashprofile
# Remember to apply changes after saving by entering: source ~/.bash_profile
_vpn_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local configs=$(ls /opt/local/etc/wireguard/*.conf 2>/dev/null | xargs -n 1 basename |$
    COMPREPLY=( $(compgen -W "$configs" -- "$cur") )
}
complete -F _vpn_autocomplete vpn

alias vpnfolder='cd /opt/local/etc/wireguard && ls'

alias checkvpn='curl -s https://ipapi.co/json | grep -E "ip|city|region|org"'
alias vpncheck='curl -s https://ipapi.co/json | grep -E "ip|city|region|org"'

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
