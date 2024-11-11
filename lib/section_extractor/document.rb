# frozen_string_literal: true

module SectionExtractor
  class Document
    attr_reader :id
    attr_accessor :sections, :tocs

    def initialize(file_path)
      @id = File.basename(file_path, ".*")
      @sections = []
      @tocs = []
    end
  end
end
