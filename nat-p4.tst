description nat: test my nat config

addrouter CE1
int eth1 eth 0000.0000.1111 $1a$ $1b$
int eth2 eth 0000.0000.1111 $2b$ $2a$
!
vrf def p4lang
 exit
vrf def common
 exit
bridge 10
 description LAN
 mac-learn
 mac-move
 exit
bridge 100
 description L3-Verb-OPENWRT
 mac-learn
 mac-move
 exit
bridge 20
 description WLAN
 mac-learn
 mac-move
 exit
bridge 6
 mac-learn
 exit
bridge 8
 description MGMT
 mac-learn
 mac-move
 exit
bridge 9
 description Server
 mac-learn
 mac-move
 exit
hairpin 10
 exit
hairpin 100
 exit
hairpin 20
 exit
hairpin 6
 exit
hairpin 8
 exit
hairpin 9
 exit
prefix-list p4
 sequence 10 permit 0.0.0.0/0 ge 0 le 0
 exit
object-group network IPv4-GB-HOME
 description Home Network
 sequence 20 10.8.1.0 255.255.255.0
 sequence 30 10.8.2.0 255.255.255.0
 sequence 40 10.8.254.0 255.255.255.0
 sequence 50 192.168.254.1 255.255.255.255
 sequence 60 192.168.128.254 255.255.255.255
 sequence 70 10.8.0.0 255.255.255.0
 exit
object-group network IPv4-LL
 description RFC3927 - Dynamic Configuration of IPv4 Link-Local Addresses
 sequence 10 169.254.0.0 255.255.0.0
 exit
object-group network IPv4-MCAST
 description Multicast
 sequence 10 224.0.0.0 240.0.0.0
 exit
object-group network IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 description Hosts that cant do well with the source port randomize
 sequence 10 172.16.0.94 255.255.255.255
 sequence 20 10.8.0.100 255.255.255.255
 exit
object-group network IPv4-PRIVATE-RAGES
 description RFC1918
 sequence 10 10.0.0.0 255.0.0.0
 sequence 20 172.16.0.0 255.240.0.0
 sequence 30 192.168.0.0 255.255.0.0
 exit
object-group network IPv6-LL
 description RFC 4291 RFC 7404
 sequence 10 fe80:: ffff::
 exit
object-group network IPv6-MCAST
 description Multicast
 sequence 10 ff00:: ff00::
 exit
access-list IPv4-DENY
 sequence 10 deny all any 698 any 698
 sequence 20 deny 17 any all 255.255.255.255 255.255.255.255 68
 sequence 30 deny all obj IPv4-LL all any all
 sequence 40 deny all any all obj IPv4-MCAST all
 exit
access-list IPv4-NAT
 sequence 10 evaluate deny IPv4-DENY
 sequence 20 evaluate deny IPv4-NAT-LAN-DENY
 sequence 30 evaluate permit IPv4-NAT-LAN-PERMIT
 exit
access-list IPv4-NAT-LAN-DENY
 sequence 10 deny all obj IPv4-GB-HOME all obj IPv4-GB-HOME all
 sequence 20 deny all obj IPv4-GB-HOME all obj IPv4-PRIVATE-RAGES all
 exit
access-list IPv4-NAT-LAN-PERMIT
 sequence 10 permit all obj IPv4-GB-HOME all any all
 exit
access-list IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 sequence 10 evaluate deny IPv4-DENY
 sequence 20 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all
 sequence 30 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-PRIVATE-RAGES all log
 sequence 40 permit all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all any all
 exit
access-list IPv6-NAT
 sequence 10 deny all obj IPv6-LL all any all
 sequence 20 deny all any all obj IPv6-MCAST all
 sequence 30 deny all obj IPv6-LL all any all
 sequence 40 deny all any all obj IPv6-MCAST all
 exit
interface hairpin1001
 description L3-L3-LINK-NETWORK
 vrf forwarding common
 ipv4 address 172.16.0.93 255.255.255.252
 ipv4 pim enable
 no shutdown
 no log-link-change
 exit
interface hairpin1002
 description L2-L3-LINK-NETWORK
 bridge-group 100
 no shutdown
 no log-link-change
 exit
interface hairpin101
 description L3-LAN
 vrf forwarding common
 ipv4 address 10.8.0.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin102
 description L2-LAN
 bridge-group 10
 no shutdown
 no log-link-change
 exit
interface hairpin201
 description L3-WLAN
 vrf forwarding common
 ipv4 address 10.8.2.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin202
 description L2-WLAN
 bridge-group 20
 no shutdown
 no log-link-change
 exit
interface hairpin61
 description L3-IOT
 vrf forwarding common
 ipv4 address 10.8.1.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin62
 description L2-IOT
 bridge-group 6
 no shutdown
 no log-link-change
 exit
interface hairpin81
 description L3-MGMT
 vrf forwarding common
 ipv4 address 10.8.255.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin82
 description L2-MGMT
 bridge-group 8
 no shutdown
 no log-link-change
 exit
interface hairpin91
 description L3-Server
 vrf forwarding common
 ipv4 address 10.8.254.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin92
 description L2-Server
 bridge-group 9
 no shutdown
 no log-link-change
 exit
int lo100
 vrf for common
 ipv4 addr 172.16.0.94 255.255.255.0
 bridge-group 100
 exit
int eth1
 exit
int eth2
 description P4 Interconnect
 exit
int sdn1
 macaddr ea97.942d.6ac3
 cdp enable
 no autostate
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
int sdn2
 macaddr ea97.942b.7ac3
 cdp enable
 no autostate
 bridge-group 20
 exit
ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface sdn1
ipv4 nat common sequence 2000 srclist IPv4-NAT interface sdn1
ipv4 nat common sequence 2000 randomize 49152 65535
ipv4 nat common sequence 3100 trgport 17 interface sdn1 5132 172.16.0.94 5132
ipv4 nat common sequence 3110 trgport 6 interface sdn1 2132 172.16.0.94 2132
ipv4 nat common sequence 3111 trgport 17 interface sdn1 2132 172.16.0.94 2132
ipv4 nat common sequence 3112 trgport 6 interface sdn1 2133 172.16.0.94 2133
ipv4 nat common sequence 3113 trgport 17 interface sdn1 2133 172.16.0.94 2133
ipv4 nat common sequence 3200 trgport 6 interface sdn1 5001 10.8.0.5 5001
ipv6 nat common sequence 2000 srclist IPv6-NAT interface sdn1
ipv6 nat common sequence 2000 randomize 49152 65535
server dhcp4 WLAN
 pool 10.8.2.10 10.8.2.254
 gateway 10.8.2.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name NAT
 static 0000.6666.2222 10.8.2.10
 interface hairpin201
 vrf common
 exit
server p4lang p4
 interconnect eth2
 export-vrf common
 export-bridge 20
 export-port sdn1 1 10
 export-port sdn2 2 10
 vrf p4lang
 exit
!
addother CE1p4 controller CE1 p4lang 9080 - feature nat
int eth1 eth 0000.0000.2222 $1b$ $1a$
int eth2 eth 0000.0000.2222 $2a$ $2b$
int eth3 eth 0000.0000.2222 $3a$ $3b$
int eth4 eth 0000.0000.2222 $4a$ $4b$
!
!
addrouter PE1
int eth1 eth 0000.0000.3333 $3b$ $3a$
!
vrf def common
 rd 1:1
 label-mode per-prefix
 exit
router ospf4 1
 vrf common
 router 192.168.254.1
 area 0 ena
 red conn
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 addr 100.64.0.1 255.255.255.0
 exit
int lo0
 vrf for common
 ipv4 addr 192.168.254.1 255.255.255.255
 exit
server dhcp4 eth1
 pool 100.64.0.10 100.64.0.254
 gateway 100.64.0.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name uplink-pe1
 static ea97.942d.6ac3 100.64.0.105
 interface eth1
 vrf common
 exit
!
addrouter SimulatedHost1
int eth1 eth 0000.6666.2222 $4b$ $4a$
!
vrf def common
 exit
prefix-list p4
 permit 0.0.0.0/0 ge 0 le 0
 exit
object-group
int eth1
 cdp enable
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
!

CE1 tping 100 10 100.64.0.1 vrf common sou sdn1
SimulatedHost1 tping 100 10 100.64.0.1 vrf common sou eth1