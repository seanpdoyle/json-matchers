require "pathname"
require "json_matchers/version"
require "json_matchers/matcher"
require "json_matchers/errors"

module JsonMatchers
  class << self
    attr_accessor :schema_root, :document_store
  end

  def self.path_to_schema(schema_name)
    Pathname.new(schema_root).join("#{schema_name}.json")
  end

  def self.build_and_populate_document_store
    return if defined? @document_store

    @document_store = JsonSchema::DocumentStore.new

    Dir.glob("#{JsonMatchers.schema_root}/**{,/*/**}/*.json").
      map { |path| Pathname.new(path) }.
      map { |schema_path| Parser.new(schema_path).parse }.
      map { |schema| document_store.add_schema(schema) }.
      each { |schema| schema.expand_references!(store: document_store) }
  end
end
