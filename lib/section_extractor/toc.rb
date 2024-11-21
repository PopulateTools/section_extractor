# frozen_string_literal: true

module SectionExtractor
  class Toc
    attr_accessor :toc_series_type, :toc_separator_chars, :toc_items

    MAX_NUMERIC_TOC_ITEM = 1000

    def initialize(toc_series_type, toc_separator_chars)
      @toc_items = []
      # The type of toc series can be:
      #   - numeric: 1, 2, 3, ...
      #   - roman: I, II, III, ...
      #   - alpha: a), b), c), ...
      @toc_series_type = toc_series_type
      @toc_separator_chars = toc_separator_chars
    end

    def add_item(raw_title, position)
      toc_item = TocItem.new(raw_title, raw_title, position)
      @toc_items << toc_item if valid_toc_item?(toc_item)
    end

    private

    def valid_toc_item?(toc_item)
      case @toc_series_type
      when :numeric
        match = toc_item.raw_title.match(/^(\d+)/)
        match.size > 0 && match[1].to_i <= MAX_NUMERIC_TOC_ITEM
      end
    end
  end
end
