##
# A Term within a Vocabulary
#
# Please see https://github.com/OregonDigital/ControlledVocabularyManager/blob/master/app/models/term.rb
class Term < ActiveTriples::Resource
  include ActiveTriplesAdapter
  include ActiveModel::Validations

  attr_accessor :commit_history

  configure :base_uri => "http://#{ENV['VOCAB_DOMAIN'] || 'authority.localhost.localdomain'}/ns/"
  configure :repository => :default
  configure :type => RDF::URI("http://www.w3.org/2004/02/skos/core#Concept")

  property :label, :predicate => RDF::RDFS.label
  property :alternate_name, :predicate => RDF::URI("http://schema.org/alternateName")
  property :date, :predicate => RDF::Vocab::DC.date
  property :comment, :predicate => RDF::RDFS.comment
  property :is_replaced_by, :predicate => RDF::Vocab::DC.isReplacedBy
  property :see_also, :predicate => RDF::RDFS.seeAlso
  property :is_defined_by, :predicate => RDF::RDFS.isDefinedBy
  property :same_as, :predicate => RDF::OWL.sameAs
  property :modified, :predicate => RDF::Vocab::DC.modified
  property :issued, :predicate => RDF::Vocab::DC.issued
  property :pref_label, :predicate => RDF::Vocab::SKOS.prefLabel
  property :alt_label, :predicate => RDF::Vocab::SKOS.altLabel
  property :hidden_label, :predicate => RDF::Vocab::SKOS.hiddenLabel

  # Remove
  property :title, :predicate => RDF::Vocab::DC.title

  validate :not_blank_node

  # Remove
  def children
    vocab_with_children
  end

  def absolute_path
    uri_segments = rdf_subject.to_s.split("/ns/")
    Rails.configuration.absolute_url + ['/vocabularies', uri_segments.last].join('/') + '.json'
  end
  def vocab_with_children
    injector = TermInjector.new
    vocab = TermWithChildren.new(self, injector.child_node_finder)
    vocab.children
  end
  ###

  def namespace
    "#{rdf_subject.scheme}://#{rdf_subject.host}/ns/"
  end

  def path
    rdf_subject.to_s.sub(/#{Regexp.escape(namespace)}/, '')
  end

  def term_uri
    TermUri.new(rdf_subject)
  end

  def to_h
    { :label => label, :alt_label => alt_label, :pref_label => pref_label, :hidden_label => hidden_label }
  end

  private
  def repository
    @repository ||= RDF::Blazegraph::Repository.new(ENV['TRIPLESTORE_URL'])
  end

  def not_blank_node
    errors.add(:id, "can not be blank") if node?
  end
end
