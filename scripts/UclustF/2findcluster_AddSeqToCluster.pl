#!/usr/bin/perl

#get seq for each id
open IN, "<PEread_LTR_nonInternal_linker_long_q20_F.fa" or die;

while ($line=<IN>) {
	if ($line=~/>(M.*)\#/) {
		$id=$1;
		print "$id\n";
		$seq=<IN>;
		chomp ($seq);
		$id2seq{$id}=$seq;
	}
}

close IN;


#sort

open IN, "<PEread_LTR_nonInternal_linker_long_q20_F10bp_sortedExpanded_cluster.txt" or die;

while ($line=<IN>) {
	chomp($line);
	if ($line=~/^C.*((M04948|M02560).*)_\d/) {
		push(@lines, $line);
	}
}
close IN;

@sorted_lines = sort {
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$b_fields[2] <=> $a_fields[2]  #sort by cluster_read_count
	
} @lines;

open OUT, ">PEread_LTR_nonInternal_linker_long_q20_F10bp_sortedExpanded_cluster_w_seq.txt" or die;
open OUTFA, ">MajorClusters.fa" or die;

foreach $line (@sorted_lines) {
	@eles=split(/\t/, $line);
	$id=$eles[8];
	($newid, $idontcare)=split(/\_/, $id);
	
	print OUT "$line\t$id2seq{$newid}\n";
	
	$faID="$newid"."_C_"."$eles[2]";
	print OUTFA ">$faID\n$id2seq{$newid}\n";
	
}

close OUT;
close OUTFA;
	

