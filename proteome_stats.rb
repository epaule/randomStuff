#!/usr/bin/env ruby
require 'bio'


def mean(array)
	  array.inject(0) { |sum, x| sum += x } / array.size.to_f
	  #s= array.inject(0){|sum,x| sum +x}
	  #return s/array.size.to_f
end

def median(array, already_sorted=false)
	  return nil if array.empty?
	  array = array.sort unless already_sorted
	  m_pos = array.size / 2
	  return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
end

seq_lengths=Array.new

Bio::FlatFile.auto(ARGF){|file|
 file.each do |entry|
   seq_lengths << entry.seq.length
 end
}

puts "minimum protein length: #{seq_lengths.sort[0]} aa"
puts "maximum protein length: #{seq_lengths.sort[-1]} aa"
puts "median protein length: #{median(seq_lengths)} aa"
puts "mean protein length: #{mean(seq_lengths)} aa"
