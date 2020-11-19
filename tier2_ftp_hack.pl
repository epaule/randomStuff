#!/usr/bin/env perl
# copy report files to thr FTP site

use Getopt::Long;
use lib $ENV{CVS_DIR};
use Log_files;
use Wormbase;

my ($debug,$test,$testout,$WS_version);
GetOptions(
	'debug=s' => \$debug,
	'testout=s'  => \$testout,
	'test' => \$test,
	'release=s' => \$WS_version,
)||die(@!);


my $wormbase = Wormbase->new(-debug => $debug,-test => $test);
my $log = Log_files->make_build_log($wormbase);

$WS_version ||= $wormbase->get_wormbase_version;
my $WS_version_name = "WS${WS_version}";

my $targetdir = ($test) 
    ? "$testout/releases/$WS_version_name"
    : $wormbase->ftp_site . "/releases/.${WS_version_name}";

$log->write_to("WRITING TO $targetdir\n");

my %species = ($wormbase->species_accessors);
foreach my $wb (values %species) {
    next if $wb->species eq 'elegans';

    my $gspecies = $wb->full_name('-g_species'=>1);
    my $bioproj = $wb->ncbi_bioproject;

    my $in_prefix = $wb->reports;
    my $prefix = "$targetdir/species/$gspecies/$bioproj/annotation";
    my $out_prefix = "$prefix/$gspecies.${bioproj}.${WS_version_name}.";
    
    `mkdir -p $prefix` unless -e $prefix;
    
    my @files = ('functional_descriptions.txt','orthologs.txt','protein_domains.csv','geneIDs.txt','geneOtherIDs.txt','alaska_ids.tsv','uniprot_papers.txt','gene_product_info.gpi');

    foreach my $file (@files) {  
      my $in_file = $in_prefix . "/" . $wb->species .".$file";
      my $out_file = $out_prefix . $file . '.gz';
      
      if (-e $in_file) {
        $log->write_to("WARNING: $in_file is empty\n") unless -s $in_file;
        $wormbase->run_command("cat $in_file | gzip -n -9 -c >! $out_file", $log);
      } else {
        $log->write_to("WARNING: can't find $in_file\n");
      }
 
      $log->write_to("WARNING: $out_file is empty\n") unless -s $out_file;
    }
}
$log->mail;
