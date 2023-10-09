description nat: test my nat config

addrouter CE1
int eth1 eth 0000.0000.1111 $1a$ $1b$
int eth2 eth 0000.0000.1111 $2b$ $2a$
!
vrf def p4lang
 exit
vrf def common
 exit
router olsr4 1337
 vrf common
 justadvert loopback0
 justadvert hairpin101
 justadvert hairpin201
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
 deny 17 any 67 any 68
 deny 17 any 68 any 67
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
 deny all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all obj IPv4-PRIVATE-RAGES all
 permit all obj IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION all any all
 exit
access-list IPv6-NAT
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
 deny all obj IPv6-LL all any all
 deny all any all obj IPv6-MCAST all
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
 macaddr 0041.636b.3568
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
interface loopback0
 vrf forwarding common
 ipv4 address 192.168.254.1 255.255.255.255
 no shutdown
 no log-link-change
 exit
int eth1
 exit
int eth2
 description P4 Interconnect
 log-link-change
 exit
int sdn1
 log-link-change
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
int sdn3
 macaddr ea97.942b.8ac4
 cdp enable
 no autostate
 exit
int sdn3.20
 bridge-group 20
 exit
int sdn4
 macaddr ea97.942b.9ac5
 cdp enable
 bridge-group 10
 no autostate
 exit
int sdn5
 macaddr ea98.942b.9ac5
 cdp enable
 bridge-group 100
 no autostate
 exit
ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface sdn1
ipv4 nat common sequence 2000 srclist IPv4-NAT interface sdn1
ipv4 nat common sequence 2000 randomize 16384 32767
ipv4 nat common sequence 2000 log-translations
ipv4 nat common sequence 3100 trgport 17 interface sdn1 5132 172.16.0.94 5132
ipv4 nat common sequence 3110 trgport 6 interface sdn1 2132 172.16.0.94 2132
ipv4 nat common sequence 3111 trgport 17 interface sdn1 2132 172.16.0.94 2132
ipv4 nat common sequence 3112 trgport 6 interface sdn1 2133 172.16.0.94 2133
ipv4 nat common sequence 3113 trgport 17 interface sdn1 2133 172.16.0.94 2133
ipv4 nat common sequence 3200 trgport 6 interface sdn1 5001 10.8.0.5 5001
ipv6 nat common sequence 2000 srclist IPv6-NAT interface sdn1
ipv6 nat common sequence 2000 randomize 16384 32767
server p4lang p4
 interconnect eth2
 export-vrf common
 export-bridge 20
 export-bridge 100
 export-bridge 10
 export-port sdn1 1 10
 export-port sdn2 2 10
 export-port sdn3 3 10
 export-port sdn4 4 10
 export-port sdn5 5 10
 export-port hairpin1002 dynamic 0 0 0 0
 export-port hairpin202 dynamic 0 0 0 0
 export-port hairpin201 dynamic 0 0 0 0
 export-port hairpin1001 dynamic 0 0 0 0
 export-port hairpin91 dynamic 0 0 0 0
 export-port hairpin92 dynamic 0 0 0 0
 export-port hairpin62 dynamic 0 0 0 0
 export-port hairpin101 dynamic 0 0 0 0
 export-port hairpin82 dynamic 0 0 0 0
 export-port hairpin61 dynamic 0 0 0 0
 export-port hairpin102 dynamic 0 0 0 0
 export-port hairpin81 dynamic 0 0 0 0
 vrf p4lang
 exit
server tftp CISCO
 path /rtr/cisco/
 vrf common
 exit
server ntp NTP
 reference 217.196.145.42
 vrf common
 exit
server dhcp4 IOT
 pool 10.8.1.10 10.8.1.254
 gateway 10.8.1.1
 netmask 255.255.255.0
 dns-server 10.8.254.7
 domain-name iot.local
 static 000a.1222.5391 10.8.1.50
 static 1cbf.ce90.7d85 10.8.1.40
 static 2418.c614.58f6 10.8.1.50
 static 4cef.c071.d8cd 10.8.1.12
 static 5444.a38f.4c55 10.8.1.60
 static 6cc7.ec1c.33e1 10.8.1.60
 static 704f.57a3.b1df 10.8.1.11
 static 704f.57a3.bb33 10.8.1.39
 static 704f.57a3.bb5b 10.8.1.10
 static 9ca5.25cf.4a22 10.8.1.42
 static a848.fadc.fa5e 10.8.1.82
 static ac0b.fbcf.e8b7 10.8.1.81
 static ac0b.fbcf.f06f 10.8.1.80
 static b04e.262b.d4e6 10.8.1.123
 static b0a7.b9c5.2002 10.8.1.100
 static b0a7.b9c5.245d 10.8.1.83
 static b827.ebb4.7c59 10.8.1.41
 static c8ff.7710.3935 10.8.1.30
 static d4ad.fc2d.7d13 10.8.1.61
 static e45f.01a0.986d 10.8.1.15
 interface hairpin61
 vrf common
 exit
server dhcp4 LAN
 pool 10.8.0.10 10.8.0.254
 gateway 10.8.0.1
 netmask 255.255.255.0
 dns-server 10.8.254.7
 domain-name local
 static 0011.327e.173f 10.8.0.5
 static 0015.5d00.5f03 10.8.0.21
 static 0015.5d00.d502 10.8.0.20
 static 00b7.71d3.9501 10.8.0.100
 static 18c0.4d88.4ec9 10.8.0.11
 static 704f.57a3.bb5b 10.8.0.250
 static 0000.6666.3333 10.8.0.10
 static b827.eb0c.bd99 10.8.0.6
 static b8be.f4bb.eaef 10.8.0.3
 static b8be.f4c7.8873 10.8.0.4
 static b8be.f4c7.8b73 10.8.0.4
 static c484.6694.b3bb 10.8.0.254
 static e45f.01a0.986d 10.8.0.15
 interface hairpin101
 vrf common
 exit
server dhcp4 MGMT
 pool 10.8.255.100 10.8.255.200
 gateway 10.8.255.1
 netmask 255.255.255.0
 dns-server 10.8.254.7
 domain-name mgmt.local
 static 5c83.8f9e.5834 10.8.255.30
 static e4d3.f1c9.247c 10.8.255.31
 interface hairpin81
 vrf common
 exit
server dhcp4 WLAN
 pool 10.8.2.10 10.8.2.254
 gateway 10.8.2.1
 netmask 255.255.255.0
 dns-server 10.8.254.7
 domain-name wlan.local
 static c8ff.7710.3935 10.8.2.2
 static 0000.6666.2222 10.8.2.10
 static 704f.57a3.bb5b 10.8.2.250
 interface hairpin201
 vrf common
 exit
sensor br10mac
 path bridge/br10mac
 prefix br10mac
 prepend br_mac_
 command sho bridge 10 | beg addr
 name 0 mac=
 key br10mac br10mac/br10mac
 addname 1 * ifc=
 replace \. _
 column 5 name pack_tx
 column 5 split + typ="sw" typ="hw"
 column 6 name pack_rx
 column 6 split + typ="sw" typ="hw"
 column 7 name pack_dr
 column 7 split + typ="sw" typ="hw"
 column 8 name byte_tx
 column 8 split + typ="sw" typ="hw"
 column 9 name byte_rx
 column 9 split + typ="sw" typ="hw"
 column 10 name byte_dr
 column 10 split + typ="sw" typ="hw"
 exit
sensor br20mac
 path bridge/br20mac
 prefix br20mac
 prepend br_mac_
 command sho bridge 20 | beg addr
 name 0 mac=
 key br20mac br20mac/br20mac
 addname 1 * ifc=
 replace \. _
 column 5 name pack_tx
 column 5 split + typ="sw" typ="hw"
 column 6 name pack_rx
 column 6 split + typ="sw" typ="hw"
 column 7 name pack_dr
 column 7 split + typ="sw" typ="hw"
 column 8 name byte_tx
 column 8 split + typ="sw" typ="hw"
 column 9 name byte_rx
 column 9 split + typ="sw" typ="hw"
 column 10 name byte_dr
 column 10 split + typ="sw" typ="hw"
 exit
sensor br6mac
 path bridge/br10mac
 prefix br10mac
 prepend br_mac_
 command sho bridge 10 | beg addr
 name 0 mac=
 key br10mac br10mac/br10mac
 addname 1 * ifc=
 replace \. _
 column 5 name pack_tx
 column 5 split + typ="sw" typ="hw"
 column 6 name pack_rx
 column 6 split + typ="sw" typ="hw"
 column 7 name pack_dr
 column 7 split + typ="sw" typ="hw"
 column 8 name byte_tx
 column 8 split + typ="sw" typ="hw"
 column 9 name byte_rx
 column 9 split + typ="sw" typ="hw"
 column 10 name byte_dr
 column 10 split + typ="sw" typ="hw"
 exit
sensor br8mac
 path bridge/br8mac
 prefix br8mac
 prepend br_mac_
 command sho bridge 8 | beg addr
 name 0 mac=
 key br8mac br8mac/br8mac
 addname 1 * ifc=
 replace \. _
 column 5 name pack_tx
 column 5 split + typ="sw" typ="hw"
 column 6 name pack_rx
 column 6 split + typ="sw" typ="hw"
 column 7 name pack_dr
 column 7 split + typ="sw" typ="hw"
 column 8 name byte_tx
 column 8 split + typ="sw" typ="hw"
 column 9 name byte_rx
 column 9 split + typ="sw" typ="hw"
 column 10 name byte_dr
 column 10 split + typ="sw" typ="hw"
 exit
sensor br9mac
 path bridge/br9mac
 prefix br9mac
 prepend br_mac_
 command sho bridge 9 | beg addr
 name 0 mac=
 key br9mac br9mac/br9mac
 addname 1 * ifc=
 replace \. _
 column 5 name pack_tx
 column 5 split + typ="sw" typ="hw"
 column 6 name pack_rx
 column 6 split + typ="sw" typ="hw"
 column 7 name pack_dr
 column 7 split + typ="sw" typ="hw"
 column 8 name byte_tx
 column 8 split + typ="sw" typ="hw"
 column 9 name byte_rx
 column 9 split + typ="sw" typ="hw"
 column 10 name byte_dr
 column 10 split + typ="sw" typ="hw"
 exit
sensor check
 path check/peer/peer
 prefix freertr-check
 prepend check_
 command sho check
 name 0 name=
 key name check/peer
 skip 2
 column 1 name state
 column 1 replace false 0
 column 1 replace true 1
 column 2 name asked
 column 3 name time
 column 4 name passed
 column 6 name failed
 exit
sensor disk
 path disk/peer/peer
 prefix freertr-disk
 prepend system_disk_
 command flas disk /rtr/ | exc path
 key name disk/peer
 column 1 name _bytes
 exit
sensor flash
 path flash/peer/peer
 prefix freertr-flash
 prepend system_flash_
 command flas list /rtr/ | inc rtr
 name 2 name=
 key name flash/peer
 replace \- _
 replace \. _
 column 1 name size
 column 1 replace dir -1
 exit
sensor gc
 path gc/peer/peer
 prefix freertr-gc
 prepend system_gc_
 command sho watchdog gc | exc name
 key name gc/peer
 replace \s _
 column 1 name _val
 exit
sensor ifaces-hw
 path interfaces-hw/interface/counter
 prefix freertr-ifaces
 prepend iface_hw_byte_
 command sho inter hwsumm
 name 0 ifc=
 key name interfaces-hw/interface
 replace \. _
 column 1 name st
 column 1 replace admin -1
 column 1 replace down 0
 column 1 replace up 1
 column 2 name tx
 column 3 name rx
 column 4 name dr
 exit
sensor ifaces-hwp
 path interfaces-hwp/interface/counter
 prefix freertr-ifaces
 prepend iface_hw_pack_
 command sho inter hwpsumm
 name 0 ifc=
 key name interfaces-hwp/interface
 replace \. _
 column 1 name st
 column 1 replace admin -1
 column 1 replace down 0
 column 1 replace up 1
 column 2 name tx
 column 3 name rx
 column 4 name dr
 exit
sensor ifaces-sw
 path interfaces-sw/interface/counter
 prefix freertr-ifaces
 prepend iface_sw_byte_
 command sho inter swsumm
 name 0 ifc=
 key name interfaces-sw/interface
 replace \. _
 column 1 name st
 column 1 replace admin -1
 column 1 replace down 0
 column 1 replace up 1
 column 2 name tx
 column 3 name rx
 column 4 name dr
 exit
sensor ifaces-swp
 path interfaces-swp/interface/counter
 prefix freertr-ifaces
 prepend iface_sw_pack_
 command sho inter swpsumm
 name 0 ifc=
 key name interfaces-swp/interface
 replace \. _
 column 1 name st
 column 1 replace admin -1
 column 1 replace down 0
 column 1 replace up 1
 column 2 name tx
 column 3 name rx
 column 4 name dr
 exit
sensor nat
 path nat/peer/peer
 prefix freertr-nat
 prepend nat_translations_
 command show ipv4 nat common translations
 name 0 nat=
 key name nat/peer/peer
 replace \. _
 column 1 name proto
 column 2 name original_source
 column 3 name target
 column 4 name translated_source
 column 5 name nat_target
 column 6 name age
 column 7 name last
 column 8 name timeout
 column 9 name byte
 exit
sensor sensor
 path sensor/peer/peer
 prefix freertr-sensor
 prepend sensor_
 command sho sensor
 name 0 met=
 key name sensor/peer
 column 1 name asked
 column 2 name time
 exit
sensor sys
 path sys/peer/peer
 prefix freertr-sys
 prepend system_
 command sho watchdog sys | exc name
 key name sys/peer
 replace \s _
 column 1 name _val
 exit
sensor vrf
 path vrf/peer/peer
 prefix freertr-vrf
 prepend vrf_
 command sho vrf routing
 name 0 name=
 key name vrf/peer
 skip 2
 column 2 name v4 type="ifc"
 column 3 name v6 type="ifc"
 column 4 name v4 type="uni"
 column 5 name v6 type="uni"
 column 6 name v4 type="multi"
 column 7 name v6 type="multi"
 column 8 name v4 type="flow"
 column 9 name v6 type="flow"
 column 10 name v4 type="label"
 column 11 name v6 type="label"
 column 12 name v4 type="conn"
 column 13 name v6 type="conn"
 exit
alias exec sid command show inter des
alias exec sis command show inter des
alias exec sis4 command show ipv4 inter
alias exec sis6 command show ipv6 inter
alias test bash command attach shell1 socat - exec:bash,ctty,pty,stderr
alias test bash description get linux shell
server prometheus prom
 port 9100
 sensor br10mac
 sensor br20mac
 sensor br6mac
 sensor br8mac
 sensor br9mac
 sensor disk
 sensor flash
 sensor gc
 sensor ifaces-hw
 sensor ifaces-hwp
 sensor ifaces-sw
 sensor ifaces-swp
 sensor sensor
 sensor sys
 sensor vrf
 vrf common
 exit
client name-server 10.8.254.7
event-manager FIXING-NAT
 event .* 0041.636b.3568 learned from hairpin102
 tcl exec "test logging debug MODIFY ACL IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION"
 tcl config "access-list IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION" "permit all any all any all"
 tcl exec "test logging debug REMOVE NAT SEQ 1000"
 tcl config "no ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface sdn1"
 tcl exec "test logging debug STARTING SLEEP FOR 2 SEC"
 tcl after "2000"
 tcl exec "test logging debug FINISHING SLEEP FOR 2 SEC"
 tcl exec "test logging debug READDING NAT SEQ1000"
 tcl config "ipv4 nat common sequence 1000 srclist IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION interface sdn1"
 tcl exec "test logging debug STARTING SLEEP FOR 1 SEC"
 tcl after "1000"
 tcl exec "test logging debug FINISHING SLEEP FOR 1 SEC"
 tcl exec "test logging debug MODIFY ACL IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION AGAIN"
 tcl exec "test logging debug STARTING SLEEP FOR 1 SEC"
 tcl after "1000"
 tcl exec "test logging debug FINISHING SLEEP FOR 1 SEC"
 tcl config "access-list IPv4-NAT-WITHOUT-SOURCE-PORT-RANDOMISATION" "no sequence 50 permit all any all any all"
 tcl exec "clear ipv4 nat common"
 tcl exec "test logging debug WORKAROUND DONE"
 exit
!
addother CE1p4 controller CE1 p4lang 9080 - feature nat
int eth1 eth 0000.0000.2222 $1b$ $1a$
int eth2 eth 0000.0000.2222 $2a$ $2b$
int eth3 eth 0000.0000.2222 $3a$ $3b$
int eth4 eth 0000.0000.2222 $4a$ $4b$
int eth5 eth 0000.0000.2222 $5a$ $5b$
int eth6 eth 0000.0000.2222 $6a$ $6b$
int eth7 eth 0000.0000.2222 $7a$ $7b$
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
int eth1
 cdp enable
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
!
addrouter SimulatedHost2
int eth1 eth 0000.6666.3333 $5b$ $5a$
!
vrf def common
 exit
prefix-list p4
 permit 0.0.0.0/0 ge 0 le 0
 exit
int eth1
  cdp enable
 exit
int eth1.20
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
!
addrouter SimulatedHost3
int eth1 eth 0000.6666.3333 $6b$ $6a$
!
vrf def common
 exit
prefix-list p4
 permit 0.0.0.0/0 ge 0 le 0
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 address dynamic dynamic
 ipv4 gateway-prefix p4
 ipv4 dhcp-client enable
 ipv4 dhcp-client early
 exit
!
addrouter SimulatedHost4
int eth1 eth 0000.6666.4444 $7b$ $7a$
!
vrf def common
 exit
int eth1
 cdp enable
 vrf for common
 ipv4 address 172.16.0.94 255.255.255.252
 exit
ipv4 route common 0.0.0.0 0.0.0.0 172.16.0.93
!
CE1 tping 100 10 100.64.0.1 vrf common sou sdn1
SimulatedHost4 tping 100 10 172.16.0.93 vrf common sou eth1
SimulatedHost4 tping 100 10 100.64.0.1 vrf common sou eth1
SimulatedHost3 tping 100 10 100.64.0.1 vrf common sou eth1
SimulatedHost2 tping 100 10 100.64.0.1 vrf common sou eth1.20
SimulatedHost1 tping 100 10 100.64.0.1 vrf common sou eth1