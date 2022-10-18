#!/usr/local/bin/python3.6


import re
#Remove sites with reads less than 10.

def main():
    with open("Combined_allsites.xls", "r") as f:
        data_in=f.read().split('\n')
    col=int(input("Enter the sample number: "))
    filtered_line=[]
    filtered_line.append(data_in[0]) #append the the header line
    filtered_line=remove_line(data_in,filtered_line,col)
    filtered=remove_low_count(filtered_line,col)
    with open("Combined_allsites_filtered.xls", "w") as f:
        for i in filtered:
            f.write(i+'\n')

#filter the line with only low counts    
def remove_line(data_in,filtered_line,col):   
    for line in data_in[1:]:
        field= line.split('\t')
        for count in field[3:(col+3)]:
            if count !="":
                if int(count) > 10 :
                    filtered_line.append(line)
                    break
    return filtered_line

#replace the left low count with "".                    
def remove_low_count(filtered_line,col):
    filtered=[]
    filtered.append(filtered_line[0]) #append the the header line
    for line in filtered_line[1:]:
        field= line.split('\t')
        newline = field[0]+'\t'+field[1]+'\t'+field[2]+'\t'
        for j in field[3:(col+3)]:
            if j!="" and int(j) <= 10:
                newline +=' \t'
            else:
                newline +=j+'\t'
        note = '\t'.join(field[(col+3):])      
        newline = newline + note
        filtered.append(newline)
    return filtered
    
main()    
'''
        note = '\t'.join(field[(col+3):])
        newline = str(newline) + str(note) 
        " ".join(str(item) for item in my_list)
        '''