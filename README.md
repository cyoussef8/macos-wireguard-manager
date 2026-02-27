<h1> macOS WireGuard Interactive Manager</h1>
<p><i>Tested on macOS High Sierra</i></p>

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
    <li><b>WireGuard Tools:</b> Installed via Homebrew (<code>brew install wireguard-tools</code>) or MacPorts (<code>sudo port install wireguard-tools</code>).</li>
    <li><b>WireGuard Configurations:</b>
        <ul>
            <li>If using <b>Homebrew</b>, default path is <code>/etc/wireguard/</code>.</li>
            <li>If using <b>MacPorts</b>, default path is <code>/opt/local/etc/wireguard/</code>.</li>
        </ul>
    </li>
</ul>

<h2>Installation</h2>
<ol>
    <li>Clone or download this script.</li>
    <li><b>Configure Path:</b> Open the script in a text editor and update the <code>CONF_DIR</code> variable to match your installation:
        <ul>
            <li>For <b>MacPorts</b>, set: <code>CONF_DIR="/opt/local/etc/wireguard"</code></li>
            <li>For <b>Homebrew</b>, set: <code>CONF_DIR="/etc/wireguard"</code></li>
        </ul>
    </li>
    <li>Move the script to your local bin folder:
        <pre><code>sudo mv vpn /usr/local/bin/vpn</code></pre>
    </li>
    <li>Make it executable:
        <pre><code>sudo chmod +x /usr/local/bin/vpn</code></pre>
    </li>
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



<h3>2. Manual Commands</h3>
<ul>
    <li><b>Connect by name:</b> <code>vpn au-syd-101</code></li>
    <li><b>Disconnect:</b> <code>vpn off</code></li>
</ul>
