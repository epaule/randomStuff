#!/usr/bin/env perl
# the Anderson File is from WS195
# list of IDs to redo: /nfs/wormpub/DATABASES/geneace/WGS/ANDERSEN/mapping_errors.txt

use strict;
use Getopt::Long;

my ($toVersion,$varIDs);
my $idMappingFile='/nfs/wormpub/DATABASES/geneace/WGS/ANDERSEN/ids.txt';
my $originalGFF  ='/nfs/wormpub/DATABASES/geneace/WGS/ANDERSEN/andersen_data.ws195_collapsed';

GetOptions(
    'toVersion=s'    => \$toVersion,
    'varIDs=s'       => \$varIDs,
)||die(@!);

# a get Anderson# mappings to WBVarIDs
my %var2anderson;
open INF, $idMappingFile;
while (<INF>){
    chomp;
    my ($wbvar,$andersonID)=split;
    $var2anderson{$wbvar}=$andersonID;
}
close INF;

# get varIDs from file
my @ids;
open INF, $varIDs;
while (<INF>){
    if (/(WBVar\d+)/){
        push(@ids,$var2anderson{$1});
    }
}
close INF;

# create a tmp GFF2 file
foreach my $i (@ids){
  system("grep $i $originalGFF >> /tmp/andersonsubset.195.gff")&&die(@!);   
}

system("perl $ENV{CVS_DIR}/remap_gff_between_releases.pl -species elegans -gff /tmp/andersonsubset.195.gff -release1 195 -release2 $toVersion -output /tmp/andersonsubset.${toVersion}.gff")&&die(@!);
system("perl $ENV{CVS_DIR}/get_flanking_sequences_simple.pl -flank 50 < /tmp/andersonsubset.${toVersion}.gff > /tmp/anderson_out.txt")&&die(@!);
