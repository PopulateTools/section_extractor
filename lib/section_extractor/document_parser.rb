# frozen_string_literal: true

module SectionExtractor
  class DocumentParser
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def call
      Document.new.tap do |document|
        document.tocs = extract_tocs(content)
        document.sections = extract_sections(content, document.tocs)
      end
    end

    private

    def extract_sections(content, tocs)
      sections = []

      tocs.each do |toc|
        toc_items_to_skip = []

        0.upto(toc.toc_items.size - 1) do |index|
          section = Section.new(content, toc.toc_items[index], toc.toc_items[index + 1])
          sections << section
          # TODO: review
          # Skip empty sections, because they are not real sections, but just sentences that start with
          # toc item title format
          # if section.content.empty?
          #   toc_items_to_skip << index
          # else
          #   sections << section
          # end
        end

        puts "- Skipping #{toc_items_to_skip.join(", ")} empty sections" if toc_items_to_skip.any?
        toc_items_to_skip.each { |index| toc.toc_items.delete_at(index) }
      end
      sections
    end

    def extract_tocs(content)
      SectionExtractor::TocParser.new(content).call
    end
  end
end
