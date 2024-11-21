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

    def extract_sections(content, tocs) # rubocop:disable Metrics/AbcSize
      sections = []

      tocs.each do |toc|
        # toc_items_to_skip = []

        0.upto(toc.toc_items.size - 1) do |index|
          section = Section.new(
            document_content: content,
            toc_item: toc.toc_items[index],
            next_toc_item: toc.toc_items[index + 1],
            toc_series_type: toc.toc_series_type,
            toc_separator_chars: toc.toc_separator_chars
          )
          sections << section unless section_exists?(sections, section)
        end
      end

      remove_suspicious_sections(
        sections.sort_by { |s| s.positions.first }
      )
    end

    def extract_tocs(content)
      all_tocs = SectionExtractor::TocParser.new(content).call
      all_tocs.values.map(&:values).flatten
    end

    def section_exists?(sections, section)
      sections.find { |s| s.raw_title == section.raw_title && s.positions&.first == section.positions&.first }
    end

    def remove_suspicious_sections(sections)
      return sections if sections.size < 2

      find_suspicious_section_indexes(sections)
    end

    def find_suspicious_section_indexes(sections)
      sections.each_with_index.with_object([]) do |(section, index), _indexes|
        previous_section = sections[index - 1]
        next_section = sections[index + 1]

        next if previous_section.nil? || next_section.nil?

        if suspicious_section?(previous_section, section)
          puts " - Removing section: #{section.raw_title} - #{section.positions.first}" if ENV["DEBUG"]
          sections.delete_at(index)
        end
      end

      sections
    end

    def suspicious_section?(previous_section, section)
      (
        previous_section.toc_series_type != section.toc_series_type ||
        previous_section.toc_separator_chars != section.toc_separator_chars
      ) && section.toc_separator_chars == "" && section.toc_series_type == :numeric && !section.raw_title.include?(".")
    end
  end
end
