#!/usr/bin/perl

#find unique integration tag sequence.Then create the .fa sequence for blat

open IN, "<PEread_LTR_nonInternal_linker_long_q20.txt" or die;

while ($line = <IN>) {
	$totalcount++;
	chomp($line);
	@eles=split /\t/, $line;
	
	$this_tag = $eles[0];
	$LTR_seq = $eles[3];
	$LTR_seq_end = substr($LTR_seq, 0, 15);
	
	$Linker_seq = $eles[15];
	$Linker_seq_end = substr($Linker_seq, 0, 15);
	
	
	$seqIndex="$LTR_seq_end\t$Linker_seq_end";
	$$seqIndex++; 
}

print "Done indexing\n";


open INuniquePair, "<PEread_LTR_nonInternal_linker_long_UniquePair.txt" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePairWct.txt" or die;
open OUTL, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_F.fa" or die;
open OUTR, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_R.fa" or die;

while ($line = <INuniquePair>) {
	chomp($line);
	@eles=split /\t/, $line;
	
	$this_tag = $eles[0];
	$LTR_seq = $eles[3];
	$LTR_seq_end = substr($LTR_seq, 0, 15);
	if ($LTR_seq=~/(.*)GTCCCTTAAGCG/) { #read through into Linker ->GTCCCTTAAGCG
		$LTR_seq=$1;
	}
	
	$Linker_seq = $eles[15];
	$Linker_seq_end = substr($Linker_seq, 0, 15);
	$Linker_seq_genomestart = $Linker_seq;
	if($Linker_seq=~/(.*)TGCTAGAGATTT/) { #read through into HIV LTR ->TGACTAG
		$Linker_seq_genomestart=$1;
	}
	
	
	$seqIndex="$LTR_seq_end\t$Linker_seq_end";
	$this_tag_count=$$seqIndex;
	$eles[0]="$this_tag"."#"."$this_tag_count";
	$newline=join("\t", @eles);
	print OUT "$newline\n";
	$totalUnique++;
	
	print OUTL "\>$this_tag\#$this_tag_count\n";
	print OUTL "$LTR_seq\n";
	print OUTR "\>$this_tag\#$this_tag_count\n";
	print OUTR "$Linker_seq_genomestart\n";
}
close IN;
close OUT;
close OUTL;
close OUTR;
close INuniquePair;

open LOG, ">>log.txt" or die;
print LOG "Total nonInternal Read long: $totalcount\n";
print LOG "Total Unique NonInternal Read Long Pair with counts:  $totalUnique\n";
close LOG;