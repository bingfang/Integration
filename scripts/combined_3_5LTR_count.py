#!/usr/local/bin/python3.6

import glob
import re
from operator import itemgetter

# cope from barcode design page
samples_3LTR="""1CGTGAT2TAGCTT	1_1_41_RPZ28687_L4
1ACATCG2TAGCTT	2_105_67_RPZ28693_G9
1GCCTAA2TAGCTT	3_106_68_RPZ28693_I15
1TGGTCA2TAGCTT	4_107_69_RPZ28693_D21
1CACTGT2TAGCTT	5_108_70_RPZ28693_I6
1TGACCA2TAGCTT	6_109_71_RPZ28693_G19
1CGTACG2TAGCTT	7_110_72_RPZ28693_O15
1CGTGAT2CTTGTA	8_111_73_RPZ28693_E16
1ACATCG2CTTGTA	9_112_74_RPZ28693_O18
1GCCTAA2CTTGTA	10_1_RPZ28707
1TGGTCA2CTTGTA	11_9_RPZ28707
1CACTGT2CTTGTA	12_17_RPZ28707
1TGACCA2CTTGTA	13_25_RPZ28707
1CGTACG2CTTGTA	14_33_RPZ28707"""

samples_5LTR="""1CGTGAT2ATTGGC	1_1_41_RPZ28687_L4
1ACATCG2ATTGGC	2_105_67_RPZ28693_G9
1GCCTAA2ATTGGC	3_106_68_RPZ28693_I15
1TGGTCA2ATTGGC	4_107_69_RPZ28693_D21
1CACTGT2ATTGGC	5_108_70_RPZ28693_I6
1TGACCA2ATTGGC	6_109_71_RPZ28693_G19
1CGTACG2ATTGGC	7_110_72_RPZ28693_O15
1CGTGAT2GATCTG	8_111_73_RPZ28693_E16
1ACATCG2GATCTG	9_112_74_RPZ28693_O18
1GCCTAA2GATCTG	10_1_RPZ28707
1TGGTCA2GATCTG	11_9_RPZ28707
1CACTGT2GATCTG	12_17_RPZ28707
1TGACCA2GATCTG	13_25_RPZ28707
1CGTACG2GATCTG	14_33_RPZ28707"""
sample_list_3LTR = samples_3LTR.split('\n')
sample_list_5LTR = samples_5LTR.split('\n')

for i in range(len(sample_list_3LTR)):
    sample_info_3LTR= sample_list_3LTR[i].split('\t')
    sample_info_5LTR= sample_list_5LTR[i].split('\t')
    # folder name = barcode
    # data from barcode_blat_defuzz_counts.txt
    folder_3LTR=sample_info_3LTR[0] 
    folder_5LTR=sample_info_5LTR[0] 
    LTR3=folder_3LTR + "_blat_defuzz_counts.txt"
    LTR5=folder_5LTR + "_blat_defuzz_counts.txt"
    find3LTR = "./Analysis/3LTR/" + folder_3LTR +"/" +LTR3
    find5LTR = "./Analysis/5LTR/" + folder_5LTR +"/" +LTR5
    
    # open both 3LTR and  5LTR data and write in data_all.
    with open(find3LTR, "r") as f:
        data_3LTR = f.read().rstrip()
        data_3LTR = data_3LTR.split("\n")

    with open(find5LTR, "r") as f:
        data_5LTR = f.read().rstrip().split("\n")
        print(data_5LTR)
    data_all =[]    
    for item in data_3LTR:
        line=item.rstrip() + "\t3LTR"
        print(line)
        data_all.append(item.rstrip() + "\t3LTR") 
    for item in data_5LTR:
        line=item.rstrip() + "\t5LTR"
        print(line)
        data_all.append(item.rstrip() + "\t5LTR")

    
    # create list of list to sort based on chr.
    # remove sites with reads =<10
    data_list = []
    for item in data_all:
        line = item.split("\t")
        if "totalbreakpoint" not in line[4]:
            if float(line[4]) > 10:
                data_list.append(item.split("\t"))
    sorted_sites = sorted(data_list, key=itemgetter(1))
    
    # 
    with open("combined_defuzz_counts_final.txt", "a") as f:
        f.write(sample_info_3LTR[1] +'\n')  # sample name
        f.write(sample_info_3LTR[0]+'\n')   # barcode
        for item in sorted_sites:        
            f.write("\t".join(item)+'\n')
            
            
            
            
            