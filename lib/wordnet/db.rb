module WordNet
  # Represents the WordNet database, and provides some basic interaction.
  class DB
    # By default, use the bundled WordNet
    @path = File.expand_path("../../../WordNet-3.0/", __FILE__)

    class << self
      # To use your own WordNet installation (rather than the one bundled with rwordnet:
      # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
      attr_accessor :path

      def open(path, &block)
        File.open(File.join(self.path, path), "r", &block)
      end
    end
  end
end
