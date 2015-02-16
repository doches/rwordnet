module WordNet
  # Convenience class for treating hashes as objects, i.e. obj[:key] <=> obj.key
  class Pointer < Hash
    def method_missing(*args)
      fetch(args[0]) { super }
    end

    def respond_to?(*args)
      include?(args[0]) || super
    end
  end
end
