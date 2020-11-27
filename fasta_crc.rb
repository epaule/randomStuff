#!/usr/bin/env ruby
require 'rubygems'
require 'digest/md5'
require 'bio'

file = Bio::FastaFormat.open(ARGV.shift)
file.each do |entry|
  name = entry.entry_id
  digest = Digest::MD5.hexdigest(entry.seq.upcase)
  puts "#{name} #{entry.seq.length} #{digest}"
end
