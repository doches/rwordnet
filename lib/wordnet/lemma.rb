module WordNet

# Represents a single word in the WordNet lexicon, which can be used to look up a set of synsets.
class Lemma
  attr_accessor :lemma, :pos, :synset_cnt, :p_cnt, :ptr_symbol, :tagsense_cnt, :synset_offset, :id

  # Create a lemma from a line in an index file. You should be creating Lemmas by hand; instead,
  # use the WordNet#find and Index#find methods to find the Lemma for a word.
  def initialize(index_line, id = 0)
    @id = (id > 0) ? id : nil
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
  
  # Return a list of synsets for this Lemma. Each synset represents a different sense, or meaning, of the word.
  def get_synsets
    return @synset_offset.map { |offset| Synset.new(@pos, offset) }
  end
  
  def to_s
    [@lemma, @pos].join(",")
  end
  
  alias synsets get_synsets
  alias word lemma
end

end
