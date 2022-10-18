#!/usr/bin/perl

##blat results filter

#find tags that match to single, or repeat, defined as >5 matches with scores <10 from the best
open IN, "<MajorClusters2blat.fa" or die;
while ($line=<IN>) {
	chomp($line);
	if ($line=~/^>(.*)/) {
		$id=$1;
		push(@majorclusterids, $id);
	}
}
close IN;


open IN, "<MajorClusters2blat_blat.txt" or die;
open OUT, ">MajorClusters2blat_blat.filter1.txt" or die;
open OUTS, ">MajorClusters2blat_blat.summary.txt" or die;

while ($line=<IN>) {
	chomp($line);
	@eles=split(/\t/, $line);
	$id=$eles[9];
	push(@$id, $line);
}

foreach $id (@majorclusterids) {

	
	@sorted_lines = sort {
		@a_fields = split /\t/, $a;
		@b_fields = split /\t/, $b;

		$b_fields[0] <=> $a_fields[0]; #sort by score
	} @$id;
	
	@$id=@sorted_lines;
	
	$maplocations=@$id;
	print OUT "$id\t$maplocations\n";
	foreach $blathit (@$id) {
		print OUT "$blathit\n";
	}
	print OUT "\n";
}

foreach $id (@majorclusterids) {
	$maplocations=@$id;
	print OUTS "$id\t$maplocations\t";
	$firstblathit=shift(@$id);
	$secondblathit=shift(@$id);
	$thirdblathit=shift(@$id);
	$forthblathit=shift(@$id);
	$fifthdblathit=shift(@$id);
	
	if($maplocations==1) {
		@blatsplit=split(/\t/, $firstblathit);
		
		if($blatsplit[8] eq "+") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[15]";}
		if($blatsplit[8] eq "-") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[16]";}
		
		print OUTS "$intsite\t";
	}
	
	if($maplocations>1) {
		print "multihits\n";
		@blatsplit=split(/\t/, $firstblathit);
		@blatsplit2=split(/\t/, $secondblathit);
		@blatsplit3=split(/\t/, $thirdblathit);
		@blatsplit4=split(/\t/, $forthblathit);
		@blatsplit5=split(/\t/, $fifthblathit);
		
		if($blatsplit[0]>$blatsplit2[0]+5) {
			print "best hit\n";
			if($blatsplit[8] eq "+") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[15]";}
			if($blatsplit[8] eq "-") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[16]";}
			print OUTS "$intsite\t";
		}
		else {
			if($blatsplit[8] eq "+") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[15]";}
			if($blatsplit[8] eq "-") { $intsite="$blatsplit[13]$blatsplit[8]$blatsplit[16]";}
			print OUTS "$intsite\t";
			if($blatsplit2[8] eq "+") { $intsite="$blatsplit2[13]$blatsplit2[8]$blatsplit2[15]";}
			if($blatsplit2[8] eq "-") { $intsite="$blatsplit2[13]$blatsplit2[8]$blatsplit2[16]";}
			print OUTS "$intsite\t";
			if($blatsplit3[8] eq "+") { $intsite="$blatsplit3[13]$blatsplit3[8]$blatsplit3[15]";}
			if($blatsplit3[8] eq "-") { $intsite="$blatsplit3[13]$blatsplit3[8]$blatsplit3[16]";}
			print OUTS "$intsite\t";
			if($blatsplit4[8] eq "+") { $intsite="$blatsplit4[13]$blatsplit4[8]$blatsplit4[15]";}
			if($blatsplit4[8] eq "-") { $intsite="$blatsplit4[13]$blatsplit4[8]$blatsplit4[16]";}
			print OUTS "$intsite\t";
		}
			
	}

	print OUTS "\n";
		

}

close IN;
close OUT;
close OUTS;



