#!/usr/bin/env ruby
#== Synopsis
# dumps the longest translation and their Pfam motifs of a gene
#== Usage
# dump_ensembl_stats.rb -db DB_NAME
#
#== Author:
# Michael Han (mh6@sanger.ac.uk)
# Wellcome Trust Sanger Institute
# United Kingdom


require 'optparse'

require 'rubygems'
require 'rdoc/ri/ri_paths'
require 'rdoc/usage'
require 'ensembl' # Jan Aert's EnsEMBL API
include Ensembl::Core

database='worm_ensembl_remanei'

opt=OptionParser.new
opt.on("-d", "--database DATABASE",''){|d|database=d}
opt.parse(ARGV) rescue RDoc::usage('Usage')

# connect to db -- hardcoded to ia64d, can always be changed if needed
CoreDBConnection.establish_connection(:adapter=>'mysql',:host => 'ia64d',:database =>database,:username=>'wormro',:password => '')

# get all genes ...
Gene.find(:all).each{|g|
    $stderr.puts "processing gene #{g.stable_id}" if $DEBUG
    t=g.transcripts # get all transcripts for the gene g
    
    t.each{|transcript|
#      exon_count=transcript.exons.size
      t_size=transcript.stop-transcript.start+1
      puts "#{g.stable_id} #{t_size}" #{exon_count}"
      }
}
