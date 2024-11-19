# frozen_string_literal: true

require "pry"

RSpec.describe SectionExtractor::DocumentParser do
  let(:document) { SectionExtractor::DocumentParser.new(File.read(file_path)).call }

  def assert_sections_present(expected_sections)
    expected_sections.each do |title, content|
      expect(document.sections.any? do |section|
        section.raw_title.include?(title) #&& section.content.include?(content)
      end).to be(true), -> { "Expected section '#{title}' OR #{content} to be present" }
    end
  end

  def assert_sections_absent(unexpected_sections)
    unexpected_sections.each do |title, content|
      expect(document.sections.none? do |section|
        section.raw_title.include?(title) #&& section.content.include?(content)
      end).to be(true), -> { "Expected section '#{title}' OR #{content} to NOT be present" }
    end
  end

  context "in 33637100 doc" do
    let(:file_path) { "spec/files/33637100.txt" }

    it "has expected sections present and absent" do
      assert_sections_present([
        ["12.- Criterios de adjudicación i ponderación", "Los criterios de adjudicación son los que figuran"],
        ["c) CPV", "44230000-1 Trabajos de carpintería para la"],
        ["I.- Régimen Jurídico del Contrato.", "La Entidad contratante es la empresa pública EMAYA"],
        ["I. CARACTERÍSTICAS DEL CONTRATO", "a) Objeto:"]
      ])
    end
  end

  context "in 4106433 doc" do
    let(:file_path) { "spec/files/4106433.txt" }

    it "has these sections" do
      assert_sections_present([
        ["C. CONTRATO RESERVADO", "NO"],
        ["2.1.1. Objeto y necesidades del contrato", "El objeto del contrato al que se refiere el presente pliego"],
        ["2.2.4. Contenido de las proposiciones", "Los licitadores deberán estar inscritos"],
        ["ANEXO II PRESUPUESTO BASE DE LICITACIÓN", "Artículo 100.2 LCSP"]
      ])
    end
  end

  context "in 48098075 doc" do
    let(:file_path) { "spec/files/48098075.txt" }

    it "has these sections" do
      assert_sections_present([
        ["1.4. No división en lotes del objeto del contrato", "-El objeto del contrato no se divide en lotes"],
        ["3. Solvencia del empresario", "La solvencia económica y financiera del"],
        ["2. PROCEDIMIENTO DE SELECCIÓN Y ADJUDICACIÓN", "-La forma de adjudicación del contrato será el procedimiento abierto ordinario"],
      ])
    end
  end

  context "in 58142076 doc" do
    let(:file_path) { "spec/files/58142076.txt" }

    it "has these sections" do
      assert_sections_present([
        ["19.1 GARANTÍA DEFINITIVA", "20.747,79 euros."],
        ["17. CRITERIOS DE VALORACIÓN DE LAS OFERTAS",
         "Justificación: se ha seleccionado como criterio de adjudicación"],
        ["14. CONDICIONES ESPECIALES DE EJECUCIÓN",
         "Condiciones especiales de ejecución del contrato de carácter medioambiental."]
      ])
    end
  end

  context "in 65926671 doc" do
    let(:file_path) { "spec/files/65926671.txt" }

    it "has these sections" do
      assert_sections_present([
        ["ANEXO II CONDICIONES ESPECIALES DE EJECUCIÓN.", "acuerdo con el artículo 202.1 LCSP"],
        ["3. Derechos y obligaciones de las partes.", ""]
      ])
    end
  end

  context "in 79682161 doc" do
    let(:file_path) { "spec/files/79682161.txt" }

    it "has these sections" do
      assert_sections_present([
        ["1. Garantía Provisional", "No se exige conforme a lo establecido"],
        ["K. CONDICIONES ESPECIALES DE EJECUCIÓN DEL CONTRATO", "De acuerdo con el art. 202.1"]
      ])
    end
  end

  context "in 66067446 doc" do
    let(:file_path) { "spec/files/66067446.txt" }

    it "has these sections" do
      assert_sections_present([
        ["1. OBJETO DEL CONTRATO", "El presente procedimiento tiene por objeto"],
        ["7.1. PRESUPUESTO BASE DE LICITACIÓN Y PRECIO DEL CONTRATO", "El presupuesto base de licitación se indica en el punto 6.1 de la Carátula."]
      ])
    end
  end

  context "in 61678210 doc" do
    let(:file_path) { "spec/files/61678210.txt" }

    it "has these sections" do
      assert_sections_present([
        ["1. OBJETO", "El presente procedimiento tiene por objeto"],
        ["7. PRESUPUESTO BASE DE LICITACIÓN, VALOR ESTIMADO DEL CONTRA", "El presupuesto base de licitación se indica en el punto 6.1 de la Carátula."]
      ])
    end
  end

  context "in 66067386 doc" do
    let(:file_path) { "spec/files/66067386.txt" }

    it "has these sections" do
      assert_sections_present([
        ["I.- CARACTERÍSTICAS DE LA PRESTACIÓN", ""],
        ["1.1.- Definición", ""],
        ["3.1.- El presupuesto base", ""],
        ["5.2.- Modalidad de pago del precio", ""]
      ])
    end
  end
end
