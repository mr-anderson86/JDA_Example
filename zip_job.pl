#!/usr/bin/perl

use strict;
use warnings;

my @arr = ("a", "b", "c", "d");
foreach my $elem (@arr) {
	my $filename = "${elem}.txt";
	my $zipfile = "${elem}_$ENV{VERSION}.zip";
	print "[INFO] Creating file $filename \n";
	open my $fileHandle, ">>", "$filename" or die "Can't open '$filename'\n";
	close $fileHandle;
	die "[ERROR] File '$filename' wasn't created.\n" unless -f $filename;
	print "[INFO] Creating zip file $zipfile with $filename in it \n";
	`zip $zipfile $filename` or die "Can't create file '$zipfile'\n";
	die "[ERROR] Zip file '$zipfile' wasn't created.\n" unless -f $zipfile;
}
