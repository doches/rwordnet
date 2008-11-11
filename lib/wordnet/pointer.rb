module WordNet

# Convenience class for treating hashes as objects, i.e. obj[:key] <=> obj.key. I know
# this is probably a bad idea, but it's so convenient...
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
