module WordNet

# Represents a synset (or group of synonymous words) in WordNet. Synsets are related to each other by various (and numerous!)
# relationships, including Hypernym (x is a hypernym of y <=> x is a parent of y) and Hyponym (x is a child of y)
class Synset
  attr_reader :gloss, :synset_offset, :lex_filenum, :ss_type, :w_cnt, :wordcounts

  # Create a new synset by reading from the data file specified by +pos+, at +offset+ bytes into the file. This is how
  # the WordNet database is organized. You shouldn't be creating Synsets directly; instead, use Lemma#synsets.
  def initialize(pos, offset)
    data = File.open(File.join(WordNetDB.path,"dict","data.#{SynsetType[pos]}"),"r")
    data.seek(offset)
    data_line = data.readline.strip
    data.close
    
    info_line, @gloss = data_line.split(" | ")
    line = info_line.split(" ")
    
    @synset_offset = line.shift
    @lex_filenum = line.shift
    @ss_type = line.shift
    @w_cnt = line.shift.to_i
    @wordcounts = {}
    @w_cnt.times do
      @wordcounts[line.shift] = line.shift.to_i
    end
    
    @p_cnt = line.shift.to_i
    @pointers = []
    @p_cnt.times do
      pointer = Pointer.new
      pointer[:symbol] = line.shift,
      pointer[:offset] = line.shift.to_i
      pointer[:pos] = line.shift
      pointer[:source] = line.shift
      pointer[:is_semantic?] = (pointer[:source] == "0000")
      pointer[:target] = pointer[:source][2..3]
      pointer[:source] = pointer[:source][0..1]
      pointer[:symbol] = pointer[:symbol][0]
      @pointers.push pointer
    end
  end
  
  # How many words does this Synset include?
  def size
    @wordcounts.size
  end
  
  # Get a list of words included in this Synset
  def words
    @wordcounts.keys
  end
  
  # List of valid +pointer_symbol+s is in pointers.rb
  def get_relation(pointer_symbol)
    @pointers.reject { |pointer| pointer.symbol != pointer_symbol }.map { |pointer| Synset.new(@ss_type, pointer.offset) }
  end
  
  # Get the Synset of this sense's antonym
  def antonym
    get_relation(Antonym)
  end
  
  # Get the parent synset (higher-level category, i.e. fruit -> reproductive_structure).
  def hypernym
    get_relation(Hypernym)[0]
  end
  
  # Get the child synset(s) (i.e., lower-level categories, i.e. fruit -> edible_fruit)
  def hyponym
    get_relation(Hyponym)
  end
  
  # Get the entire hypernym tree (from this synset all the way up to +entity+) as an array.
  def expanded_hypernym
    parent = self.hypernym
    return [] if parent.nil?
    
    return [parent, parent.expanded_hypernym].flatten
  end
  
  def to_s
    "(#{@ss_type}) #{words.map {|x| x.gsub('_',' ')}.join(', ')} (#{@gloss})"
  end
  
  alias parent hypernym
  alias children hyponym
end

end
