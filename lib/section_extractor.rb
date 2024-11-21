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
require_relative "section_extractor/toc_types"
require_relative "section_extractor/version"
