#!/usr/bin/perl

open IN, "<PEread_LTR_nonInternal_linker_long_q20_F10bp_sortedExpanded_cluster_w_seq.txt" or die;
open OUT, ">major_clones_with_microsatellites.txt" or die;

@newlines = ();
while ($line=<IN>) {
    chomp ($line);
    @eles = split(/\t/, $line);
    $seq = $eles[-1];

    $threshold = 5;
    for($i=5;$i<=20;$i++) {
        $pattern = "." x $i;
        while ($seq =~ /($pattern)\1{$threshold,}/g) {
            $line2pattern{$line} = $i;
            unless ($seen{$line}++) {
                push (@newlines, $line);
            }
        }
    }
}

foreach $newline (@newlines) {
    print OUT "$newline\t$line2pattern{$newline}\n";
}

close IN, OUT;
