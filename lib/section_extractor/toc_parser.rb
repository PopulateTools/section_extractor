# frozen_string_literal: true

module SectionExtractor
  class TocParser
    MAX_TOC_ITEM_SIZE = 60

    attr_reader :content, :tocs

    def initialize(content)
      @content = content
      @tocs = {}
    end

    def call
      TocTypes.all.map do |type, options|
        content.scan(options[:regexp]).each do |match|
          toc_item_title = match.first.strip.gsub(/\n/, "").gsub(/\s+/, " ")
          toc_item_title = toc_item_title.split(":").first.strip if toc_item_title.include?(":")
          # Skip the TOC item if it has more than 5 dots
          # (this happens in the docs with a TOC)
          next if toc_item_title.include?(".....") || toc_item_title.include?("_____")

          toc_item_title = toc_item_title.slice(0, MAX_TOC_ITEM_SIZE) if toc_item_title.size > MAX_TOC_ITEM_SIZE
          separator_char = detect_separator_chars(toc_item_title, type)
          if separator_char.nil?
            puts " - Skipping #{toc_item_title} because separator_char is nil (type: #{type})" if ENV["DEBUG"]
            next
          end

          tocs[type] ||= {}
          tocs[type][separator_char] ||= Toc.new(type, separator_char)
          puts " - Adding TOC item: #{toc_item_title}" if ENV["DEBUG"]
          tocs[type][separator_char].add_item(
            toc_item_title, content.rindex(toc_item_title) || content.rindex(match.first)
          )
        end
      end

      tocs
    end

    private

    def detect_separator_chars(title, toc_series_type) # rubocop:disable Metrics/MethodLength
      case toc_series_type
      when :numeric
        detect_numeric_series_separator_chars(title)
      when :numeric_with_clause
        detect_numeric_with_clause_series_separator_chars(title)
      when :roman
        detect_roman_series_separator_chars(title)
      when :roman_with_title
        detect_roman_with_title_series_separator_chars(title)
      when :alpha
        detect_alpha_series_separator_chars(title)
      end
    end

    def detect_numeric_series_separator_chars(title)
      title.match(/(\d+(?:\.\d+)*(\.?-?)\s+[^\n]+)/) ? ::Regexp.last_match(2) : nil
    end

    def detect_numeric_with_clause_series_separator_chars(title)
      title.match(/(?:Cláusula\s+)(\d+(?:\.\d+)*\s*(\.?-?)\s+[^\n]+)/m) ? ::Regexp.last_match(2) : nil
    end

    def detect_roman_series_separator_chars(title)
      title.match(/((?:IX|IV|V?I{1,3}|VI{1,3}|X{1,3}V?I{0,3})\s?(\.?-?)\s+[^\n]+)/) ? ::Regexp.last_match(2) : nil
    end

    def detect_roman_with_title_series_separator_chars(title)
      title.match(/((?:ANEXO|CAPITULO|CAPÍTULO|TÍTULO|TITULO)\s+(?:IX|IV|V?I{1,3}|VI{1,3}|X{1,3}V?I{0,3})\s?(\.?-?)\s+[^\n]+)/) ? ::Regexp.last_match(2) : nil # rubocop:disable Layout/LineLength
    end

    def detect_alpha_series_separator_chars(title)
      title.match(/([a-zA-Z]([).-]+)\s+[^\n]+)/) ? ::Regexp.last_match(2) : nil
    end
  end
end
