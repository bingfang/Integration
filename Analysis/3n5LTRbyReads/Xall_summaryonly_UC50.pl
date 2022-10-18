#!usr/bin/perl

#get summary info

@PT2695=qw(
GH2718_3n5combined_1TGGTCA2CTGATC.txt
GH2719_3n5combined_1CACTGT2AAGCTA.txt
GH2720_3n5combined_1CGTACG2AAGCTA.txt
);

open OUT, ">PT2695_24msamples_summary.xls" or die;
print OUT "library\ttotal\tunique\tsingleton\tdoubleton\tsitemorethan1perc\tmostfreq clone\tchao\tOCI\tUC50\n";

foreach $file2open (@PT2695) {

	$sitemorethan1perc=0;
	$mostfreqclone=0;
	$accumulatepercent=0;
	$UC50=0;
	
	open IN, "<$file2open" or die;
	<IN>;<IN>;
	$line3=<IN>;
	chomp($line3);
	($unique, $total, $singleton, $doubleton)=split (/\t/, $line3);
	$line4=<IN>;
	chomp($line4);
	($junk, $chao)=split(/=/, $line4);
	$line5=<IN>;
	chomp($line5);
	($junk, $OCI)=split(/=/, $line5);
	<IN>;<IN>;<IN>;<IN>;<IN>;
	
	while ($line=<IN>) {
		chomp($line);
		 @eles=split(/\t/, $line);
		 $mostfreqclone=$eles[5] if $eles[5]>$mostfreqclone;
		 if($eles[5]>0.01) {$sitemorethan1perc++;}
		 $accumulatepercent=$accumulatepercent+$eles[5];
		 $UC50++ if $accumulatepercent <0.5;
	}
	
	close IN;
	
	print OUT "$file2open\t$total\t$unique\t$singleton\t$doubleton\t$sitemorethan1perc\t$mostfreqclone\t$chao\t$OCI\t$UC50\n";
}



