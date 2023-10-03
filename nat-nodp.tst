description nat: test my nat config

addrouter P1
int eth1 eth 1111.0000.1111 $1a$ $2a$
int eth2 eth 1111.0000.2222 $1b$ $6b$
!
vrf def common
 rd 1:1
 label-mode per-prefix
 exit
router ospf4 1
 vrf common
 router 192.168.255.1
 area 0 ena
 red conn
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 addr 172.17.0.1 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int eth2
 cdp enable
 vrf for common
 ipv4 addr 172.18.0.1 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int lo0
 ipv4 addr 192.168.255.1 255.255.255.255
 exit
!
addrouter P2
int eth1 eth 2222.0000.1111 $6a$ $7a$
int eth2 eth 2222.0000.2222 $6b$ $1b$
!
vrf def common
 rd 1:1
 label-mode per-prefix
 exit
router ospf4 1
 vrf common
 router 192.168.255.2
 area 0 ena
 red conn
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 addr 172.19.0.1 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int eth2
 cdp enable
 vrf for common
 ipv4 addr 172.18.0.2 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int lo0
 ipv4 addr 192.168.255.2 255.255.255.255
 exit
!
addrouter P3
int eth1 eth 3333.0000.1111 $7a$ $6a$
int eth2 eth 3333.0000.2222 $7b$ $4b$
!
vrf def common
 rd 1:1
 label-mode per-prefix
 exit
router ospf4 1
 vrf common
 router 192.168.255.3
 area 0 ena
 red conn
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 addr 172.19.0.2 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int eth2
 cdp enable
 vrf for common
 ipv4 addr 172.20.0.1 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int lo0
 ipv4 addr 192.168.255.3 255.255.255.255
 exit
!
addrouter PE1
int eth1 eth 0000.1111.1111 $2b$ $3a$
int eth2 eth 0000.1112.1111 $2a$ $1a$
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
int eth2
 cdp enable
 vrf for common
 ipv4 addr 172.17.0.2 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int lo0
 ipv4 addr 192.168.254.1 255.255.255.255
 exit
server dhcp4 eth1
 pool 100.64.0.10 100.64.0.254
 gateway 100.64.0.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name uplink-pe1
 static 0000.1111.2222 100.64.0.105
 interface eth1
 vrf common
 exit
!

addrouter CE1
int eth1 eth 0000.1111.2222 $3a$ $2b$
int eth2 eth 0000.1122.2222 $3b$ $8a$
!
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
router olsr4 1337
 vrf common
 justadvert loopback0
 justadvert hairpin101
 justadvert hairpin201
 exit
prefix-list p4
 permit 0.0.0.0/0 ge 0 le 0
 exit
object-group network IPv4-GB-HOME
 description Home Network
 10.8.1.0 255.255.255.0
 10.8.2.0 255.255.255.0
 10.8.254.0 255.255.255.0
 192.168.254.1 255.255.255.255
 192.168.128.254 255.255.255.255
 10.8.0.0 255.255.255.0
 exit
object-group network IPv4-LL
 description RFC3927 - Dynamic Configuration of IPv4 Link-Local Addresses
 169.254.0.0 255.255.0.0
 exit
object-group network IPv4-MCAST
 description Multicast
 224.0.0.0 240.0.0.0
 exit
object-group network IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 description Hosts that cant do well with the source port randomize
 172.16.0.94 255.255.255.255
 10.8.0.100 255.255.255.255
 exit
object-group network IPv4-PRIVATE-RAGES
 description RFC1918
 10.0.0.0 255.0.0.0
 172.16.0.0 255.240.0.0
 192.168.0.0 255.255.0.0
 exit
object-group network IPv6-LL
 description RFC 4291 RFC 7404
 fe80:: ffff::
 exit
object-group network IPv6-MCAST
 description Multicast
 ff00:: ff00::
 exit
access-list IPv4-DENY
 deny all any 698 any 698
 deny 17 any all 255.255.255.255 255.255.255.255 68
 deny 17 any all 255.255.255.255 255.255.255.255 67
 deny all obj IPv4-LL all any all
 deny all any all obj IPv4-MCAST all
 exit
access-list IPv4-NAT
 evaluate deny IPv4-DENY
 evaluate deny IPv4-NAT-LAN-DENY
 evaluate permit IPv4-NAT-LAN-PERMIT
 exit
access-list IPv4-NAT-LAN-DENY
 deny all obj IPv4-GB-HOME all obj IPv4-GB-HOME all
 deny all obj IPv4-GB-HOME all obj IPv4-PRIVATE-RAGES all
 exit
access-list IPv4-NAT-LAN-PERMIT
 permit all obj IPv4-GB-HOME all any all
 exit
access-list IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 evaluate deny IPv4-DENY
 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all
 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-PRIVATE-RAGES all log
 permit all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all any all
 exit
access-list IPv6-NAT
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
 exit
vrf def common
 exit
interface hairpin1001
 description L3-L3-LINK-NETWORK
 vrf forwarding common
 ipv4 address 172.16.0.93 255.255.255.252
 ipv4 pim enable
 router olsr4 1337 enable
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
 lldp enable
 cdp enable
 vrf forwarding common
 ipv4 address 10.8.0.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin102
 description L2-LAN
 lldp enable
 cdp enable
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
 router olsr4 1337 enable
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
int eth1
 cdp enable
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
int eth2
 cdp enable
 bridge-group 10
 exit
server dhcp4 LAN
 pool 10.8.0.10 10.8.0.254
 gateway 10.8.0.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name NAT
 static 0000.6666.2222 10.8.0.10
 interface hairpin101
 vrf common
 exit
ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface eth1
ipv4 nat common sequence 2000 srclist IPv4-NAT interface eth1
ipv4 nat common sequence 2000 randomize 49152 65535
ipv4 nat common sequence 3100 trgport 17 interface eth1 5132 172.16.0.94 5132
ipv4 nat common sequence 3110 trgport 6 interface eth1 2132 172.16.0.94 2132
ipv4 nat common sequence 3111 trgport 17 interface eth1 2132 172.16.0.94 2132
ipv4 nat common sequence 3112 trgport 6 interface eth1 2133 172.16.0.94 2133
ipv4 nat common sequence 3113 trgport 17 interface eth1 2133 172.16.0.94 2133
ipv4 nat common sequence 3200 trgport 6 interface eth1 5001 10.8.0.5 5001
ipv6 nat common sequence 2000 srclist IPv6-NAT interface eth1
ipv6 nat common sequence 2000 randomize 49152 65535
!

addrouter SimulatedHost1
int eth1 eth 0000.6666.2222 $8a$ $3b$
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

addrouter PE2
int eth1 eth 0000.2222.1111 $4a$ $5a$
int eth2 eth 0000.2221.1111 $4b$ $7b$
!
vrf def common
 rd 1:1
 label-mode per-prefix
 exit
router ospf4 1
 vrf common
 router 192.168.254.2
 area 0 ena
 red conn
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 addr 100.65.0.1 255.255.255.0
 exit
int eth2
 cdp enable
 vrf for common
 ipv4 addr 172.20.0.2 255.255.255.0
 router ospf4 1 ena
 mpls enable
 mpls ldp4
 exit
int lo0
 ipv4 addr 192.168.254.2 255.255.255.255
 exit
server dhcp4 eth1
 pool 100.65.0.10 100.65.0.254
 gateway 100.65.0.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name uplink-pe2
 static 0000.2222.2222 100.65.0.105
 interface eth1
 vrf common
 exit
!

addrouter CE2
int eth1 eth 0000.2222.2222 $5a$ $4a$
int eth2 eth 0000.2222.2222 $5b$ $9a$
!
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
router olsr4 1337
 vrf common
 justadvert loopback0
 justadvert hairpin101
 justadvert hairpin201
 exit
prefix-list p4
 permit 0.0.0.0/0 ge 0 le 0
 exit
object-group network IPv4-GB-HOME
 description Home Network
 10.1.1.0 255.255.255.0
 10.1.2.0 255.255.255.0
 10.1.254.0 255.255.255.0
 192.168.254.1 255.255.255.255
 192.168.128.254 255.255.255.255
 10.1.0.0 255.255.255.0
 exit
object-group network IPv4-LL
 description RFC3927 - Dynamic Configuration of IPv4 Link-Local Addresses
 169.254.0.0 255.255.0.0
 exit
object-group network IPv4-MCAST
 description Multicast
 224.0.0.0 240.0.0.0
 exit
object-group network IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 description Hosts that cant do well with the source port randomize
 172.20.0.94 255.255.255.255
 10.1.0.100 255.255.255.255
 exit
object-group network IPv4-PRIVATE-RAGES
 description RFC1918
 10.0.0.0 255.0.0.0
 172.20.0.0 255.240.0.0
 192.168.0.0 255.255.0.0
 exit
object-group network IPv6-LL
 description RFC 4291 RFC 7404
 fe80:: ffff::
 exit
object-group network IPv6-MCAST
 description Multicast
 ff00:: ff00::
 exit
access-list IPv4-DENY
 deny all any 698 any 698
 deny 17 any all 255.255.255.255 255.255.255.255 68
 deny all obj IPv4-LL all any all
 deny all any all obj IPv4-MCAST all
 exit
access-list IPv4-NAT
 evaluate deny IPv4-DENY
 evaluate deny IPv4-NAT-LAN-DENY
 evaluate permit IPv4-NAT-LAN-PERMIT
 exit
access-list IPv4-NAT-LAN-DENY
 deny all obj IPv4-GB-HOME all obj IPv4-GB-HOME all
 deny all obj IPv4-GB-HOME all obj IPv4-PRIVATE-RAGES all
 exit
access-list IPv4-NAT-LAN-PERMIT
 permit all obj IPv4-GB-HOME all any all
 exit
access-list IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION
 evaluate deny IPv4-DENY
 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all
 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-PRIVATE-RAGES all log
 permit all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all any all
 exit
access-list IPv6-NAT
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
 exit
vrf def common
 exit
interface hairpin1001
 description L3-L3-LINK-NETWORK
 vrf forwarding common
 ipv4 address 172.20.0.93 255.255.255.252
 ipv4 pim enable
 router olsr4 1337 enable
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
 lldp enable
 cdp enable
 vrf forwarding common
 ipv4 address 10.1.0.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin102
 description L2-LAN
 lldp enable
 cdp enable
 bridge-group 10
 no shutdown
 no log-link-change
 exit
interface hairpin201
 description L3-WLAN
 vrf forwarding common
 ipv4 address 10.1.2.1 255.255.255.0
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
 ipv4 address 10.1.1.1 255.255.255.0
 router olsr4 1337 enable
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
 ipv4 address 10.1.255.1 255.255.255.0
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
 ipv4 address 10.1.254.1 255.255.255.0
 no shutdown
 no log-link-change
 exit
interface hairpin92
 description L2-Server
 bridge-group 9
 no shutdown
 no log-link-change
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
int eth2
 cdp enable
 bridge-group 10
 exit
server dhcp4 LAN
 pool 10.1.0.10 10.1.0.254
 gateway 10.1.0.1
 netmask 255.255.255.0
 dns-server 8.8.8.8
 domain-name NAT
 static 0000.6666.2222 10.1.0.10
 interface hairpin101
 vrf common
 exit
ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface eth1
ipv4 nat common sequence 2000 srclist IPv4-NAT interface eth1
ipv4 nat common sequence 2000 randomize 49152 65535
ipv4 nat common sequence 3100 trgport 17 interface eth1 5132 172.20.0.94 5132
ipv4 nat common sequence 3110 trgport 6 interface eth1 2132 172.20.0.94 2132
ipv4 nat common sequence 3111 trgport 17 interface eth1 2132 172.20.0.94 2132
ipv4 nat common sequence 3112 trgport 6 interface eth1 2133 172.20.0.94 2133
ipv4 nat common sequence 3113 trgport 17 interface eth1 2133 172.20.0.94 2133
ipv4 nat common sequence 3200 trgport 6 interface eth1 5001 10.1.0.5 5001
ipv6 nat common sequence 2000 srclist IPv6-NAT interface eth1
ipv6 nat common sequence 2000 randomize 49152 65535
!
addrouter SimulatedHost2
int eth1 eth 0000.6666.2222 $9a$ $5b$
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

CE1 tping 100 10 100.65.0.1 vrf common sou eth1

CE2 tping 100 10 100.64.0.1 vrf common sou eth1

SimulatedHost1 tping 100 10 100.65.0.1 vrf common
SimulatedHost1 tping 100 10 100.64.0.1 vrf common

SimulatedHost2 tping 100 10 100.64.0.1 vrf common
SimulatedHost2 tping 100 10 100.65.0.1 vrf common

P1 output show mpls forw
PE1 output show mpls forw
PE2 output show mpls forw

CE1 output show ipv4 nat common translations
CE2 output show ipv4 nat common translations