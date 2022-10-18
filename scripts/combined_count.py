#!/usr/local/bin/python3.6

import glob
import re
from operator import itemgetter

# cope from barcode design page
samples="""1CGTGAT2TAGCTT	1_D11_RPZ28614
1ACATCG2TAGCTT	2_K20_RPZ28614
1GCCTAA2TAGCTT	3_C3_RPZ28614
1TGGTCA2TAGCTT	4_H6_RPZ28614
1CACTGT2TAGCTT	5_N7_RPZ28614
1TGACCA2TAGCTT	6_H10_RPZ28614
1CGTACG2TAGCTT	7_N10_RPZ28614
1CGTGAT2CTTGTA	8_C15_RPZ28614
1ACATCG2CTTGTA	9_D18_RPZ28614
1GCCTAA2CTTGTA	10_N18_RPZ28614
1TGGTCA2CTTGTA	11_L17_RPZ28614
1CACTGT2CTTGTA	12_E2_RPZ28614
1TGACCA2CTTGTA	14_J13_RPZ28614
1CGTACG2CTTGTA	13_D2_RPZ28615
1CGTGAT2ATTGGC	15_O4_RPZ28615
1ACATCG2ATTGGC	16_M14_RPZ28615
1GCCTAA2ATTGGC	17_H16_RPZ28615
1TGGTCA2ATTGGC	18_F18_RPZ28615
1CACTGT2ATTGGC	19_H20_RPZ28615
1TGACCA2ATTGGC	20_E4_RPZ28615
1CGTACG2ATTGGC	21_E10_RPZ28615
1CGTGAT2GATCTG	22_E11_RPZ28615
1ACATCG2GATCTG	23_D14_RPZ28615
1GCCTAA2GATCTG	24_F17_RPZ28615
1TGGTCA2GATCTG	25_E19_RPZ28615
1CACTGT2GATCTG	26_N19_RPZ28615
1TGACCA2GATCTG	27_B20_RPZ28615
1CGTACG2GATCTG	28_D20_RPZ28615"""
sample_list = samples.split('\n')


for sample in sample_list:
    sample_info= sample.split('\t')
    
    # folder name = barcode
    # data from barcode_blat_defuzz_counts.txt
    folder=sample_info[0]  
    LTR3=folder+"_blat_defuzz_counts.txt"
    LTR5=folder+"_blat_defuzz_counts.txt"
    find3LTR = "./Analysis/3LTR/" + folder +"/" +LTR3
    find5LTR = "./Analysis/5LTR/" + folder +"/" +LTR5
    
    # open both 3LTR and  5LTR data and write in data_all.
    with open(find3LTR, "r") as f:
        data_3LTR = f.read().rstrip()
        data_3LTR = data_3LTR.split("\n")

    with open(find5LTR, "r") as f:
        data_5LTR = f.read().rstrip().split("\n")

    data_all =[]    
    for item in data_3LTR:
        line=item.rstrip() + "\t3LTR"
        print(line)
        data_all.append(item.rstrip() + "\t3LTR") 
    for item in data_5LTR:
        data_all.append(item.rstrip() + "\t5LTR")
    print(len(data_all))
    
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
        f.write(sample_info[1] +'\n')  # sample name
        f.write(sample_info[0]+'\n')   # barcode
        for item in sorted_sites:        
            f.write("\t".join(item)+'\n')
            
            
            
            
            