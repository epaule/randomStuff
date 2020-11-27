#!/usr/bin/env ruby
require 'bio'

seq_lengths=Array.new
total=0
seq_lengths2=Array.new
total2=0

Bio::FlatFile.auto(ARGF){|file|
 file.each do |entry|
   seq_lengths << entry.seq.length
   total+=entry.seq.length
   if entry.seq.length > 2000
      seq_lengths2 << entry.seq.length
      total2+=entry.seq.length
   end
 end
}

puts "total: #{total} (#{total2})"
counter=0
number=0
seq_lengths.sort.each{|l|
  counter+=l
#  puts "#{l} (running count #{counter} < #{total/2} "
  if counter > total/2
     print "n50: #{l} "
     break
  end
}
counter=0
seq_lengths2.sort.each{|l|
  counter+=l
  number+=1
#  puts "#{l} (running count #{counter} < #{total/2} "
  if counter > total2/2
     puts "(#{l}) - #{number} sequences"
     break
  end
}
#n90
counter=0
number=0
seq_lengths.sort.each{|l|
  counter+=l
#  puts "#{l} (running count #{counter} < #{total/2} "
  if counter > total*0.9
     print "n90: #{l} "
     break
  end
}
counter=0
seq_lengths2.sort.each{|l|
  counter+=l
  number+=1
#  puts "#{l} (running count #{counter} < #{total/2} "
  if counter > total2*0.9
     puts "(#{l}) - #{number} sequences"
     break
  end
}
