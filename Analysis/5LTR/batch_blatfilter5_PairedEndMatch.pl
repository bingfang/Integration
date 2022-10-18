#!/usr/bin/perl

#filter pair end mapping results based on
#chrL matches chrR
#strandL matches strandR
#offset( abs(R-L)<1kb)

open IN, "<PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt_grandcount.txt" or die;
open OUT, ">PairedEndRIS_filter1.txt" or die;

while ($line=<IN>) {
	chomp($line);
	@eles = split /\t/, $line;
	if(
		($eles[2] eq $eles[5]) and 
		($eles[3] ne $eles[6]) and
		(abs($eles[4]-$eles[7]) <10000)
	) {print OUT "$line\n";}
}

close IN;
close OUT;

		
