#!/usr/bin/perl

#filter pair end mapping results based on
#if same corR, only choose the one with highest count and add the low counts to the high counts unless second highest is 10 bp away from the highest.

open IN, "<PairedEndRIS_filter1.txt" or die;
open OUT, ">PairedEndRIS_filter2.txt" or die;

#read in all mapping results
while ($line=<IN>) {
	chomp($line);
	push (@unsortedRIS, $line)
}

#sort by chr_R, cor_R, count
@sortedRIS_corR_then_count = sort {
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$a_fields[5] cmp $b_fields[5]  # sort by chr
	||
	$a_fields[7] <=> $b_fields[7]  # then sort by cor
	||
	$b_fields[0] <=> $a_fields[0]  # then sort by highest count
} @unsortedRIS;

#print out the best

#initialize variables
	$RISpre = shift(@sortedRIS_corR_then_count);
	@eles = split(/\t/, $RISpre);
	$LTR_breakpoint_distance = abs($eles[7]-$eles[4]); #add LTR_breakpoint_distance value
	$RISpre="$RISpre\t$LTR_breakpoint_distance";
	$Chr_strand_cor ="$eles[5]\t$eles[6]\t$eles[7]";
	$score = $eles[0];
	$corL=$eles[4];
	$corR=$eles[7];
	#print "$Chr_strand_cor\n";

	
foreach $RIS (@sortedRIS_corR_then_count) {
	#print OUT "$RIS\n";
		@elesnew = split(/\t/, $RIS);
		$LTR_breakpoint_distance = abs($elesnew[7]-$elesnew[4]); #add LTR_breakpoint_distance value
		$RIS="$RIS\t$LTR_breakpoint_distance";
		$newChr_strand_cor ="$elesnew[5]\t$elesnew[6]\t$elesnew[7]";
		$newscore=$elesnew[0];
		$newcorL=$elesnew[4];
		$newcorR=$elesnew[7];
		
		if($newChr_strand_cor ne $Chr_strand_cor) { #when sees a new chr_strand_cor, output old
			push (@filter2, $RISpre);
			#reset all variables
			$RISpre = $RIS;
			$Chr_strand_cor=$newChr_strand_cor;
			$score=$newscore;
			$corL=$newcorL;
		}
		#if same Chr_strand_cor, ie, chr_strand_cor on R, and corL is 10 bp away from previous one, the difference >10, then print out
		elsif($newChr_strand_cor eq $Chr_strand_cor and abs($corL-$newcorL)>10) {#if same chr_strand_cor on R
				push(@filter2, $RISpre);
				#reset all variables
				$RISpre = $RIS;
				$Chr_strand_cor=$newChr_strand_cor;
				$score=$newscore;
				$corL=$newcorL;
		}
		#if same Chr_strand_cor ie, chr_strand_cor on R, and corL is <10 bp away from previous one, merge them
 		elsif ($newChr_strand_cor eq $Chr_strand_cor and abs($corL-$newcorL)<=10) {
 				print "merge\t";
  				$score=$score+$newscore;
  				@eles2switch = split(/\t/, $RISpre);
 				$eles2switch[0]=$score;
				$RISpre=join("\t", @eles2switch);
				print "$RISpre\n";
		}
}

#don't forget the last line
push(@filter2, $RISpre);

#sort by chr_L, cor_L, count, print
@sorted_filter2 = sort {
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$a_fields[2] cmp $b_fields[2]  # sort by chr
	||
	$a_fields[4] <=> $b_fields[4]  # then sort by cor
	||
	$b_fields[8] <=> $a_fields[8]  # then sort by LTR_breakpoint_distance
	||
	$b_fields[0] <=> $a_fields[0]  # then sort by highest count
} @filter2;

foreach $RIS (@sorted_filter2) {
	print OUT "$RIS\n";
}

close IN;
close OUT;

		
