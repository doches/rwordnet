module WordNet

class Synset
  attr_accessor :gloss, :synset_offset, :lex_filenum, :ss_type, :w_cnt, :words

  def initialize(pos, offset)
    data = File.open(File.join(WordNet.path,"dict","data.#{SynsetType[pos]}"),"r")
    data.seek(offset)
    data_line = data.readline.strip
    data.close
    
    info_line, @gloss = data_line.split(" | ")
    line = info_line.split(" ")
    
    @synset_offset = line.shift
    @lex_filenum = line.shift
    @ss_type = line.shift
    @w_cnt = line.shift.to_i
    @words = {}
    @w_cnt.times do
      @words[line.shift] = line.shift.to_i
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
  
  # List of valid +pointer_symbol+s is in pointers.rb
  def get_relation(pointer_symbol)
    @pointers.reject { |pointer| pointer.symbol != pointer_symbol }.map { |pointer| Synset.new(@ss_type, pointer.offset) }
  end
  
  def 
  
  def antonym
    get_relation(Antonym)
  end
  
  def hypernym
    get_relation(Hypernym)
  end
  
  def hyponym
    get_relation(Hyponym)
  end

  def to_s
    "(#{@ss_type}) #{@words.keys.map {|x| x.gsub('_',' ')}.join(', ')} (#{@gloss})"
  end
end

end
