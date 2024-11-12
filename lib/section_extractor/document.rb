# frozen_string_literal: true

module SectionExtractor
  class Document
    attr_accessor :sections, :tocs

    def initialize
      @sections = []
      @tocs = []
    end
  end
end
