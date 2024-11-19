# frozen_string_literal: true

module SectionExtractor
  class Toc
    attr_accessor :toc_series_type, :toc_separator_chars, :toc_items

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
      @toc_items << TocItem.new(raw_title, raw_title, position)
    end
  end
end
