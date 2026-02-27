<h1> macOS WireGuard Interactive Manager</h1>
<p><i>Tested on macOS High Sierra (MacPorts)</i></p>

<p>A powerful bash script for macOS that turns <code>wg-quick</code> into an interactive, paginated, and searchable menu.</p>

<h2>Features</h2>
<ul>
    <li><b>Interactive Menu:</b> Browse all your WireGuard configuration files (<code>.conf</code>).</li>
    <li><b>Pagination:</b> 15 items per page with easy navigation.</li>
    <li><b>Search:</b> Filter servers instantly by keyword.</li>
    <li><b>Active Status:</b> Clearly shows which VPN is currently connected.</li>
    <li><b>Automatic Verification:</b> Runs connection checks immediately after connecting to confirm your new IP and location.</li>
    <li><b>Auto-switches:</b> If a VPN is already active, it will automatically turn it off before activating the new one.</li>
</ul>



<h2>Prerequisites</h2>
<ul>
    <li><b>WireGuard Tools:</b> Installed via MacPorts:
        <pre><code>sudo port install wireguard-tools</code></pre>
    </li>
    <li><b>WireGuard Configurations:</b> Located in <code>/opt/local/etc/wireguard/</code>.</li>
</ul>

<h2>Installation</h2>
<ol>
    <li>Clone or download this script.</li>
    <li>Move the script to your local bin folder:
        <pre><code>sudo mv vpn /usr/local/bin/vpn</code></pre>
    </li>
    <li>Make it executable:
        <pre><code>sudo chmod +x /usr/local/bin/vpn</code></pre>
    </li>
    <li><b>Add Config Files:</b> Move your WireGuard <code>.conf</code> files into:
        <pre><code>/opt/local/etc/wireguard/</code></pre>
    </li>
    <li><b>Configure Profile:</b> Open <code>~/.bash_profile</code> in a text editor (e.g., <code>nano ~/.bash_profile</code>) and add the following for autocomplete and quick access:
        <pre><code>
# VPN Autocomplete for Bash
_vpn_autocomplete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local configs=$(ls /opt/local/etc/wireguard/*.conf 2>/dev/null | xargs -n 1 basename | sed 's/.conf//')
    COMPREPLY=( $(compgen -W "$configs" -- "$cur") )
}
complete -F _vpn_autocomplete vpn

# Quick access to config folder
alias vpnfolder='cd /opt/local/etc/wireguard && ls'

# Verify connection
alias checkvpn='curl -s https://ipapi.co/json | grep -E "city|region|org"'

# Ensure PATH is correct for MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
        </code></pre>
    </li>
    <li><b>Apply Changes:</b> Run <code>source ~/.bash_profile</code>.</li>
</ol>

<h2>Usage</h2>

<h3>1. Interactive Menu</h3>
<p>Just type:</p>
<pre><code>vpn</code></pre>

<table border="1">
    <tr>
        <th>Input</th>
        <th>Action</th>
    </tr>
    <tr>
        <td><b>Numbers</b></td>
        <td>Type a number and hit Enter to connect.</td>
    </tr>
    <tr>
        <td><b>Enter</b></td>
        <td>Go to the next page (loops back to top).</td>
    </tr>
    <tr>
        <td><b>p + Enter</b></td>
        <td>Go to the previous page.</td>
    </tr>
    <tr>
        <td><b>s + Enter</b></td>
        <td>Search/filter by keyword.</td>
    </tr>
    <tr>
        <td><b>c + Enter</b></td>
        <td>Clear search and show all servers.</td>
    </tr>
    <tr>
        <td><b>q + Enter</b></td>
        <td>Quit the menu.</td>
    </tr>
</table>



<h3>2. Manual Commands & Autocomplete</h3>
<ul>
    <li><b>Connect by name:</b> <code>vpn au-syd-101</code> (Press <b>Tab</b> to autocomplete file names)</li>
    <li><b>Disconnect:</b> <code>vpn off</code></li>
    <li><b>Go to config folder:</b> <code>vpnfolder</code></li>
</ul>
</ul><img width="602" height="478" alt="Screen Shot 2026-02-27 at 2 58 51 pm" src="https://github.com/user-attachments/assets/8eddcd22-8b40-4e39-8b68-36920b9cb447" />
