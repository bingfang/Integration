#!/usr/bin/perl

#create 5LTR pseudo and then merge

my ($LTR3, $LTR5) = @ARGV;


$file3LTR=$LTR3;
$file5LTR=$LTR5;

$file5LTRpseudo=$file5LTR;
$file5LTRpseudo=~s/5LTR/5LTRpseudo/;

$filecombined=$file3LTR;
$filecombined=~s/3LTR/3n5combined/;



open LTR5, "<$file5LTR" or die;

open LTR5pseudo, ">$file5LTRpseudo" or die;

$line=<LTR5>;
print LTR5pseudo "$line";

while ($line=<LTR5>) {
	chomp($line);
	@eles=split(/\t/, $line);
	if ($eles[2] eq "-") { $eles[2]="+"; $eles[3]=$eles[3]-5;}
	elsif ($eles[2] eq "+") { $eles[2]="-"; $eles[3]=$eles[3]+5;}	
	print LTR5pseudo "$eles[0]\t$eles[1]\t$eles[2]\t$eles[3]\t$eles[4]\t$eles[5]\n";
}

close LTR5;
close LTR5pseudo;


##############################
open IN, "<$file3LTR" or die;

$line=<IN>;
chomp($line);
@eles=split(/\t/, $line);


while ($line=<IN>) {
	chomp($line);
	@eles=split(/\t/, $line);
	$site="$eles[1]\t$eles[2]\t$eles[3]";
	if($site eq "chr17	+	3618824") {$spike3LTR=$line; next;}
	$site3LTR="$site"."3LTR";
	$$site3LTR=$eles[4];
	$total3LTRjunctions=$total3LTRjunctions+$eles[4];
	push (@uniquesites, $site) unless $seen{$site}++;
}


close IN;


###############################
open IN, "<$file5LTRpseudo" or die;

$line=<IN>;
chomp($line);
@eles=split(/\t/, $line);


while ($line=<IN>) {
	chomp($line);
	@eles=split(/\t/, $line);
	$site="$eles[1]\t$eles[2]\t$eles[3]";
	if($site eq "chr17	+	3618824") {$spike5LTR=$line; next;}
	$site5LTRpseudo="$site"."5LTRpseudo";
	$$site5LTRpseudo=$eles[4];
	$total5LTRpseudojunctions=$total5LTRpseudojunctions+$eles[4];
	push (@uniquesites, $site) unless $seen{$site}++;
}

close IN;


################################################
$refgenefile = "/Users/xubr/Documents/data_analysis/index/mm10db/mm10_refGene.txt";

open REF, "<$refgenefile" or die;

while ($line = <REF>) {
	chomp($line);
	@eles = split(/\t/, $line);
	$chr = $eles[2];
	push (@chrs, $chr) unless $seen{$chr}++;
	push (@$chr, $line);
}

close REF;
################################################


open OUT, ">$filecombined" or die;

$total3n5=$total3LTRjunctions+$total5LTRpseudojunctions;
$total3n5unique=@uniquesites;

foreach $site (@uniquesites) {
	$site3LTR="$site"."3LTR";
	$site5LTRpseudo="$site"."5LTRpseudo";
	$thissite3n5counts=$$site3LTR+$$site5LTRpseudo;
	$perc=$thissite3n5counts/$total3n5;
	$perc=sprintf("%.5f", $perc);
	if(length ($$site3LTR) >0 and length ($$site5LTRpseudo) >0) {
		$lib="3n5";
	}
	elsif(length ($$site3LTR) >0 and length ($$site5LTRpseudo) ==0) {
		$lib="3LTR";
	}
	elsif(length ($$site3LTR) ==0 and length ($$site5LTRpseudo) >0) {
		$lib="5LTR";
	}
	
	$thiscombinedsite="$lib\t$site\t$thissite3n5counts\t$perc\t$$site3LTR\t$$site5LTRpseudo";
	push (@combinedsites, $thiscombinedsite);
	
}

#sort by combined counts, then chr, then site
@sorted_combinedsites = sort {
	@a_fields = split /\t/, $a;
	@b_fields = split /\t/, $b;
	
	$b_fields[4] <=> $a_fields[4] # sort by counts of breakpoint
	||
	$a_fields[1] cmp $b_fields[1]  # sort by chr
	||
	$a_fields[3] <=> $b_fields[3]  # then sort by bp

} @combinedsites;

#########################find target genes
foreach $site (@sorted_combinedsites ){ 
	
	@eles = split(/\t/, $site);
	$chr = $eles[1];
	$strand=$eles[2];
	$coordinate = $eles[3];
	$breakpointscount=$eles[4];
	
	###############################calculate chao estimator
	$f1count++ if $breakpointscount==1;
	$f2count++ if $breakpointscount==2;
	
	
	################################findnearest gene and print OUT
	$coordinate30kbup = $coordinate -30000;
	$coordinate30kbdown = $coordinate +30000;
	$ucsclink = "\=HYPERLINK(\"http://genome.ucsc.edu/cgi-bin/hgTracks?clade=vertebrate&org=Human&db=hg19&position=$chr\:$coordinate30kbup\-$coordinate30kbdown\")";

	
	$in_or_near = "out";
	$distance2nearestgene = "100000000";
	$targetgene="";

	#check for each gene on the chr
	foreach $refgene (@$chr) {
		@annotations = split(/\t/, $refgene);
		$refID = $annotations[1];
		$txstrand=$annotations[3];
		$txstart = $annotations[4];
		$txend = $annotations[5];
		$genename = $annotations[12];
		
		if ($coordinate > $txstart and $coordinate < $txend) {
			#this RIS is in this gene
			$in_or_near = "in";
			
			$exonnum= $annotations[8];
			$exonstart= $annotations[9];
			$exonend = $annotations[10];
			
			@exonstarts = split(/\,/, $exonstart);
			@exonends= split(/\,/, $exonend);
			
			$exon_or_intron = "intron";
			for($i = 0; $i<$exonnum; $i++) {  #check to see if in each exon
				if($coordinate > $exonstarts[$i] and $coordinate < $exonends[$i]) {
					#this RIS is in this Exon
					$exon_or_intron = "exon";
				}
			}
			
			$targetgene="$genename\t$refID\t$txstrand\t$txstart\t$txend\t$ucsclink\t$in_or_near\t$exon_or_intron";
		}
		else {
			#this RIS is outside of this gene, then calculate the distance from txStart and txEnd
			$distance2txstart = abs($txstart - $coordinate);
			$distance2txend = abs($txend - $coordinate);
			if($distance2txstart > $distance2txend) {
				$distance = $distance2txend;
			}
			else {$distance = $distance2txstart;}
			
			if($distance <$distance2nearestgene) {
				$distance2nearestgene = $distance;
				$nearestgene = "$genename\t$refID\t$txstrand\t$txstart\t$txend";
			}
		}
	}
	
	#at the end of checking for all genes, choose the nearest one.
	if($in_or_near eq "out") {
		$targetgene="$nearestgene\t$ucsclink\t$in_or_near\t$distance2nearestgene";
	}

	############################print 
	$site_and_targetgene="$site\t$targetgene";
	push(@sites_and_targetgenes, $site_and_targetgene);
	
}

################# calculate OCI:  sum(acumulated_fraction/totalUniquesites)
foreach $site (@sorted_combinedsites ){ 
	
	@eles = split(/\t/, $site);
	$chr = $eles[1];
	$strand=$eles[2];
	$coordinate = $eles[3];
	$accumulative_counts=$accumulative_counts+$eles[4];
	$accumulateive_fraction=$accumulative_counts/$total3n5;
	$SumXk=$SumXk+$accumulateive_fraction/$total3n5unique;
	
}
$OCI=2*($SumXk-0.5);

################### print 
$chaoestimator=$total3n5unique+$f1count*($f1count-1)/(2*($f2count+1));
$chaoestimatorline="UniqueSite\tTotalSiteswithdifferenbreakpoint\tSingleton\tDoubleton\n$total3n5unique\t$total3n5\t$f1count\t$f2count\nChaoEstimator: totalUniquesites + f1*(f1-1)/2(f2+1) =$chaoestimator";
print OUT '###########################################################################'; print OUT "\n";
print OUT "$chaoestimatorline\n";
print OUT "OCI=$OCI\n";
print OUT "SpikeIn3LTR\t$spike3LTR\nSpikeIN5LTR\t$spike5LTR\n";
print OUT '###########################################################################'; print OUT "\n\n";


print OUT "3n5\tchr\tstrand\tsite\tTotalsites\=$total3n5\tpercent\t3LTRsites\=$total3LTRjunctions\t5LTRsite\=$total5LTRpseudojunctions\t";
print OUT "targetgene\tRefID\tgeneStrand\tTSS\tTSE\tUCSC\tIN/OUTgene\tIntron/Exon/Distance2nearestgene\n";

foreach $outputline (@sites_and_targetgenes) {print OUT "$outputline\n";}

close OUT;



#(sed -i '1s/^/$chaoestimatorline\n/' $filecombined);




