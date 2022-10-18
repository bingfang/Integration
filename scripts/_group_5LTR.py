#!/usr/local/bin/python3.6

import glob
import re
from operator import itemgetter

def main():
    for name in glob.glob("./Analysis/5LTR/*_5LTR_12.txt"):
        inputfile = str(name)
        outputfile = str(name)[:-4]+"_grep.txt"
        with open(inputfile,'r') as f:
            data_in = f.read().rstrip().split('\n') # Read file and create list split by newline 
        print(inputfile)
        print("total reads: ",len(data_in))
        internal_seq, internal_seq_num, genome_seq, genome_seq_num, unknown_seq, unknown_seq_num,no_LTR_nestPrimer,short_seq_num = search_seq(data_in)

        print("5LTR reads: ", len(data_in) - no_LTR_nestPrimer)
        print("internal  sequence: ",internal_seq_num)
        print("short_seq_num: ", short_seq_num)

        print("genome: ",genome_seq_num)
        print("unknown: ",unknown_seq_num)

        with open(outputfile,'w') as f:
            for lst in [internal_seq[0:9],genome_seq[0:9],unknown_seq[0:100]]:
                for line in lst:
                    f.write(str(line)+'\n')
## internal: GTCCCC 
## linker:GTCCCTTAAGCGGAGCCC
## expected genome sequences: "TAAAACTGTATCTGAT"  
## chr_seq = "TAAAACTGTATCTGAT"
#chr_seq = "TATCACACFFF"  # chr3:122556943 clone10
#chr_seq = "GAGAAGTADD"  # chr3:108820933 clone 19
chr_seq = "TAACTTTAG"  # chr2:112383784-strain clone12
def search_seq(data_in):
    internal_seq=[]
    internal_seq_num=0
    genome_seq=[]
    genome_seq_num=0

    unknown_seq=[]
    unknown_seq_num=0
    no_LTR_nestPrimer=0
    short_seq_num=0
    for line in data_in:
        field=line.split('\t')
        if "AGATCTTGTCTTCGTTGGGAGTGAGCTAGCCCTTCCA" in field[2] and len(field[2])<50: # nest primer 
            if "GTCCCC" in field[3]:  #internal
                ID=">internal" + field[0]
                internal_seq.append(ID)
                internal_seq.append(field[3])
                internal_seq_num += 1
            else:
                if "GTCCCTTAAGCGGAGCCC" in field[3]:  #linker
                    seq_lst=field[3].split("GTCCCTTAAGCGGAGCCC")
                    if len(seq_lst[0])>20:
                        seq=seq_lst[0]
                        if chr_seq in seq:   # special genome seq
                            ID=">genome" + field[0]
                            genome_seq.append(ID)
                            genome_seq.append(seq)
                            genome_seq_num += 1
                        else:
                            ID=">unknown" + field[0]
                            unknown_seq.append(ID)
                            unknown_seq.append(seq)
                            unknown_seq_num += 1
                    else:
                        short_seq_num += 1
                else:
                    seq=field[3]
                    if chr_seq in seq:   # special genome seq
                        ID=">genome" + field[0]
                        genome_seq.append(ID)
                        genome_seq.append(seq)
                        genome_seq_num += 1
                    else:
                        ID=">unknown" + field[0] 
                        unknown_seq.append(ID)
                        unknown_seq.append(seq)
                        unknown_seq_num += 1


        else:
            no_LTR_nestPrimer += 1
                    
    return internal_seq, internal_seq_num, genome_seq, genome_seq_num, unknown_seq, unknown_seq_num,no_LTR_nestPrimer,short_seq_num

main()


