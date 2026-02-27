<h1> macOS WireGuard Interactive Manager</h1>
<p><i>Tested on macOS High Sierra (Homebrew & MacPorts)</i></p>

<p>A powerful bash script for macOS that turns <code>wg-quick</code> into an interactive, paginated, and searchable menu.</p>

<h2>Features</h2>
<ul>
    <li><b>Interactive Menu:</b> Browse all your WireGuard configuration files (<code>.conf</code>).</li>
    <li><b>Pagination:</b> 15 items per page with easy navigation.</li>
    <li><b>Search:</b> Filter servers instantly by keyword.</li>
    <li><b>Active Status:</b> Clearly shows which VPN is currently connected.</li>
    <li><b>Automatic Verification:</b> Runs connection checks immediately after connecting.</li>
    <li><b>Auto-switches:</b> Automatically turns off active VPN before activating a new one.</li>
</ul>



<h2>Prerequisites & Installation</h2>

<h3>1. Choose your Installation Method</h3>
<ul>
    <li><b>Via Homebrew:</b>
        <pre><code>brew install wireguard-tools</code></pre>
        <i>Config Path: <code>/etc/wireguard/</code></i>
    </li>
    <li><b>Via MacPorts:</b>
        <pre><code>sudo port install wireguard-tools</code></pre>
        <i>Config Path: <code>/opt/local/etc/wireguard/</code></i>
    </li>
</ul>

<h3>2. Install the Script</h3>
<ol>
    <li>Download this script and move it to your local bin folder:
        <pre><code>sudo mv vpn /usr/local/bin/vpn</code></pre>
    </li>
    <li>Make it executable:
        <pre><code>sudo chmod +x /usr/local/bin/vpn</code></pre>
    </li>
    <li><b>Add Config Files:</b> Move your WireGuard <code>.conf</code> files into your chosen config path (see Step 1).</li>
</ol>

<h3>3. Configure Bash Autocomplete (Crucial)</h3>
<p>Open <code>~/.bash_profile</code> in a text editor (e.g., <code>sudo nano ~/.bash_profile</code>) and add the section matching your installation:</p>

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
alias checkvpn='curl -s https://ipapi.co/json | grep -E "city|region|org"'
</code></pre>

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
alias checkvpn='curl -s https://ipapi.co/json | grep -E "city|region|org"'
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
</code></pre>

<p>Run <code>source ~/.bash_profile</code> to apply changes.</p>

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
        <td><b>p + Enter</b></td>
        <td>Go to the previous page.</td>
    </tr>
    <tr>
        <td><b>s + Enter</b></td>
        <td>Search/filter by keyword.</td>
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
<img width="602" height="478" alt="Screen Shot 2026-02-27 at 2 58 51 pm" src="https://github.com/user-attachments/assets/8eddcd22-8b40-4e39-8b68-36920b9cb447" />
