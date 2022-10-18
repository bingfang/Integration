#!/usr/bin/perl

open IN1, "<PEread_LTR_nonInternal_linker_long_q20_F10bp_sortedExpanded_cluster_w_seq.txt" or die;
open IN2, "<Clusters2blat_blat.summary2grand.txt" or die;
open R2, "<../PEread_LTR_nonInternal_linker_long_q20_R.fa" or die;
open OUT1, ">clusters_unknown_and_multi_loci_mapped_F.fa" or die;
open OUT2, ">clusters_unknown_and_multi_loci_mapped_R.fa" or die;

while ($line=<IN1>) {
	chomp($line);
	@eles=split(/\t/, $line);
	($id, $rest) = split(/\_/, $eles[8]);
	$seq = $eles[10];
	$id2R1{$id} = $seq;	
}

while ($line=<R2>) {
	chomp($line);
	if ($line =~ /^>/) {
	    ($id, $rest) = split(/\&/, $line);
	    ($rest, $id) = split(/\>/, $id);
	}
	else {
	    $R2 = $line;
	    $id2R2{$id} = $R2;
	}
}

@ids = @newids = ();
while ($line=<IN2>) {
	chomp($line);
	@eles=split(/\t/, $line);
	if ($eles[0] =~ /unknown/ or $eles[0] =~ /More/) {
	    @ids = split(/\ /, $eles[2]);
	    foreach $id (@ids) {
	        if ($id =~ /^M/) {
	            ($newid, $rest) = split(/\_/, $id);
	            push (@newids, $newid);
	            $newline1 = ">" . $newid . "\n" . $id2R1{$newid} . "\n";
	            $newline2 = ">" . $newid . "\n" . $id2R2{$newid} . "\n";
	            print OUT1 "$newline1";
	            print OUT2 "$newline2";
	        }
	    }
	}
}

close IN1, IN2, R2, OUT1, OUT2;
