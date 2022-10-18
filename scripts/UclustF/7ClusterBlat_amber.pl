#!/usr/bin/perl

#get seq for each id
open IN, "<PEread_LTR_nonInternal_linker_long_q20_F10bp_sortedExpanded_cluster_w_seq.txt" or die;
open OUT, ">Clusters2blat.fa" or die;

while ($line=<IN>) {
    chomp($line);
    @eles = split (/\t/, $line);
    if ($eles[2] > 1) {
        ($id,$rest) = split(/\_/, $eles[8]);
        $newid = $id."_C_".$eles[2];
        $newline = ">".$newid."\n".$eles[10]."\n";
        print OUT "$newline";
    }
}

close IN;
close OUT;

#system("./batch_blatF.bat");
#system("perl batch_blatfilter1_startin3bpLen20bp.pl");
system("blat /Users/guos2/Genomes/hg19/hg19.2bit ./Clusters2blat.fa -ooc=11.ooc Clusters2blat_blat.txt -minScore=16 -stepSize=8");