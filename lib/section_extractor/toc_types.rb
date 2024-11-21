# frozen_string_literal: true

module SectionExtractor
  class TocTypes
    RE_NUMERIC = /\n(\d+(?:\.\d+)*\.?-?\s+[^\n]+)\n/m
    RE_NUMERIC_WITH_CLAUSE = /\n((?:Cláusula\s+)(\d+(?:\.\d+)*\.?-?\s+[^\n]+))\n/m
    RE_ROMAN = /\n((?:IX|IV|V?I{1,3}|VI{1,3}|X{1,3}V?I{0,3})\s?\.?-?\s+[^\n]+)\n/mi
    RE_ROMAN_WITH_TITLE = /\n((?:ANEXO|CAPITULO|CAPÍTULO|TÍTULO|TITULO)\s+(?:IX|IV|V?I{1,3}|VI{1,3}|X{1,3}V?I{0,3})[.-]*\s+[^\n]+)\n/mi
    RE_ALPHA = /\n([a-zA-Z][).-]+\s+[^\n]+)\n/m

    def self.all
      {
        numeric: {
          regexp: RE_NUMERIC,
          first_value: 1
        },
        numeric_with_clause: {
          regexp: RE_NUMERIC_WITH_CLAUSE,
          first_value: 1
        },
        roman: {
          regexp: RE_ROMAN,
          first_value: "I"
        },
        roman_with_title: {
          regexp: RE_ROMAN_WITH_TITLE,
          first_value: "I"
        },
        alpha: {
          regexp: RE_ALPHA,
          first_value: "a"
        }
      }
    end
  end
end
