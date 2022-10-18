#!/usr/bin/perl

##blat results filter

#find tags that match to single, or repeat, defined as >5 matches with scores <10 from the best

@libs=qw(PEread_LTR_nonInternal_linker_long_UniquePair_F
PEread_LTR_nonInternal_linker_long_UniquePair_R);

foreach $lib (@libs) {
	filter2($lib);
}


sub filter2 {
	
	$libname = "$_[0]"."_blat.txt";
	$file2open="$libname\_filter1";
		
	print "opening  $file2open\n";
	
	$filename_outRepeat=$file2open;
	$filename_outRepeat =~s/filter1/filter2_repeatMatch/;
	$filename_outBest=$file2open;
	$filename_outBest =~s/filter1/filter2_bestMatch/;
	
	print "creating $filename_outBest\n";
	print "creating $filename_outRepeat\n";
	
	
	open IN, "$file2open" or die;
	open OUTREPEAT, ">$filename_outRepeat" or die;
	open OUTBEST, ">$filename_outBest" or die;

	$line = <IN>;
	chomp($line);
	@eles = split(/\t/, $line);
	$TagID =$eles[9];
	$score = $eles[0];
	$count=1; #used to count how many close matches that are <10
	$tagcount=1; #used to count how many matches regardless of matchscore


	while ($newline = <IN>) {
		chomp($newline);
		@elesnew = split(/\t/, $newline);
		$newTagID =$elesnew[9];
		$newscore=$eles[0];
		
		if($newTagID ne $TagID) { #when sees a new ID, output old
			if($count>4) { #print out the best match to repeatresult, more than 4 matches <10 away)
				print OUTREPEAT "$count\t$line\n";
			}
			elsif($count==1) {  #single best match
				print OUTBEST "$tagcount\t$line\n";
			}
			#reset all variables
			$line = $newline;
			$TagID=$newTagID;
			$count=1;
			$tagcount=1;
			$score=$newscore;
		}
		else{#if same tagID, count
			$tagcount++;
			if($score-$newscore<10) 
				{$count++;}
		}
	}
	
	close IN;
	close OUT;
}
