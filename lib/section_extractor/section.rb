# frozen_string_literal: true

module SectionExtractor
  class Section
    attr_reader :title, :content, :positions, :raw_title

    def initialize(document_content, toc_item, next_toc_item)
      @toc_item = toc_item
      @next_toc_item = next_toc_item
      @document_content = document_content

      @raw_title = @toc_item.raw_title
      @title = @toc_item.title
      @positions = [
        @toc_item.position + @toc_item.raw_title.size + 1,
        @next_toc_item ? @next_toc_item.position - 1 : @document_content.size - 1
      ]
      @content = @document_content[@positions.first..@positions.last].strip
      @content = "" if @content.size < 5
    end

    def inspect
      "#<Section title: #{@raw_title}, content: #{@content.slice(0, 50)}>"
    end

    def full_content
      "#{title} #{content}"
    end
  end
end
