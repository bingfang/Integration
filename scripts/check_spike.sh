#!/usr/bin/bash


# spike DNA has integration site at human hg19 chr17:3618824
# - strain: GTTCGTGCCTC
# + strain: ACGAACCTATT


root="/Volumes/T7/202003_Ras/data_analysis/Integration_SyncV_20220309/20221007_plate4_14samples/"

cd "${root}/Analysis/3LTR/"
echo "3LTR"
for f in 1*2*.txt
do
  echo ${f}  
  grep "GTTCGTGCC" ${f} | wc 
  
  grep "CGAACCTATT" ${f} | wc 
  
done

cd "${root}/Analysis/5LTR/"
echo "5LTR"
for f in 1*2*.txt
do
  echo ${f}  
  grep "GTTCGTGCC" ${f} | wc 
  grep "CGAACCTATT" ${f} | wc 
  
done