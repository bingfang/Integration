#!/usr/bin/perl

# use this program to process Illumina summary mapping file
# after find long insert, $insertlen>20, filter with q20>20

open IN, "<PEread_LTR_nonInternal_linker_long.txt" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_q20.txt" or die;

$qcutoff=20;
$totalin=0;
$totalout=0;


while ($newline = <IN>) {
	$sum=0;
	$sumR=0;
	
	$totalin++;
	chomp($newline);
	@elesnew = split(/\t/, $newline);
	$LTR=$elesnew[2];
	$insert=$elesnew[3];  #insert sequence
	$qscore=$elesnew[4];  #quality score of the read
	#get quality score of the first 20 bp of the insert sequence
	$LTRlen=length($LTR);
	$insertqscore20bp=substr $qscore, $LTRlen, 20;
	#convert the qscores to an array
	@qscores=split(//,$insertqscore20bp);
	#convert each ascii to numerical value and calculate average, A=65
	foreach(@qscores) {
		$q=ord($_);
		$sum=$sum+$q;
	}
	$averageqscore20bp = $sum/20-33;  #start from ASCII 33 in Illumina new version
	#/ source wikipedia Fastq_format, older version -64
	#print "$averageqscore20bp\n";
	
	#get quality score of Linker side sequence
	$insertR=$elesnew[15];
	$qscoreR=substr $elesnew[16], 25, 20;
	@qscoresR=split(//, $qscoreR);
	foreach(@qscoresR) {
		$qR=ord($_);
		$sumR=$sumR+$qR;
	}
	$averagescore20bpR = $sumR/20-33; #/source wikipedia Fastq_format, older version -64
	#print "$averagescore20bpR\n";
	
	if($averageqscore20bp>$qcutoff and $averagescore20bpR>$qcutoff) {
		$totalout++;
		print OUT "$newline\n";
	}
}

close IN;
close OUT;

open LOG, ">>log.txt" or die;
print LOG "Before filter q20: $totalin\n";
print LOG "After filter q20: $totalout\n";
close LOG;