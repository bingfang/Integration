#!/usr/bin/perl

#choose non-redundant integration sites

#first get count of each sequence
#open IN, "<BPTFPHD_LTR_insert_Linker_Ct2ormore.txt" or die;
#while ($line = <IN>) {
#	chomp($line);	
#	@eles = split(/\t/, $line);
#	$id_and_count=$eles[0];
#	($id, $count)=split /\#/,$id_and_count;
#	$id2count{$id_and_count}=$count;
#}
#close IN;

open INL, "<PEread_LTR_nonInternal_linker_long_UniquePair_F_blat.txt_filter2_bestMatch" or die;
open INR, "<PEread_LTR_nonInternal_linker_long_UniquePair_R_blat.txt_filter2_bestMatch" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt" or die;

%ID2corL=();
%ID2corR=();

while ($line = <INL>) {
	chomp($line);
	@eles = split(/\t/, $line);
	
	$id=$eles[10];
	($idwocount, $count)=split /\#/,$id;
	$id2count{$id}=$count;
	
	if($eles[9] eq "+") {
		$chrcor="$eles[14]"."\t+\t"."$eles[16]";
	}
	else{$chrcor="$eles[14]"."\t-\t"."$eles[17]";}
	
	$ID2corL{$id} = $chrcor;
}

while ($line = <INR>) {
	chomp($line);
	@eles = split(/\t/, $line);
	
	$id=$eles[10];
	($idwocount, $count)=split /\#/,$id;
	$id2count{$id}=$count;
	
	if($eles[9] eq "+") {
		$chrcor="$eles[14]"."\t+\t"."$eles[16]";
	}
	else{$chrcor="$eles[14]"."\t-\t"."$eles[17]";}
	
	$ID2corR{$id} = $chrcor;
}

while (($id, $cor)=each(%ID2corL)) {
	$bestmatch = "$id\t$cor";
	push (@bestmatches, $bestmatch);
}

@sorted_bestmatches = sort{
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$a_fields[1] cmp $b_fields[1]  # sort by chr
	||
	$a_fields[3] <=> $b_fields[3]  # then sort by cor
} @bestmatches;

foreach $RIS (@sorted_bestmatches) {
	@eles=split /\t/, $RIS;
	$id = $eles[0];
	print OUT "$id2count{$id}\t$RIS\t$ID2corR{$id}\n";
}

close INL;
close INR;
close OUT;
