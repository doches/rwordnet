module WordNet
  # Represents the WordNet database, and provides some basic interaction.
  class DB
    # By default, use the bundled WordNet
    @path = File.expand_path("../../../WordNet-3.0/", __FILE__)
    @files = {}

    class << self
      # To use your own WordNet installation (rather than the one bundled with rwordnet:
      # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
      attr_accessor :path

      # Look up a word in WordNet. Returns a list of lemmas occuring in any of the index files (noun, verb, adjective, adverb).
      def find(word)
        [NounIndex, VerbIndex, AdjectiveIndex, AdverbIndex].flat_map do |index|
          index.instance.find(word) || []
        end
      end

      # Register a new DB file handle. You shouldn't need to call this method; it's called automatically every time you open an index or data file.
      def open(path)
        @files[path] ||= File.open(path,"r")
      end

      # Closes all open file handles, call when you are done using WordNet and want to free them.
      def close
        @files.each_value do |handle|
          begin
            handle.close
          rescue IOError
            # Keep going, close the next file.
          end
        end
        @files = {}
      end
    end
  end
end
