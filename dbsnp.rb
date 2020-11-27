#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'

doc = open(ARGV.shift) { |f| Hpricot.XML(f) }

(doc/"Rs").each{|r|
   chromosome=r.at('Component').attributes['chromosome']
   puts "Variation : XYZ"
   puts "Other_name rs#{r.attributes['rsId']}"

   fSnp=r.at('Ss')
   flank5=(fSnp/"Seq5").inner_html
   flank3=(fSnp/"Seq3").inner_html
   mutation=(fSnp/"Observed").inner_html
   (from,to)=mutation.split('/')
           
   puts "Flanking_sequence #{chromosome} #{flank5} #{flank3}"
   puts "Substitution #{from} #{to}"

   r.search('Ss').each{|ss|
           puts "Other_name ss#{ss.attributes['ssId']}"

   }
   puts ""
}
