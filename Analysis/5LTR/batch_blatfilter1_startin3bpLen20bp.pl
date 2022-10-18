#!/bin/perl

#filter1:  start<=3 and match_len>19, then sort by each tagID

#Format
#psLayout version 3
#
#match	mis- 	rep. 	N's	Q gap	Q gap	T gap	T gap	strand	Q        	Q   	Q    	Q  	T        	T   	T    	T  	block	blockSizes 	qStarts	 tStarts
#     	match	match	   	count	bases	count	bases	      	name     	size	start	end	name     	size	start	end	count
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#80	0	0	0	0	0	0	0	+	FTF2IS401C9OTF_LTR	123	42	122	chr1	197195432	43516678	43516758	1	80,	42,	43516678,
#71	0	0	0	0	0	0	0	-	FTF2IS401A43VI_LTR	77	0	71	chr1	197195432	82334892	82334963	1	71,	6,	82334892,


@libs=qw(PEread_LTR_nonInternal_linker_long_UniquePair_F
PEread_LTR_nonInternal_linker_long_UniquePair_R);

foreach $lib (@libs) {
	filter1($lib);
}

sub filter1 {
	$libname = "$_[0]"."_blat.txt";
	$file2open="$libname";
	$file2out="$libname\_filter1";
	
	@lines=();
	
	#filter by match_start<=3, match_len>19
	
	open IN, "<$file2open" or die;
	print "$file2open\n";
	
	while ($line=<IN>) {
		@eles=split(/\t/, $line);
		#start <4
		#Qgap[5] <10
		#Tgap[7] <10
		#identity >95% [0]/([12]-[11])
		if($eles[11]<4 and $eles[5]<10 and $eles[7]<10 and $eles[0]>19 and $eles[0]/($eles[12]-$eles[11])>0.95) { #/
			push(@lines, $line);
		}
	}
	
	close IN;
	
	#sort
	open OUT, ">$file2out" or die;
	
	@sorted_lines = sort {
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;
		
		$a_fields[9] cmp $b_fields[9]  # sort by seq ID
		||
		$b_fields[0] <=> $a_fields[0]  # then sort by match length
	} @lines;
	
	foreach $line (@sorted_lines) {
		print OUT "$line";
	}
	close OUT;

}

