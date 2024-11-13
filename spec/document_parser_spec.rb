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
        ["I.- Régimen Jurídico del Contrato.", "La Entidad contratante es la empresa pública EMAYA"],
        ["I. CARACTERÍSTICAS DEL CONTRATO", "a) Objeto:"]
      ].each do |expected_section|
        expect(document.sections.any? do |section|
          section.raw_title.include?(expected_section[0]) &&
            section.content.include?(expected_section[1])
        end).to be(true), lambda { "Expected section '#{expected_section[0]}' OR #{expected_section[1]} to be present" }
      end
    end
  end

  context "in 4106433 doc" do
    let(:file_path) { "spec/files/4106433.txt" }

    it "has these sections" do
      [
        ["C. CONTRATO RESERVADO", "NO"],
        ["2.1.1. Objeto y necesidades del contrato", "El objeto del contrato al que se refiere el presente pliego"],
        ["2.2.4. Contenido de las proposiciones", "Los licitadores deberán estar inscritos"],
        ["ANEXO II PRESUPUESTO BASE DE LICITACIÓN", "Artículo 100.2 LCSP"]
      ].each do |expected_section|
        expect(document.sections.any? do |section|
          section.raw_title.include?(expected_section[0]) &&
            section.content.include?(expected_section[1])
        end).to be(true), lambda { "Expected section '#{expected_section[0]}' OR #{expected_section[1]} to be present" }
      end
    end
  end

  context "in 48098075 doc" do
    let(:file_path) { "spec/files/48098075.txt" }

    it "has these sections" do
      [
        ["2. PROCEDIMIENTO DE SELECCIÓN Y ADJUDICACIÓN", "-La forma de adjudicación del contrato será el procedimiento abierto ordinario"],
        ["1.4. No división en lotes del objeto del contrato", "-El objeto del contrato no se divide en lotes"],
        ["3. Solvencia del empresario", "La solvencia económica y financiera del"]
      ].each do |expected_section|
        expect(document.sections.any? do |section|
          section.raw_title.include?(expected_section[0]) &&
            section.content.include?(expected_section[1])
        end).to be(true), lambda { "Expected section '#{expected_section[0]}' OR #{expected_section[1]} to be present" }
      end
    end
  end
end
