#!/usr/bin/perl

#find unique integration tag sequence.15 bp tag on both LTR side and Linker side to classify it as unique.

open IN, "<PEread_LTR_nonInternal_linker_long_q20.txt" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePair.txt" or die;



$totalcount=0;
$totalUnique=0;

%seen=();


while ($line = <IN>) {
	$totalcount++;
	chomp($line);
	@eles=split /\t/, $line;
	
	$this_tag = $eles[0];
	$LTR_seq = $eles[3];
	$LTR_seq_end = substr($LTR_seq, 0, 15);
	
	$Linker_seq = $eles[15];
	$Linker_seq_end = substr($Linker_seq, 0, 15);

	
	
	$seq="$LTR_seq_end\t$Linker_seq_end";
	
	unless ($seen{$seq}++) {
		$totalUnique++;
		print OUT "$line\n";
	} 
}

close IN;
close OUT;

open LOG, ">>log.txt" or die;
print LOG "Total nonInternal Read long: $totalcount\n";
print LOG "Total Unique NonInternal Read Long Pair:  $totalUnique\n";
close LOG;