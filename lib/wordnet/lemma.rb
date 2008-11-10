module WordNet

class Lemma
  attr_accessor :lemma, :pos, :synset_cnt, :p_cnt, :ptr_symbol, :tagsense_cnt, :synset_offset
  
  # Create a lemma from a line in an index file
  def initialize(index_line)
    line = index_line.split(" ")
    
    @lemma = line.shift
    @pos = line.shift
    @synset_cnt = line.shift.to_i
    @p_cnt = line.shift.to_i
    
    @ptr_symbol = []
    @p_cnt.times { @ptr_symbol.push line.shift }
    line.shift # Throw away redundant sense_cnt
    @tagsense_cnt = line.shift.to_i
    @synset_offset = []
    @synset_cnt.times { @synset_offset.push line.shift.to_i }
  end
  
  def get_synsets
    return @synset_offset.map { |offset| Synset.new(@pos, offset) }
  end
  
  def to_s
    [@lemma, @pos].join(",")
  end
  
  alias synsets get_synsets
end

end
