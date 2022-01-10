#!/usr/bin/perl
use strict;
use warnings;

die"usage:perl $0 <MuscleAlnDIR> <OUT>\n"unless(@ARGV ==2);
my%hash;
my($sn,$len) = (0,0);
opendir DR,$ARGV[0] or die $!;
while(my$aln=readdir(DR)){
	next if($aln !~ /label\S+\.aln/);
	open IN,"$ARGV[0]/$aln" or die $!;
	<IN>;
	<IN>;
	$/="\n\n";
	while(<IN>){
		chomp;
		my$sln = 0;
		my%info;
		my@ar = $_ =~ m/(^\S+.*$)/mg;
		for(my$i=0;$i<=$#ar;$i+=1){
			my@ss = split(/\s+/,$ar[$i]);
			my@ba = split(//,$ss[1]);
			$sln = $#ba;
			for(my$j=0;$j<=$#ba;$j+=1){
				$info{$ss[0]}{$j} = $ba[$j];
			}
		}
		for(my$k=0;$k<=$sln;$k+=1){
			my$n = 0;
			my%bas;
			foreach my$key(keys %info){
				if($info{$key}{$k} ne '-'){
					$bas{$info{$key}{$k}} =1;
					$n += 1;
				}
			}
			$sn = $#ar + 1;
			my@tmp = keys %bas;
			if($n == $sn && $#tmp >= 1){
				my$mm = 0;
				foreach my$key(keys %info){
					$mm += 1;
					$hash{$key} .= $info{$key}{$k};
					$len += 1 if($mm == 1);
				}
			}
		}
	}
	close IN;
}
closedir DR;

open OU,">","$ARGV[1]" or die $!;
print OU "$sn   $len\n";
foreach my$key(keys %hash){
	print OU "$key\t$hash{$key}\n";
}
close OU;
