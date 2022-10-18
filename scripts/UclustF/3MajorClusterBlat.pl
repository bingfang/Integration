#!/usr/bin/perl

#get seq for each id
open IN, "<MajorClusters.fa" or die;
open OUT, ">MajorClusters2blat.fa" or die;

for ($i=1;$i<101;$i++) {$line=<IN>; print OUT "$line";}

close IN;
close OUT;

#system("./batch_blatF.bat");
#system("perl batch_blatfilter1_startin3bpLen20bp.pl");
system("blat /Users/guos2/Genomes/hg19/hg19.2bit ./MajorClusters2blat.fa -ooc=11.ooc MajorClusters2blat_blat.txt -minScore=16 -stepSize=8");
