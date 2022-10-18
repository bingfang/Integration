#!/usr/bin/perl

#find .

open IN, "<PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt" or die;
open OUT, ">PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt_grandcount.txt" or die;



$totalcount=0;
$totalUnique=0;

%seen=();
%seen_this_chrcor=();
@unique_chrcor_pair=();


while ($line = <IN>) {
	chomp($line);
	$example=$line;
	@eles=split /\t/, $line;
	$tag_id = $eles[1];
	shift(@eles);
	$example=join("\t", @eles);
	($this_tag_count, $chrcor) = split /\t$tag_id\t/, $line;
	unless ($seen{$chrcor}++) {
		$seen_this_chrcor{$chrcor}=$example;
		}
	$$chrcor=$$chrcor+$this_tag_count;
}

while (($chrcor, $example) = each(%seen_this_chrcor)) {
	$example_w_count="$$chrcor"."\t"."$example";
	push(@unique_chrcor_pair, $example_w_count);
}

@sorted_unique_chrcor_pair = sort{
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$a_fields[2] cmp $b_fields[2]  # sort by chr
	||
	$a_fields[4] <=> $b_fields[4]  # then sort by cor
} @unique_chrcor_pair;

foreach $chrcor2print (@sorted_unique_chrcor_pair) {
	print OUT "$chrcor2print\n";
}

close IN;
close OUT;
