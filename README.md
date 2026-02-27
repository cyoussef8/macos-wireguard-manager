<h1> macOS High Sierra - WireGuard VPN Interactive Manager</h1>
<p><i>Tested on macOS High Sierra using MacPorts</i></p>
<p></p><i>May support Homebrew (Untested)</i></p>

<p>A powerful terminal command line bash script for macOS that turns <code>wg-quick</code> into an interactive, paginated, and searchable menu. Especially helpful on older Mac's running outdated and unsupported OS versions; that cannot run the GUI for VPN's.</p>

<h2>Features</h2>
<ul>
    <li><b>Interactive Menu:</b> Browse all your WireGuard configuration files (<code>.conf</code>).</li>
    <li><b>Pagination:</b> 15 items per page with easy navigation.</li>
    <li><b>Search:</b> Filter servers instantly by keyword.</li>
    <li><b>Active Status:</b> Clearly shows which VPN is currently connected.</li>
    <li><b>Automatic Verification:</b> Runs connection checks immediately after connecting.</li>
    <li><b>Auto-switches:</b> Automatically turns off active VPN before activating a new one.</li>
</ul>

<img width="602" height="478" alt="Screen Shot 2026-02-27 at 2 58 51 pm" src="https://github.com/user-attachments/assets/8eddcd22-8b40-4e39-8b68-36920b9cb447" />

<h2>Installation</h2>

<h3>1. Copy the Script </h3><code>(Currently using <b>MacPorts</b> - If using <b>Homebrew</b>, change the <b>CONF_DIR=</b> path to "/etc/wireguard")</code>
<p>After ensuring the correct path is specified, copy the following block of code <em>(you need to specify the path properly)</em> and paste it directly into your Terminal, then press <b>Enter</b>:</p>

<pre><code>
cat << 'EOF' | sudo tee /usr/local/bin/vpn > /dev/null
#!/bin/bash
# VPN Manager for WireGuard (Tested on macOS High Sierra)
# Features: Interactive Menu, Pagination, Search, Connection Verification

WG_QUICK="$(command -v wg-quick)"

# --- USER CONFIGURATION ---
# Change this path based on your installation method:
# Homebrew: /etc/wireguard
# MacPorts: /opt/local/etc/wireguard
CONF_DIR="/opt/local/etc/wireguard"
# --------------------------

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to run verification checks
run_check() {
    echo -e "\n${CYAN}Verifying connection...${NC}"
    # General check for IP and location
    curl -s https://ipapi.co/json | grep -E "city|region|org"
}

# --- Help Text ---
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: vpn [command]"
    echo "Commands:"
    echo "  (none)    Open interactive menu"
    echo "  off       Stop active VPN"
    echo "  <name>    Connect to <name>.conf"
    exit 0
fi

# --- Find Active VPN ---
ACTIVE_VPN=$(ls /var/run/wireguard/*.name 2>/dev/null | xargs -n 1 basename | sed 's/.name//' | head -n 1)

# --- Interactive Menu ---
if [ -z "$1" ]; then
    mapfile -t ALL_CONFIGS < <(ls "$CONF_DIR"/*.conf 2>/dev/null | xargs -n 1 basename | sed 's/.conf//')
    CONFIGS=("${ALL_CONFIGS[@]}")
    
    INDEX=0
    PAGE_SIZE=15
    SEARCH_TERM=""

    while true; do
        clear
        echo -e "${GREEN}--- ACTIVE ---${NC}"
        [ -z "$ACTIVE_VPN" ] && echo "None" || echo "$ACTIVE_VPN"
        echo ""
        
        if [ ! -z "$SEARCH_TERM" ]; then
            echo -e "${YELLOW}--- SEARCHING: $SEARCH_TERM (Type 'c' to clear) ---${NC}"
        else
            echo -e "${BLUE}--- SELECT A SERVER ---${NC}"
        fi

        # Show page
        for ((i=INDEX; i<INDEX+PAGE_SIZE && i<${#CONFIGS[@]}; i++)); do
            printf "%3d) %s\n" $((i+1)) "${CONFIGS[$i]}"
        done

        echo -e "\n${NC}(Enter) Next | (p) Prev | (s) Search | (q) Quit${NC}"
        read -p "Type Number or Command: " INPUT

        # If Enter is pressed, handle navigation
        if [ -z "$INPUT" ]; then
            if ((INDEX+PAGE_SIZE < ${#CONFIGS[@]})); then
                INDEX=$((INDEX+PAGE_SIZE))
            else
                INDEX=0 # Loop back
            fi
            continue
        fi

        if [[ "$INPUT" =~ ^[0-9]+$ ]] && [ "$INPUT" -le "${#CONFIGS[@]}" ] && [ "$INPUT" -gt 0 ]; then
            NAME="${CONFIGS[$((INPUT-1))]}"
            break
        elif [[ "$INPUT" == "s" ]]; then
            read -p "Search for: " SEARCH_TERM
            mapfile -t CONFIGS < <(printf "%s\n" "${ALL_CONFIGS[@]}" | grep -i "$SEARCH_TERM")
            INDEX=0
        elif [[ "$INPUT" == "c" ]]; then
            SEARCH_TERM=""; CONFIGS=("${ALL_CONFIGS[@]}"); INDEX=0
        elif [[ "$INPUT" == "n" ]]; then
            if ((INDEX+PAGE_SIZE < ${#CONFIGS[@]})); then INDEX=$((INDEX+PAGE_SIZE)); else INDEX=0; fi
        elif [[ "$INPUT" == "p" ]]; then
            if ((INDEX-PAGE_SIZE >= 0)); then INDEX=$((INDEX-PAGE_SIZE)); fi
        elif [[ "$INPUT" == "q" ]]; then
            exit 0
        fi
    done
    
    # Connection Logic
    [ ! -z "$ACTIVE_VPN" ] && sudo "$WG_QUICK" down "$CONF_DIR/$ACTIVE_VPN.conf"
    echo -e "${GREEN}Starting $NAME...${NC}"
    sudo chmod 600 "$CONF_DIR/$NAME.conf"
    sudo "$WG_QUICK" up "$CONF_DIR/$NAME.conf"
    run_check
    exit 0
fi

# --- Direct Command Logic ---
if [[ "$1" == "off" || "$1" == "stop" ]]; then
    [ -z "$ACTIVE_VPN" ] && echo "Nothing running." || sudo "$WG_QUICK" down "$CONF_DIR/$ACTIVE_VPN.conf"
    exit 0
fi

NAME=$1
CONFIG="$CONF_DIR/$NAME.conf"
if [ ! -f "$CONFIG" ]; then echo "Error: '$NAME.conf' not found"; exit 1; fi
[ ! -z "$ACTIVE_VPN" ] && sudo "$WG_QUICK" down "$CONF_DIR/$ACTIVE_VPN.conf"
sudo chmod 600 "$CONFIG"
sudo "$WG_QUICK" up "$CONFIG"
run_check
EOF
</code></pre>

<h3>2. Enter Your Password</h3>
<p>The terminal will ask for your macOS login password. <b>Note: Nothing will appear on the screen while you type your password.</b> This is normal security behavior. Just type it and press <b>Enter</b>.</p>

<h3>3. Configure Paths & Autocomplete</h3>
<p>Open <code>~/.bash_profile</code> in a text editor (e.g., <code>sudo nano ~/.bash_profile</code>) and add the section matching your installation:</p>

<h4>For MacPorts Users:</h4>
<pre><code>
# VPN Autocomplete for MacPorts
_vpn_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local configs=$(ls /opt/local/etc/wireguard/*.conf 2>/dev/null | xargs -n 1 basename | sed 's/.conf//')
    COMPREPLY=( $(compgen -W "$configs" -- "$cur") )
}
complete -F _vpn_autocomplete vpn
alias vpnfolder='cd /opt/local/etc/wireguard && ls'
alias checkvpn='curl -s https://ipapi.co/json | grep -E "ip|city|region|org"'
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
</code></pre>

<p>Run <code>source ~/.bash_profile</code> to apply changes.</p>

<h4>For Homebrew Users:</h4>
<pre><code>
# VPN Autocomplete for Homebrew
_vpn_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local configs=$(ls /etc/wireguard/*.conf 2>/dev/null | xargs -n 1 basename | sed 's/.conf//')
    COMPREPLY=( $(compgen -W "$configs" -- "$cur") )
}
complete -F _vpn_autocomplete vpn
alias vpnfolder='cd /etc/wireguard && ls'
alias checkvpn='curl -s https://ipapi.co/json | grep -E "ip|city|region|org"'
</code></pre>

<p>Run <code>source ~/.bash_profile</code> to apply changes.</p>

<h3>4. Move <code>.conf</code> Files into the Appropriate Folder</h3>

<p>You must move your VPN <code>.conf</code> files into the specific VPN directory; otherwise, the client will not find any servers to connect to. These files are generally downloadable from your VPN provider's website.</p>

<blockquote style="background-color: #f6f8fa; padding: 10px; border-left: 5px solid #0366d6;">
    <strong>Important:</strong> Paste your <code>.conf</code> files into the designated <code>vpnfolder</code>.
</blockquote>

<p><strong>Target Directories:</strong></p>
<ul>
    <li><strong>MacPorts:</strong> <code>/opt/local/etc/wireguard</code></li>
    <li><strong>Homebrew:</strong> <code>/etc/wireguard</code></li>
</ul>

<h3>Example Commands</h3>
<p>Open your terminal and use the following commands based on your installation method. <strong>Make sure you are currently in the directory where you downloaded the <code>.conf</code> files.</strong></p>

<p><strong>For MacPorts:</strong></p>
<pre><code>cd ~/Downloads
sudo mv *.conf /opt/local/etc/wireguard/</code></pre>

<p><strong>For Homebrew:</strong></p>
<pre><code>cd ~/Downloads
sudo mv *.conf /etc/wireguard/</code></pre>

<blockquote style="background-color: #fff3cd; padding: 10px; border-left: 5px solid #ffc107;">
    <strong>Note:</strong> If you downloaded the configuration files as a <code>.zip</code> archive, ensure you are in the download directory and use the following commands to unzip and move them automatically:
    <br><br>
    <strong>For MacPorts:</strong>
    <pre><code>cd ~/Downloads
for f in *.zip; do unzip -j "$f" -d . && sudo mv *.conf /opt/local/etc/wireguard/; done</code></pre>
    <strong>For Homebrew:</strong>
    <pre><code>cd ~/Downloads
for f in *.zip; do unzip -j "$f" -d . && sudo mv *.conf /etc/wireguard/; done</code></pre>
</blockquote>

<h3>Secure Configuration Files (Permissions)</h3>
<p>For security reasons, WireGuard requires that configuration files are not readable by other users. Run the following command to set the correct permissions:</p>

<p><strong>For MacPorts:</strong></p>
<pre><code>sudo chmod 600 /opt/local/etc/wireguard/*.conf</code></pre>

<p><strong>For Homebrew:</strong></p>
<pre><code>sudo chmod 600 /etc/wireguard/*.conf</code></pre>

<blockquote style="background-color: #f8d7da; padding: 10px; border-left: 5px solid #dc3545;">
    <strong>Warning:</strong> Ensure your <code>.conf</code> filenames do not exceed <strong>15 characters</strong> (excluding the <code>.conf</code> extension). Filenames longer than 15 characters may cause the VPN connection to fail.
</blockquote>

<h2>Usage</h2>

<h3>1. Interactive Menu</h3>
<p>Just type:</p>
<pre><code>vpn</code></pre>

<h3>2. Manual Commands & Autocomplete</h3>
<ul>
    <li><b>Connect by name:</b> <code>vpn au-syd-101</code> (Press <b>Tab</b> to autocomplete file names)</li>
    <li><b>Disconnect:</b> <code>vpn off</code></li>
    <li><b>Go to config folder:</b> <code>vpnfolder</code></li>
    <li><b>Check IP Details:</b> <code>checkvpn</code></li>
</ul>

<img width="602" height="478" alt="Screen Shot 2026-02-27 at 2 58 51 pm" src="https://github.com/user-attachments/assets/8eddcd22-8b40-4e39-8b68-36920b9cb447" />
