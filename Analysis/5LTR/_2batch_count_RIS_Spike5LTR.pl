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
	$sublibtotalcount=0;
	
	open IN, "<./$folder/$blatresults_filtered" or die;
	while ($line=<IN>) {
		chomp($line);
		@eles=split(/\t/,$line);
		
		$sublibtotalcount=$sublibtotalcount+$eles[0];
		$alllibtotalcount=$alllibtotalcount+$eles[0];
		
		#count each distinct integration site within a sub library
		$corineachsublib="$folder\t$eles[2]\t$eles[3]\t$eles[4]";
		$$corineachsublib=$$corineachsublib+$eles[0];
		$seeninsublib{$corineachsublib}=1;
		
		#count each distinct integration site in the whole library
		$corinallsublib="$eles[2]\t$eles[3]\t$eles[4]";
		$$corinallsublib=$$corinallsublib+$eles[0];
		$seeninallsublib{$corinallsublib}=1;
		#added on 12-18-12, count sub libs that seen this particular integration sites.
		$seen_in_this_many_sublib{$corinallsublib}++ unless $seen_in_this_sublib{$corineachsublib}++; 
		
	}
	close IN;
	
	#print out count for this sublib only
	@cor2print="";
	open OUT, ">./$folder/$blatresults_filtered_counts" or die;
	print OUT "barcode\tchr\tstrand\tbp\t$sublibtotalcount\n";
	foreach $corinsublib (sort keys %seeninsublib) {
		if($corinsublib=~/$folder/) {
			$lineout="$corinsublib\t$$corinsublib";
			push(@cor2print,$lineout);
		}
	}
	
	@sorted_cor2print = sort{
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;
		# then sort descending by counts
		$b_fields[4] <=> $a_fields[4]  
	} @cor2print;
	
	foreach $lineout (@sorted_cor2print) {
		print OUT "$lineout\n";
	}
	
	close OUT;
}


#grand count in all sublibrary
@cor2print="";
open OUT, ">RIS_grand_counts.txt" or die;
print OUT "chr\tstrand\tbp\tGrandTotalSites=$alllibtotalcount\t#sub_lib_seen_this_site\n";	
foreach $cor (sort keys %seeninallsublib) {
	# $lineout="$cor\t$$cor";
	# edit on 12-18-12
	print "$seen_in_this_many_sublib{$cor}\n";
	$lineout="$cor\t$$cor\t$seen_in_this_many_sublib{$cor}";
	push(@cor2print,$lineout);
}
#sort
@sorted_cor2print = sort{
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	# then sort descending by counts
	$b_fields[4] <=> $a_fields[4]  
} @cor2print;
#print
foreach $lineout (@sorted_cor2print) {
	print OUT "$lineout\n";
}
close OUT;
