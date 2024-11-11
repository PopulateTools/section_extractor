# frozen_string_literal: true

module SectionExtractor
  class Error < StandardError; end
end

require_relative "section_extractor/document_parser"
require_relative "section_extractor/document"
require_relative "section_extractor/section"
require_relative "section_extractor/toc_item"
require_relative "section_extractor/toc_parser"
require_relative "section_extractor/toc"
require_relative "section_extractor/version"


# Usage:
#      #
#      # document = SectionExtractor::DocumentParser.new("path/to/file").call
#      # document.sections.each do |section|
#      #   puts section.title
#      #   puts section.content
#      # end
