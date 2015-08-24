#! /usr/bin/env perl
use strict;
use warnings;

# 1. Take the algorithm and split it into chunks. A chunk constitues as .xxx.xxx.xxx where xxx can be any number.
# 2. Add each chunk together. If we have ..77.74.49 the value is 200
# 3. Get the max value the password can be. Since the smallest possible ascii value can be zero we need to find the smallest value in all the chunks
#    i.e. (chunk 1 = 200, chunk 2 = 324, chunk 3 = 198) Chunk 3 is the smallest value and if we were to subtract its value from itself we get zero
#    and since we cannot go below zero the max password value can only be 198.
# 4. Go through all the possibilites (zero to max password value) and subtract the current password value.
# 5. Check each character if the character is not a valid character (i.e. letters, digits, puncations, etc.) get a count.
#    Notice: all characters a user would use are between 32 and 127 with the addition of 10 which is new line and 13 which is a carriage return
# 6. If the count is low enough (I’m thinking 5) display the text as a possible solution.
# 7. convert the ascii code to a letter and print the results.

print("Usage: decoder <encripted file>\n"), exit(0) unless $ARGV[0];

my $encripted;
while (<>) {
	chomp;
	$encripted .= $_;
}

my $transformed = $encripted;
$transformed =~ s{(\d+)\.(\d+)\.(\d+)}{$1+$2+$3}ge;
$transformed =~ s{^\.}{};

my @chunks = split /\./, $transformed;

my @sorted_chunks = sort { $a <=> $b } @chunks;
my $max_value = $sorted_chunks[0];

for ( my $i = 0; $i <= $max_value; $i++ ) {
	my @tmp = map {$_ - $i} @chunks;
	
	my $counter = 0;
	map { $counter++ if ( ($_ < 32 || $_ > 127) && $_ != 10 && $_ != 13 ) } @tmp;
	
	if ($counter <= 5) {
		my $decripted = join '', map { chr $_ } @tmp;
		print "$decripted\n";
	}
}
