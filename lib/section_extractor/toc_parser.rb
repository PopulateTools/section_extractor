# frozen_string_literal: true

module SectionExtractor
  class TocParser
    ROMAN_SERIES = %w[I II III IV V VI VII VIII IX X XI XII XIII XIV XV].freeze
    ALPHA_SERIES = ("a".."z").to_a

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def call
      tocs = []
      re1 = %r{\n(\d{1,3}[\.-][\.-]?\s+[^\n]+)\n}mi
      re2 = %r{\n(IX|IV|V|VI|I|II|III)([\.-]*\s+[^\n]+)\n}m
      re3 = %r{\n^([a-zA-Z][\)\.-]+\s+[^\n]+)\n}m

      [re1, re2, re3].map do |re|
        toc = Toc.new
        content.scan(re).map do |match|
          toc_item_title = match.join("").strip
          if toc_item_title.include?(":")
            toc_item_title = toc_item_title.split(":").first.strip
          end
          toc.add_item(toc_item_title, content.index(toc_item_title))
        end

        tocs << toc
      end

      analyze_and_close(tocs)
    end

    def analyze_and_close(tocs)
      tocs.map do |toc|
        toc.toc_series_type = detect_series_type(toc)
        toc_separator_chars = detect_separator_chars(toc)
        if toc_separator_chars.size > 1
          extract_tocs_with_different_separators(toc, toc_separator_chars)
        else
          toc.toc_separator_chars = toc_separator_chars.first
          toc
        end
      end.flatten.map do |toc|
        calculate_titles(toc)
        # TODO, for the moment is not necessary
        #cleanup_toc_items(toc)

        toc
      end
    end

    private

    def extract_tocs_with_different_separators(toc, toc_separator_chars)
      tocs = []
      toc_separator_chars.sort_by(&:size).reverse.each do |separator_char|
        new_toc = Toc.new
        new_toc.toc_separator_chars = separator_char
        new_toc.toc_series_type = toc.toc_series_type
        toc.toc_items.each do |item|
          new_toc.add_item(item.title, item.position) if item.title.include?(separator_char)
        end

        # Delete the items from the original TOC
        new_toc.toc_items.each do |new_item|
          toc.toc_items.delete_if { |item| item.title == new_item.title }
        end
        tocs << new_toc
      end
      tocs
    end

    def calculate_titles(toc)
      toc.toc_items.each do |item|
        item.title = item.raw_title.split(toc.toc_separator_chars).last.strip
        if item.title == item.raw_title
          toc.toc_items.delete(item)
        end
      end
    end

    def detect_series_type(toc)
      random_items = toc.toc_items.sample(5)
      types = random_items.map{ |item| detect_series_type_from_item(item) }
      # return the most common type
      types.max_by { |type| types.count(type) }
    end

    def cleanup_toc_items(toc)
      raise "series type not detected" unless toc.toc_series_type

      # toc_items are sorted,
      current_series_item = nil
      next_series_item_should_be = expected_next_series_item(current_series_item)
      new_toc_items = []

      puts " - Cleaning up TOC items"
      puts " - Toc separator chars: #{toc.toc_separator_chars}"

      toc.toc_items.each_with_index do |item, i|
        if item.title !~ /\A#{next_series_item_should_be}\s*#{Regexp.quote(toc_separator_chars)}/
          puts "- Skipping #{item.title}, should be #{next_series_item_should_be}#{toc_separator_chars}"
          next
        end

        new_toc_items << item
        current_series_item = next_series_item_should_be
        next_series_item_should_be = expected_next_series_item(current_series_item)
      end

      toc.toc_items = new_toc_items
    end

    def detect_series_type_from_item(item)
      case item.title
      when /\A\d+/
        :numeric
      when /\A\b(I|II|III|IV|V|VI|VII|VIII|IX|X|XI|XII|XIII|IVX|XV)+\b/
        :roman
      when /\A[a-zA-Z]+/
        :alpha
      end
    end

    def detect_separator_chars(toc)
      separators_chars = case toc.toc_series_type
                         when :numeric
                           toc.toc_items.map { |item| detect_numeric_series_separator_chars(item) }
                         when :roman
                           toc.toc_items.map { |item| detect_roman_series_separator_chars(item) }
                         when :alpha
                           toc.toc_items.map { |item| detect_alpha_series_separator_chars(item) }
                         else
                           raise "series type not detected"
                         end
      separators_chars.sort.uniq.compact
    end

    def detect_numeric_series_separator_chars(item)
      item.title.match(/\d{1,3}([^\s]+)\s/) ? $1 : nil
    end

    def detect_roman_series_separator_chars(item)
      item.title.match(/\b(IX|IV|V|VI|I|II|III)\b([^\s]+)\s/) ? $2 : nil
    end

    def detect_alpha_series_separator_chars(item)
      item.title.match(/([a-zA-Z])([^\s]+)\s/) ? $2 : nil
    end

    def expected_next_series_item(current_item)
      case @toc_series_type
      when :numeric
        (current_item || 0) + 1
      when :roman
        ROMAN_SERIES[(ROMAN_SERIES.index(current_item) || -1) + 1]
      when :alpha
        ALPHA_SERIES[(ALPHA_SERIES.index(current_item) || -1) + 1]
      end
    end
  end
end
