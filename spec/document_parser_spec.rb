# frozen_string_literal: true

require "pry"

RSpec.describe SectionExtractor::DocumentParser do
  let(:document) { SectionExtractor::DocumentParser.new(File.read(file_path)).call }

  context "in 33637100 doc" do
    let(:file_path) { "spec/files/33637100.txt" }

    it "has these sections" do
      [
        ["12.- Criterios de adjudicación i ponderación", "Los criterios de adjudicación son los que figuran"],
        ["c) CPV", "44230000-1 Trabajos de carpintería para la"],
        ["I.-  Régimen Jurídico del Contrato.", "La Entidad contratante es la empresa pública EMAYA"]
      ].each do |expected_section|
        expect(document.sections.any? do |section|
          section.raw_title.include?(expected_section[0]) &&
            section.content.include?(expected_section[1])
        end).to be true
      end
    end
  end
end
