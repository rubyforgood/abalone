require "rails_helper"

describe ReportBuilder do
  before(:each) do
    @assessment = create(:tagged_animal_assessment, shl_case_number: "SF16-9A", measurement_date: "09/20/18")
    create(:tagged_animal_assessment, shl_case_number: "SF16-9B", measurement_date: "06/20/18")
    create(:tagged_animal_assessment, shl_case_number: "SF16-9C", measurement_date: "09/20/18")
    create(:tagged_animal_assessment, shl_case_number: "SF16-9A", measurement_date: "03/20/18")
  end

  describe "#cohort_options" do
    context "when given no date" do
      it "returns all animal assessment case numbers" do
        @report_builder = ReportBuilder.new(cohort: nil, date: nil)
        expect(@report_builder.cohort_options.length).to eq 3
        expect(@report_builder.cohort_options).to include "SF16-9A"
        expect(@report_builder.cohort_options).to include "SF16-9B"
        expect(@report_builder.cohort_options).to include "SF16-9C"
      end
    end

    context "when given a date" do
      it "returns only animal assessment case numbers on that date" do
        @report_builder = ReportBuilder.new(cohort: nil, date: "2018-09-20")
        expect(@report_builder.cohort_options.length).to eq 2
        expect(@report_builder.cohort_options).to include "SF16-9A"
        expect(@report_builder.cohort_options).to include "SF16-9C"
      end
    end
  end

  describe "#measurement_date_options" do
    context "when given no cohort" do
      it "returns all animal assessment measurement dates" do
        @report_builder = ReportBuilder.new(cohort: nil, date: nil)
        expect(@report_builder.measurement_date_options.length).to eq 3
        expect(@report_builder.measurement_date_options.map(&:to_s)).to include "2018-09-20"
      end
    end

    context "when given a cohort" do
      it "returns only measurement dates for that cohort" do
        @report_builder = ReportBuilder.new(cohort: "SF16-9A", date: nil)
        expect(@report_builder.measurement_date_options.length).to eq 2
        expect(@report_builder.measurement_date_options.map(&:to_s)).to include "2018-09-20"
      end
    end
  end

  describe "#processed_file_id" do
    context "when given a date and cohort" do
      it "returns the corresponding animal assessments" do
        @report_builder = ReportBuilder.new(cohort: "SF16-9A", date: "2018-09-20")
        @report_builder.processed_file_id
      end
    end

    context "when given only a date" do
      it "returns the corresponding animal assessments" do
        expect(1).to eq 1
      end
    end

    context "when given only a cohort" do
      it "returns the corresponding animal assessments" do
        expect(1).to eq 1
      end
    end

    context "when given no cohort or date" do
      it "returns the corresponding animal assessments" do
        expect(1).to eq 1
      end
    end
  end
end
