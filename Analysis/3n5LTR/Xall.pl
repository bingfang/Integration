#!usr/bin/perl

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

# input variables and convert to array
my $PT2695 = $ENV{PT2695};
my @PT2695 = split('\n', $PT2695);


foreach $file2open (@PT2695) {
	open IN, "<$file2open" or die;
	for (1..10) {<IN>;};
	
	while ($line=<IN>) {
		chomp($line);
		 @eles=split(/\t/, $line);
		 $site="$eles[1]\t$eles[2]\t$eles[3]";
		 $filename_site="$file2open\t$site";
		 $$filename_site=$eles[4];
		
		push (@uniquesites, $site) unless $seen{$site}++;
	}
	
	close IN;
}

@sorted_uniquesites = sort {
	 @a_fields = split /\t/, $a;
	 @b_fields = split /\t/, $b;
	
	$a_fields[0] cmp $b_fields[0]  # sort by chr
	||
	$a_fields[2] <=> $b_fields[2]  # then sort by bp

} @uniquesites;

open OUT, ">Combined_allsites.xls" or die;

######print header
print OUT "chr\tstrand\tbp";
@libs=@PT2695;
foreach $lib (@libs) {
	$lib=~s/_3n5combined.txt//;
	print OUT "\t$lib";
}
print OUT "\n";

foreach $site (@sorted_uniquesites) {
	
	print OUT "$site\t";
	foreach $file2open (@PT2695) {
		$filename_site="$file2open\t$site";
		print OUT "$$filename_site\t";
	}
	
	$thistargetgene=findtargetgene($site);
	
	print OUT "$thistargetgene\n";
}

close OUT;

##############################################
sub findtargetgene {
	($chr, $strand, $coordinate)=split (/\t/, $_[0]);

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
	return ($targetgene);

}



		