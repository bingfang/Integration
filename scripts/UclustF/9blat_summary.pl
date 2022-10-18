#!/usr/bin/perl

#count all same site
open IN, "<Clusters2blat_blat.summary.txt" or die;
open OUT, ">Clusters2blat_blat.summary2grand.txt" or die;

while ($line=<IN>) {
	chomp($line);
	@eles=split(/\t/, $line);
	$mappedlocation=@eles;
	$mappedlocation=$mappedlocation-2;
	
	if ($mappedlocation==0) {
		$i++;
		$site="unknown"."$i";
	}
	elsif($mappedlocation==1) {
		$site=$eles[2];
	}
	elsif($mappedlocation>1) {
		$site="$eles[2]"."andMore";
	}
	
	($idontcare, $thiscount) =split(/C\_/, $eles[0]);
	$$site=$$site + $thiscount;
	$site2read="$site"."read";
	$$site2read="$$site2read"." $eles[0]";
	
	push(@sites, $site) unless $seen{$site}++;
}

foreach $site (@sites) {
	$site2read="$site"."read";
	$site2count="$site\t$$site\t$$site2read";
	push(@site_count_pair, $site2count);
}

@sorted_lines = sort {
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;

		$b_fields[1] <=> $a_fields[1]; #sort by score
} @site_count_pair;

foreach $site (@sorted_lines) {
	print OUT "$site\n";
}

close IN;
close OUT;
