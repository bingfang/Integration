#!/usr/bin/perl


#batch blat filter

# input variables and convert to array
my $barcodes = $ENV{barcodes};
my @barcodes = split('\n', $barcodes);

# @barcodes=qw(
# 1ACTGT2AGCTA.txt);



foreach $file (@barcodes) {
	$folder=substr($file,0,14);  ##################folder name length################
	$blatresults_filtered="$folder"."_blat_defuzz.txt";
	$blatresults_filtered_counts="$folder"."_blat_defuzz_countsbyreads.txt";
	$sublibtotalcount=0;
	undef @uniquesite;
	undef %seen;
	undef @site2print;
	
	open IN, "<./$folder/$blatresults_filtered" or die;
	while ($line=<IN>) {
		chomp($line);
		@eles=split(/\t/,$line);
		$site ="$folder\t$eles[2]\t$eles[3]\t$eles[4]";
		push(@uniquesite, $site) unless $seen{$site}++;
		$$site=$$site+$eles[0];
		$$folder=$$folder+$eles[0];
	}
	close IN;
	
	#print out count for this sublib only
	open OUT, ">./$folder/$blatresults_filtered_counts" or die;
	$uniquesitecount=@uniquesite;
	print OUT "barcode\tchr\tstrand\tbp\ttotalreads=$$folder\tuniquesite=$uniquesitecount\n";

	foreach $site (@uniquesite) {
		$site_percent=$$site/$$folder;
		$site_with_breakpointcount="$site\t$$site\t$site_percent";
		push (@site2print, $site_with_breakpointcount);
	}
	
	@sorted_site2print = sort{
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;
		# then sort descending by counts
		$b_fields[4] <=> $a_fields[4]  
	} @site2print;
	
	foreach $lineout (@sorted_site2print) {
		print OUT "$lineout\n";
	}
	
	close OUT;
}

