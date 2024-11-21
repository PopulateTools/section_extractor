# frozen_string_literal: true

module SectionExtractor
  class Section
    attr_reader :title, :content, :positions, :raw_title, :toc_series_type, :toc_separator_chars

    def initialize(document_content:, toc_item:, next_toc_item:, toc_series_type:, toc_separator_chars:)
      @toc_item = toc_item
      @next_toc_item = next_toc_item
      @document_content = document_content
      @toc_series_type = toc_series_type
      @toc_separator_chars = toc_separator_chars

      set_titles
      set_positions
      set_content
    end

    private

    def set_titles
      @raw_title = @toc_item.raw_title
      @title = @toc_item.title
    end

    def set_positions
      @positions = [
        @toc_item.position + @toc_item.raw_title.size + 1,
        end_position
      ]
    end

    def set_content
      content = @document_content[@positions.first..@positions.last].strip
      @content = content.size < 5 ? "" : content
    end

    def end_position
      @next_toc_item ? @next_toc_item.position - 1 : @document_content.size - 1
    end

    def inspect
      "#<Section title: \"#{@raw_title}\" - positions: #{@positions}> - type: #{@toc_series_type} - separator: #{@toc_separator_chars}"
    end

    def full_content
      "#{title} #{content}"
    end
  end
end
