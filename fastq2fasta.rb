#!/usr/bin/env ruby
# converts fastq to plain old fasta

require 'bio'

class Fastq
	attr_reader :id,:sequence

	def initialize(id,sequence)
		@id=id
		@sequence=sequence
	end

	def self.each(infile)
		id=0
		sequence=''
		infile.each_line{|line|
			if (/^\@(\S+)/.match(line))
				yield Fastq.new(id,sequence) unless id == 0
				id="#{$1}"
			elsif (/^([ACGTN]+)$/.match(line))
				sequence="#{$1}"
			end
		}
		yield Fastq.new(id,sequence)
	end
end

cutoff=ARGV.pop.to_i
histogram=Hash.new
Fastq.each(File.new(ARGV.shift)){|e|
	seq=Bio::Sequence::NA.new(e.sequence)
	puts seq.to_fasta(e.id,60) unless e.sequence.size < cutoff
	type=( e.sequence.size <= cutoff) ? 'smaller':'bigger'
	$stderr.puts("#{e.sequence.size} is #{type} than #{cutoff}")
	histogram[(e.sequence.size/1000).to_i]||=0
	histogram[(e.sequence.size/1000).to_i]+=1
}
histogram.keys.sort{|a,b|a<=> b}.each{|k|
	$stderr.puts "#{k*1000}-#{(k+1)*1000} => #{histogram[k]}"
}
