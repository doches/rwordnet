# A container for various constants. In particular, contains constants representing the WordNet symbols used to look up synsets by relation, i.e. Hypernym/Hyponym.
# Use these symbols in conjunction with the Synset#get_relation method.

module WordNet

  NounPointers = {"-c"=>"Member of this domain - TOPIC", "+"=>"Derivationally related form", "%p"=>"Part meronym", "~i"=>"Instance Hyponym", "@"=>"Hypernym", ";r"=>"Domain of synset - REGION", "!"=>"Antonym", "#p"=>"Part holonym", "%s"=>"Substance meronym", ";u"=>"Domain of synset - USAGE", "-r"=>"Member of this domain - REGION", "#s"=>"Substance holonym", "="=>"Attribute", "-u"=>"Member of this domain - USAGE", ";c"=>"Domain of synset - TOPIC", "%m"=>"Member meronym", "~"=>"Hyponym", "@i"=>"Instance Hypernym", "#m"=>"Member holonym"}
  VerbPointers = {"+"=>"Derivationally related form", "@"=>"Hypernym", ";r"=>"Domain of synset - REGION", "!"=>"Antonym", ";u"=>"Domain of synset - USAGE", "$"=>"Verb Group", ";c"=>"Domain of synset - TOPIC", ">"=>"Cause", "~"=>"Hyponym", "*"=>"Entailment"}
  AdjectivePointers = {";r"=>"Domain of synset - REGION", "!"=>"Antonym", "\\"=>"Pertainym (pertains to noun)", "<"=>"Participle of verb", "&"=>"Similar to", "="=>"Attribute", ";c"=>"Domain of synset - TOPIC"}
  AdverbPointers = {";r"=>"Domain of synset - REGION", "!"=>"Antonym", ";u"=>"Domain of synset - USAGE", "\\"=>"Derived from adjective", ";c"=>"Domain of synset - TOPIC"}

  MemberOfThisDomainTopic = "-c"
  DerivationallyRelatedForm = "+"
  PartMeronym = "%p"
  InstanceHyponym = "~i"
  Hypernym = "@"
  DomainOfSynsetRegion = ";r"
  Antonym = "!"
  PartHolonym = "#p"
  SubstanceMeronym = "%s"
  VerbGroup = "$"
  DomainOfSynsetUsage = ";u"
  MemberOfThisDomainRegion = "-r"
  SubstanceHolonym = "#s"
  DerivedFromAdjective = "\\"
  ParticipleOfVerb = "<"
  SimilarTo = "&"
  Attribute = "="
  AlsoSee = "^"
  Cause = ">"
  MemberOfThisDomainUsage = "-u"
  DomainOfSynsetTopic = ";c"
  MemberMeronym = "%m"
  Hyponym = "~"
  InstanceHypernym = "@i"
  Entailment = "*"
  MemberHolonym = "#m"
end
