Decred-seeder
==============

Decred-seeder is a crawler for the Decred network, which exposes a list
of reliable nodes via a built-in DNS server.

Features:
* Regularly revisits known nodes to check their availability.
* Bans nodes after enough failures, or bad behaviour.
* Keeps statistics over (exponential) windows of 2 hours, 8 hours,
  1 day and 1 week, to base decisions on.
* Very low memory (a few tens of megabytes) and CPU requirements.
* Crawlers run in parallel (by default 24 threads simultaneously).

### Requirements

Decred-seeder requires Boost and SSL.  On Debian-based systems these
are typically installed by,

    sudo apt-get install build-essential libboost-all-dev libssl-dev

### Usage

Assuming you want to run a DNS seed on dnsseed.example.com, you will
need an authorative NS record in example.com's domain record, pointing
to for example vps.example.com:

    $ dig -t NS dnsseed.example.com

    ;; ANSWER SECTION
    dnsseed.example.com.   86400    IN      NS     vps.example.com.

On the system vps.example.com, you can now run `dnsseed`:

    ./dnsseed -h dnsseed.example.com -n vps.example.com -m root.example.com

To report SOA records, provide an e-mail address (with the "@" part replaced by ".")
using -m.

### Building

    make

This will produce the `dnsseed` binary executable.

To build statically (useful for running on minimal debian servers that may not have all of the required libs installed):

    STATIC="-static" make

### Running as non-root

A DNS server typically listens on UDP port 53.  However, to bind to a priviledged port
(i.e. a port less than 1024), it is necessary to do one of the following:

 1. Run as root (not recommended).
 2. Redirect port 53 to a non-priviledged port, such as with iptables.
 3. Use POSIX capabilities (in Linux with support) to allow binding.

To use an iptables rule (Linux only) to redirect it to a non-privileged port:

    sysctl net.ipv4.conf.all.route_localnet=1
    iptables iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.1:5353

If properly configured, this will allow you to run dnsseed in userspace, using
the `-p 5353` option.

Alternatively, non-root binding to privileged ports is possible on Linux supporting
"POSIX capabilities".  If the `setcap` and `getcap` commands are available,

    sudo setcap cap_net_bind_service=+ep /path/to/dnsseed

