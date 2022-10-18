#!/usr/bin/bash


#SBATCH -o slurm_%j.out
#SBATCH -e slurm_%j.err

export root="/Volumes/T7/202003_Ras/data_analysis/Integration_SyncV_20220309/ISA_template/"
export Datadir="${root}Data/"
export LTR3dir="${root}Analysis/3LTR/"
export LTR5dir="${root}Analysis/5LTR/"
#export LTR3n5dir="${root}Analysis/3n5LTR/"
#export LTR3n5byReadsdir="${root}Analysis/3n5LTRbyReads/"


cd ${LTR5dir}
rm 1*2*.txt
rm -r 1*2*

export filenametemplate="../../Data/ISA-P2-20220928_S1_L001_"
echo $filenametemplate
export PE1barcodes="CGTGAT	ACATCG	GCCTAA	TGGTCA	CACTGT	TGACCA	CGTACG"
export PE2barcodes="TAGCTT	CTTGTA	ATTGGC	GATCTG	TCAAGT	CTGATC"
export barcodes="
1CGTGAT2TAGCTT.txt
1ACATCG2TAGCTT.txt
1GCCTAA2TAGCTT.txt
1TGGTCA2TAGCTT.txt
1CACTGT2TAGCTT.txt
1TGACCA2TAGCTT.txt
1CGTACG2TAGCTT.txt
1CGTGAT2CTTGTA.txt
1ACATCG2CTTGTA.txt
1GCCTAA2CTTGTA.txt
1TGGTCA2CTTGTA.txt
1CACTGT2CTTGTA.txt
1TGACCA2CTTGTA.txt
1CGTACG2CTTGTA.txt
1CGTGAT2ATTGGC.txt
1ACATCG2ATTGGC.txt
1GCCTAA2ATTGGC.txt
1TGGTCA2ATTGGC.txt
1CACTGT2ATTGGC.txt
1TGACCA2ATTGGC.txt
1CGTACG2ATTGGC.txt
1CGTGAT2GATCTG.txt
1ACATCG2GATCTG.txt
1GCCTAA2GATCTG.txt
1TGGTCA2GATCTG.txt
1CACTGT2GATCTG.txt
1TGACCA2GATCTG.txt
1CGTACG2GATCTG.txt
1CGTGAT2TCAAGT.txt
1ACATCG2TCAAGT.txt
1GCCTAA2TCAAGT.txt
1TGGTCA2TCAAGT.txt
1CACTGT2TCAAGT.txt
1TGACCA2TCAAGT.txt
1CGTACG2TCAAGT.txt
1CGTGAT2CTGATC.txt
1ACATCG2CTGATC.txt
1GCCTAA2CTGATC.txt
1TGGTCA2CTGATC.txt
1CACTGT2CTGATC.txt
1TGACCA2CTGATC.txt
1CGTACG2CTGATC.txt
"


/usr/bin/perl _0debarcodingBatchFilter_1read_gz_paired_end_findLTR_linker_new5LTR.pl
#/usr/bin/perl _1batch_seqfilter_blat_filter_Spike5LTR.pl
#/usr/bin/perl _2batch_count_RIS_Spike5LTR.pl
#/usr/bin/perl _3batch_defuzz.pl
#/usr/bin/perl _4batch_count_RIS_byBreakPoint.pl
#/usr/bin/perl _5batch_count_RIS_byReads.pl

