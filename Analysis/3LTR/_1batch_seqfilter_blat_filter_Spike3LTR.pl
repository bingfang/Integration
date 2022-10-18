#!/usr/bin/perl

#batch process filter for raw fasta
#batch blat
#batch blat filter

# input variables and convert to array
my $barcodes = $ENV{barcodes};
my @barcodes = split('\n', $barcodes);

# @barcodes=qw(
# 1ACTGT2AGCTA.txt);

foreach $file (@barcodes) {
	$folder=substr($file,0,14);  #pay attention here for the barcode length########################
	open LOG, ">>log.txt" or die;
	print LOG "\n$file\n";
	close LOG;
	
	system("mkdir $folder");
	system("cp $file PEread_LTR_Linker.txt");
	system("./Batch_Seqfilter.bat");
	
	system("./batch_blatF.bat");
	system("./batch_blatR.bat");
	
	system("./batch_blat_filter.bat");
	
	system("mv PEread_LTR_nonInternal_linker_long_UniquePairWct.txt ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePairWct_F.fa ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePairWct_R.fa ./$folder/");
	

	
	$blatresults_filtered3="$folder"."_blat.txt";
	system("cp PairedEndRIS_filter3.txt ./$folder/$blatresults_filtered3");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePairWct_F_R_blat.txt_grandcount.txt ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_F_blat.txt ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_F_blat.txt_filter1 ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_F_blat.txt_filter2_bestMatch ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_F_blat.txt_filter2_repeatMatch ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_R_blat.txt ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_R_blat.txt_filter1 ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_R_blat.txt_filter2_bestMatch ./$folder/");
	system("mv PEread_LTR_nonInternal_linker_long_UniquePair_R_blat.txt_filter2_repeatMatch ./$folder/");
	system("mv PairedEndRIS_filter1.txt ./$folder/");
	system("mv PairedEndRIS_filter2.txt ./$folder/");
	system("mv PairedEndRIS_filter3.txt ./$folder/");

}
	
