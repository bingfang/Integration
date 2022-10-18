#!/usr/local/bin/python3.6

import glob
import re
from operator import itemgetter

def main():
    for name in glob.glob("./Analysis/3LTR/*_3LTR_12.txt"):
        inputfile = str(name)
        outputfile = str(name)[:-4]+"_grep.txt"
        with open(inputfile,'r') as f:
            data_in = f.read().rstrip().split('\n') # Read file and create list split by newline 
        print(inputfile)
        print("total reads: ",len(data_in))
        internal_seq, internal_seq_num, genome_seq, genome_seq_num, unknown_seq, unknown_seq_num,no_LTR_nestPrimer,short_seq_num = search_seq(data_in)
        
        print("3LTR reads: ", len(data_in) - no_LTR_nestPrimer)
        print("internal  sequence: ",internal_seq_num)
        print("short_seq_num: ", short_seq_num)
        print("genome: ",genome_seq_num)
        print("unknown: ",unknown_seq_num)


        with open(outputfile,'w') as f:
            for lst in [internal_seq[0:20],genome_seq[0:10],unknown_seq[0:60]]:
                for line in lst:
                    f.write(str(line)+'\n')
                    

## U5 internal: GTGGCGCCCG  U3 internal: GTCCCC 
## linker:GTCCCTTAAGCGGAGCCC

#chr_seq = "TCATTCTGCAT"  # chr11:120979445
#chr_seq1 = "GCGGAGGT"     # chr9:66835297

#chr_seq = "CCTGCCAATCC"  # chr5:37420984 -strain
chr_seq2 = "TCCCACCCDD"  # chr5:37420989 -strain
chr_seq1 = "TAACTTTAADD"     # chr3:122556948 +strain

chr_seq = "GTTAGATGGDD"  # chr2:154799239 + strain
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
        if "CCCTTTTAGTCAGTGTGGAAAATCTCTCTAGCA" in field[2] and len(field[2]) <50: # 3LTR nest primer 
            if "GGCGCC" in field[3]:  #internal
                ID=">internal" + field[0]
                internal_seq.append(ID)
                internal_seq.append(field[3])
                internal_seq_num += 1
            else:
                if "GTCCCTTAAGCGGAGCCC" in field[3]:  #linker
                    seq_lst=field[3].split("GTCCCTTAAGCGGAGCCC")
                    if len(seq_lst[0])>20:
                        seq=seq_lst[0]
                        if chr_seq in seq or chr_seq1 in seq or chr_seq2 in seq:   # special genome seq
                            ID=">genome" + field[0]
                            genome_seq.append(ID)
                            genome_seq.append(seq)
                            genome_seq_num += 1
                        else:
                            ID=">unknown" + field[0] + field[4]
                            unknown_seq.append(ID)
                            unknown_seq.append(seq)
                            unknown_seq_num += 1
                    else:
                        short_seq_num += 1
                else:
                    seq=field[3]
                    if chr_seq in seq or chr_seq1 in seq or chr_seq2 in seq:   # special genome seq
                        ID=">genome" + field[0]
                        genome_seq.append(ID)
                        genome_seq.append(seq)
                        genome_seq_num += 1
                    else:
                        ID=">unknown" + field[0] + field[4]
                        unknown_seq.append(ID)
                        unknown_seq.append(seq)
                        unknown_seq_num += 1


        else:
            no_LTR_nestPrimer += 1
                    
    return internal_seq, internal_seq_num, genome_seq, genome_seq_num, unknown_seq, unknown_seq_num,no_LTR_nestPrimer,short_seq_num

main()


