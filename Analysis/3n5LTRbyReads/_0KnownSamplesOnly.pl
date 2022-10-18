#!/usr/bin/perl

#process gz seq files

use File::Temp ();
use Archive::Extract ();

#gz files are sometimes split into many smaller files 001, 002, 003, etceteras

# input variables and convert to array
my $LTRcombine = $ENV{LTRcombine};
print $LTRcombine;
my @LTRcombine = split('\n', $LTRcombine);

############### read barcode_sample pairs
foreach $line (@LTRcombine){
	chomp($line);
	($barcode, $samplename, $LTR)=split(/\t/, $line);
	$barcode2samplename{$barcode}="$samplename"."_$LTR"."_$barcode".".txt";
	
	if ($LTR eq "3LTR") {
		$file2copy="../3LTR/$barcode/$barcode"."_blat_defuzz_countsbyreads.txt";
		$file2destination="$samplename"."_$LTR"."_$barcode".".txt";
		system "cp $file2copy $file2destination";
	}
	elsif ($LTR eq "5LTR") { 
		$file2copy="../5LTR/$barcode/$barcode"."_blat_defuzz_countsbyreads.txt";
		$file2destination="$samplename"."_$LTR"."_$barcode".".txt";
		system "cp $file2copy $file2destination";
	}
	
}
