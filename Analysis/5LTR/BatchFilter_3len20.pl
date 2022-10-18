#!/usr/bin/perl

# use this program to process Illumina summary mapping file

open IN, "<PEread_LTR_nonInternal_Linker.txt" or die;

open OUT_nonInternal_long, ">PEread_LTR_nonInternal_linker_long.txt" or die;


while ($newline = <IN>) {
	chomp($newline);
	@elesnew = split(/\t/, $newline);
	$insert=$elesnew[3];
	$insertlen=100;
	if ($insert=~/GTCCCTTAAGCGGAGCCC/) { #linker sequence ->GTCCCTTAAGCGGAGCCC
		($L, $R)=split(/GTCCCTTAAGCGGAGCCC/, $insert);
		$insertlen=length($L);
		if($insertlen<20) {
			$ing2short++;
		}
		else {
			print OUT_nonInternal_long "$newline\n";
			$ing2long++;
			}
	}
	
	else {
		print OUT_nonInternal_long "$newline\n";
		$ing2long++;
	}
}

close IN;

open LOG, ">>log.txt" or die;
print LOG "PEread short insert <20bp: $ing2short\n";
print LOG "PEread long insert >=20bp: $ing2long\n";
close LOG;