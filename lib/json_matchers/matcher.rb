require "json_schema"
require "json_matchers/parser"
require "json_matchers/validator"

module JsonMatchers
  class Matcher
    def initialize(schema_path)
      @schema_path = schema_path
      @document_store = JsonMatchers.document_store
    end

    def matches?(payload)
      self.errors = validator.validate(payload)

      errors.empty?
    end

    def validation_failure_message
      errors.first.to_s
    end

    private

    attr_accessor :errors
    attr_reader :document_store, :schema_path

    def validator
      Validator.new(schema_path: schema_path, document_store: document_store)
    end
  end
end
