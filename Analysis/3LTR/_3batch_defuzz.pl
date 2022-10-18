#!/usr/bin/perl

#batch blat filter

# input variables and convert to array
my $barcodes = $ENV{barcodes};
my @barcodes = split('\n', $barcodes);
# @barcodes=qw(
# 1ACTGT2AGCTA.txt);



foreach $file (@barcodes) {
	$folder=substr($file,0,14);  ##################folder name length################
	$blatresults_filtered="$folder"."_blat.txt";
	$blatresults_filtered_counts="$folder"."_counts.txt";
	$blatresults_defuzz="$folder"."_blat_defuzz.txt";
	$sublibtotalcount=0;
	undef @filter3;
	undef @filter3RIS;
	
	#filter pair end mapping results based on cor_L
	#if cor_L is same, then the shearEnd(breakpoint) must be >5bp away to be considered independent events

	open IN, "<./$folder/$blatresults_filtered" or die;
	open OUT, ">./$folder/$blatresults_defuzz" or die;

	$breakpointdifferencecutoff=5; #>= $value, then consider real different breakpoint; 5 for HIVDRP sample, 2 for GT sample
	$difference_of_count_cutoff=5; # highcount/lowcount, if more than 10 fold, ignore, don't count as real breakpoint.

	#read in all mapping results
	while ($line=<IN>) {
		chomp($line);
		push (@filter3RIS, $line)
	}


	#initialize variables
	$RISpre = shift(@filter3RIS);
	@eles = split(/\t/, $RISpre);
	$site ="$eles[2]\t$eles[3]\t$eles[4]";
	$breakpoint = $eles[8];  #$breakpoint means distance from integration site
	$sitecount=$eles[0];
	#print "$breakpoint\n";

	
	foreach $RIS (@filter3RIS) {
		#print OUT "$RIS\n";
			@elesnew = split(/\t/, $RIS);
			$newsite ="$elesnew[2]\t$elesnew[3]\t$elesnew[4]";
			$newbreakpoint=$elesnew[8];
			$newsitecount=$elesnew[0];
		
			if($newsite ne $site) { #when sees a new ID, output old;
				push (@filter3, $RISpre);
				#reset all variables
				$RISpre = $RIS;
				$site=$newsite;
				$breakpoint=$newbreakpoint;
				$sitecount=$newsitecount;
			}
			else{#if same site, meaning same integration site,  check for breakpoint, the difference has to be > cutoff to print out
				$difference_of_shearend = abs($breakpoint-$newbreakpoint);
				$difference_of_count= $sitecount/$newsitecount;
			
			
				#print "$difference_of_count\n";
				if( $difference_of_shearend >= $breakpointdifferencecutoff) {
					push(@filter3, $RIS);
					#reset all variables
					$breakpoint=$newbreakpoint;
					$difference_of_shearend=0;
					$sitecount=$newsitecount;
				}
				elsif( $difference_of_shearend < $breakpointdifferencecutoff and $difference_of_count<$difference_of_count_cutoff) {
					push(@filter3, $RIS);
					print "$difference_of_count\n";
					#reset all variables
					$breakpoint=$newbreakpoint;
					$difference_of_shearend=0;
					$sitecount=$newsitecount;
				}
			}
	}


	#sort by chr_L, cor_L, count, print
	@sorted_filter3 = sort {
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;
	
		$a_fields[2] cmp $b_fields[2]  # sort by chr
		||
		$a_fields[4] <=> $b_fields[4]  # then sort by corL
		||
		$b_fields[8] <=> $a_fields[8]  # then sort by highest count
	} @filter3;

	foreach $RIS (@sorted_filter3) {
		print OUT "$RIS\n";
	}

	close IN;
	close OUT;
}

		
