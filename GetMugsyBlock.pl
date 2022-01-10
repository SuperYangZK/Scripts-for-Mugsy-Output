#!/usr/bin/perl
use strict;
use warnings;

die"usage:perl $0 <mugsyOUT> <StNum> <OUTdir>\n"unless(@ARGV ==3);
open IN,$ARGV[0] or die $!;
<IN>;
$/="\n\n";
while(<IN>){
	chomp;
	my$lb;
	my@ss = $_ =~ m/(^s.*$)/mg;
	if($#ss + 1 != $ARGV[1]){
		next;
	}
	my@ar=split(/\n/,$_);
	if($ar[0] =~ m/label=(\S+)\s+/){
		$lb = $1;
	}else{
		print "Format err!!\n";
		next;
	}
	my$out = "$ARGV[2]/label$lb.fas";
	open OU,">",$out or die $!;
	for(my$i=1;$i<=$#ar;$i+=1){
		my@tt=split(/\s+/,$ar[$i]);
		my$hd = $tt[1];
		$hd =~ s/\./ /;
		print OU ">$hd\n"; 
		print OU "$tt[6]\n";
	}
	close OU;
}
close IN;
