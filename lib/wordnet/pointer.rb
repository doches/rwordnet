module WordNet

class Pointer < Hash
  def method_missing(msg, *args)
    if self.include?(msg)
      return self[msg] 
    else
      throw NoMethodError.new("undefined method `#{msg}' for #{self}:Pointer")
    end
  end
end

end
