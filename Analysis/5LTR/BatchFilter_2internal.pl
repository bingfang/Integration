#!/usr/bin/perl

# use this program to process Illumina summary mapping file

open IN, "<PEread_LTR_Linker.txt" or die;

open OUT_nonInternal, ">PEread_LTR_NonInternal_linker.txt" or die;


while ($newline = <IN>) {
	chomp($newline);
	@elesnew = split(/\t/, $newline);
	if ($elesnew[3]=~/^GTCCCC/) {
		#print OUT_internal "$newline\n";
		$internal++;
	}
	else {
		print OUT_nonInternal "$newline\n";
		$others++;
	}
}

close IN;

open LOG, ">>log.txt" or die;
print LOG "PEread internal: $internal\n";
print LOG "PEread nonInternal: $others\n";
close LOG;