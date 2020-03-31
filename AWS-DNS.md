
# Requirement
How to programmatically pull the IP address of the Amazon provided DNS resolver in your VPC.

  
# Solution

The IP address for the Amazon provided DNS resolver in your VPC is always plus 2 at the base of the  **_primary_** CIDR block of the VPC.

For example:
 - DNS Server on a 10.0.0.0/16 network is located at 10.0.0.2. 
 - DNS Server on a 172.31.0.0/16 network is located at 172.31.0.2.

You can also use the following IP address which the '.2' IP address points to. This will work regardless of your VPC CIDR block:
 - 169.254.169.253
 
Not to be confused with the meta-data server at '169.254.169.254' or the NTP server at '169.254.169.123'.
 - 169.254.169.254 - MetaData
 - 169.254.169.253 - DNS
 - 169.254.169.123 - NTP

So, if you have 'enableDnsSupport' set as  **True**; queries to the Amazon provided DNS server at the 169.254.169.253 IP address, or the reserved IP address at the base of the VPC IPv4 network range plus two will succeed.

As an example, the following commands will give the same result:

    dig @169.254.169.253 amazon.com +short +trace
    dig @10.0.0.2 amazon.com +short +trace

In summary, you can use '169.254.169.253' as the IP address of the DNS resolver so no need to programmatically pull the IP address.

However, the following Bash one-liner which will generate the .2 IP address for the DNS resolver:

    curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)/vpc-ipv4-cidr-blocks | sed 's/.\{4\}$/2/'

  
## References
Amazon DNS Server:  
--  [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS)

Using DNS with Your VPC:  
--  [https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html)
