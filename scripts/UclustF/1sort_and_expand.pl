#!/usr/bin/perl

########get rid of empty seq
system("cp ../PEread_LTR_nonInternal_linker_long_UniquePairWct_F.fa ./PEread_LTR_nonInternal_linker_long_UniquePairWct_F.fa");
open IN, "<PEread_LTR_nonInternal_linker_long_UniquePairWct_F.fa" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp.fa" or die;

while ($line=<IN>) {
	chomp($line);
	if ($line=~/^>/) {
		$seq=<IN>;
		chomp($seq);
		
		if (length($seq)>10) {
			print OUT "$line\n$seq\n";
		}
	}
}
close IN;
close OUT;

######sort	
system ("uclust --sort PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp.fa --output PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp_sorted.fa");


#######expand
open IN, "<PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp_sorted.fa" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp_sortedExpanded.fa" or die;

while ($line=<IN>) {
	chomp($line);
	if ($line=~/(>M.*)\#(\d+)/) {
		
		$seqid=$1;
		$identicalcounts=$2;
		print "$seqid\n";
		
		$seq=<IN>;
		for ($i=1;$i<=$identicalcounts;$i++) {
			print OUT "$seqid\_$i\n$seq";
		}
		
	}
}

close IN;
close OUT;



system ("uclust --input PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp_sortedExpanded.fa --uc PEread_LTR_nonInternal_linker_long_UniquePairWct_F10bp_sortedExpanded_cluster.txt");


