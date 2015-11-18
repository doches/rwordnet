module WordNet
  # Represents the WordNet database, and provides some basic interaction.
  class DB
    # By default, use the bundled WordNet
    @path = File.expand_path("../../../WordNet-3.0/", __FILE__)

    class << self; attr_accessor :cached end
    @raw_wordnet = {}


    class << self
      # To use your own WordNet installation (rather than the one bundled with rwordnet:
      # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
      attr_accessor :path

      # Open a wordnet database. You shouldn't have to call this directly; it's
      # handled by the autocaching implemented in lemma.rb.
      #
      # `path` should be a string containing the absolute path to the root of a
      # WordNet installation.
      def open(path, &block)
        File.open(File.join(self.path, path), "r", &block)
      end
    end
  end
end
