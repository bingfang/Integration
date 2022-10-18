#!/usr/bin/perl

#process gz seq files

use File::Temp ();
use Archive::Extract ();


# input variables and convert to array
my $filenametemplate = $ENV{filenametemplate};
my $PE1barcodes = $ENV{PE1barcodes};
my $PE2barcodes = $ENV{PE2barcodes};
print "$PE1barcodes\n";

my @PE1barcodes = split('\t', $PE1barcodes);
my @PE2barcodes = split('\t', $PE2barcodes);

$numPE1barcodes=@PE1barcodes;
$numPE2barcodes=@PE2barcodes;

for($i=0;$i<$numPE1barcodes;$i++) {
	for($j=0;$j<$numPE2barcodes;$j++) {
		$filename="1"."$PE1barcodes[$i]"."2"."$PE2barcodes[$j]";
		#do not use 1st base in barcode because many of them are N, start with 1 instead of 0
		$PE1_5bp=substr($PE1barcodes[$i], 1, 5);
		$PE2_5bp=substr($PE2barcodes[$j], 1, 5);
		$barcodes="$PE1_5bp"."$PE2_5bp";
		$barcodes2filename{$barcodes}=$filename;
	}
}


#normally 4 .gz file per MiSeq run
#001
#002

@files2read = qw(
001
);




for my $subnum ( @files2read ) {

	my $R1="./$filenametemplate"."R1_"."$subnum".".fastq.gz";
	my $R2="./$filenametemplate"."R2_"."$subnum".".fastq.gz";
	
	my $read1 = File::Temp->new();
	my $read2 = File::Temp->new();

  	my $ae1 = Archive::Extract->new( archive => $R1 );
  	print "$R1\n";
  	my $ok1 = $ae1->extract( to => $read1->filename );
  	die $ae1->error unless $ok1;
  	
  	my $ae2 = Archive::Extract->new( archive => $R2 );
  	print "$R2\n";
  	my $ok2 = $ae2->extract( to => $read2->filename );
  	die $ae2->error unless $ok2;

  # do what you want to the uncompressed content in the
  # file named $tmp->filename
  #...
  # at the end of the scope, $tmp vanishes 
  
  
	open INread1, "<$read1" or die;
	open INread2, "<$read2" or die;
	while ($lineread1=<INread1>) {
		chomp($lineread1);
		if($lineread1=~/(^@.*)( 1.*)/) {
			$totalreads++;
			$read1_id=$1;
			$read1_id =~s/\@//;
			$read1_seq=<INread1>;
			chomp($read1_seq);
			<INread1>;  #the + sign in between seq and quality
			$read1_qual=<INread1>;
			chomp($read1_qual);
			
			$lineread2=<INread2>;
			chomp($lineread2);
			($read2_id,$anything)=split(/\ /, $lineread2);
			$read2_id =~s/\@//;
			$read2_seq=<INread2>;
			chomp($read2_seq);
			<INread2>;
			$read2_qual=<INread2>;
			chomp($read2_qual);
			if($read2_seq=~/......AGGGCTCCGCTTAAGGGACT(.*)/) {  #all linker add a T at the end after ligation
				$read2_seq_trimmed=$1;
				$read2_qual_trimmed=substr $read2_qual,26;
			}
			else{
				$read2_seq_trimmed=$read2_seq;
				$read2_qual_trimmed=$read2_qual;
			}
			
			
			
			if($read1_id ne $read2_id){
				print "read1_id does not match read2_id:\n$read1_id\n$read2_id\n";
			}
			
			# 1. PE1_LTRnest_4	TGACCA
			# 2. PE1_LTRnest_22	CGTACG
			# 3. PE2_Linkernest_10	TAGCTT
			# 4. PE2_Linkernest_12	CTTGTA
			
			$read1_nestedPrimer=substr($read1_seq,6,24); #AGATCTTGTCTTCGTTGGGAGTGA
			$read1_bp2to6=substr($read1_seq,1,5);
			$read2_bp2to6=substr($read2_seq,1,5);
			$barcodes="$read1_bp2to6"."$read2_bp2to6";
			$filename=$barcodes2filename{$barcodes};

			$LTR_junction=$read1_seq;
			
			#if Ras-5'LTR vector, split like this  nested primer:       AGATCTTGTCTTCGTTGGGAGTGA_ATTAGCCCTTCCA_GTCCCC
			if ($read1_nestedPrimer eq "AGATCTTGTCTTCGTTGGGAGTGA") { #Junction: TCTTCTTTGGGAGTGAATTAGCCC_TTCCA_GTCCCC
				($preLTRend, $postLTRend) = split (/CCCTTCCA/, $LTR_junction);
				$LTR_junction= "$preLTRend"."CCCTTCCA\t"."$postLTRend";
			}

			
			#print format:  id	read1or2	LTR-TCTCTAGCA	insert	qualification
			push (@$filename, "$read1_id\t1\t$LTR_junction\t$read1_qual\t\t\t\t\t\t\t\t\t$read2_id\t2\t$read2_seq_trimmed\t$read2_qual_trimmed\t\t\t\t\t\t\t\t\n");

		}
		
	}
	
	close INread1;
	close INread2;  
}

print "Totalreads:\t$totalreads\n";
while(($barcodes, $filename)=each(%barcodes2filename)) {
	$counts=@$filename;
	print "$filename\:\t$counts\n";
	$file2print="$filename".".txt";
	open OUT, ">$file2print" or die;
	foreach $line (@$filename) {
		print OUT "$line";
	}
	close OUT;
}
	
