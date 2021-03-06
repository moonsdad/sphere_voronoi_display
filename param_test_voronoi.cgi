#!/usr/bin/perl -w
use strict;
use CGI qw(:standard);

print header;

my $n = substr(param('dataset'),0,3);
my $eColor = substr(param('eColor'),0,1);
my $qDist = substr(param('qDist'),0,4);
my $kQt = substr(param('kQt'),0,2);

print "<p>The dataset to use is: $n<br/>",
      "The cell color to use is: $eColor<br/>",
      "The stem length to use is: $qDist<br/>",
      "The number of spanning lines to use is: $kQt<br/>",
      "</p>";

my $deployedMCRroot = "/usr/local/MATLAB/R2014b";
#my $deployedMCRroot = "/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83";

my $mdvDir = "/var/www/cgi-bin/sphere_voronoi_display/mdv";
my $imgDest = "/var/www/virtual-test-server-root/img";

my $cmd ="/var/www/cgi-bin/sphere_voronoi_display/run_voronoi4web.sh $deployedMCRroot $mdvDir $imgDest $n $eColor $qDist $kQt";
#"matlab -nosplash -r \"sphere_voronoi_display($n,$eColor,2.0,0.4,'-yo',1.0,$qDist,'b',1.0,$kQt,'b',0.5,'..\\..\\cmdline.bob')\;exit\"";
#print "the command will be: $cmd";

system($cmd);
print "<img id=\"bob\" alt=\"Resulting Image\" src=\"..\\..\\img\\cmdline.bob\" />";
