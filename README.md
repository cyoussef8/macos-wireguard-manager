[# macos-wireguard-manager
For Wireguard on High Sierra using .conf files

macOS WireGuard Interactive Manager
A powerful bash script for macOS that turns wg-quick into an interactive, paginated, and searchable menu.

Features
Interactive Menu: Browse all your WireGuard configuration files (.conf).

Pagination: 15 items per page with easy navigation.

Search: Filter servers instantly by keyword.

Active Status: Clearly shows which VPN is currently connected.

Automatic Verification: Runs connection checks immediately after connecting to confirm your new IP and location.

Auto-switches: If a VPN is already active, it will automatically turn it off before activating the new one.

Prerequisites
WireGuard Tools: Installed via Homebrew (brew install wireguard-tools) or MacPorts.

WireGuard Configurations: Located in /etc/wireguard/.

Installation
Clone or download this script.

Move the script to your local bin folder:

Bash

sudo mv vpn /usr/local/bin/vpn
Make it executable:

Bash

sudo chmod +x /usr/local/bin/vpn
Usage
1. Interactive Menu
Just type:

Bash

vpn
Numbers: Type a number and hit Enter to connect.

Enter: Go to the next page (loops back to top).

p + Enter: Go to the previous page.

s + Enter: Search/filter by keyword.

c + Enter: Clear search and show all servers.

q + Enter: Quit the menu.

2. Manual Commands
Connect by name: vpn au-syd-101

Disconnect: vpn off
](https://github.com/cyoussef8/macos-wireguard-manager/edit/main/README.md)
