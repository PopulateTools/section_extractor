# frozen_string_literal: true

module SectionExtractor
  class TocItem
    attr_accessor :title
    attr_reader :position, :raw_title

    def initialize(raw_title, title, position)
      @raw_title = raw_title&.strip
      @title = title&.strip
      @position = position
    end

    def inspect
      "#<TocItem raw_title: #{@raw_title}>"
    end
  end
end
