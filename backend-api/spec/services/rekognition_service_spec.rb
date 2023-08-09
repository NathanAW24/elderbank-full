require 'rails_helper'

RSpec.describe RekognitionService, type: :service do
  let(:correct_base64_image) { File.read(Rails.root.join("spec/controllers/correct.txt")) }
  let(:wrong_base64_image) { File.read(Rails.root.join("spec/controllers/wrong.txt")) }

  describe ".find_person_by_image" do
    xit "returns person name and confidence for a correct image" do
      name, confidence = RekognitionService.find_person_by_image("face-id-test", correct_base64_image, 90)
      expect(name).to eq("ABC123")
      expect(confidence).to be >90
    end

    xit "returns nil and nil for an incorrect image" do
      name, confidence = RekognitionService.find_person_by_image("face-id-test", wrong_base64_image, 90)
      expect(name).to be_nil
      expect(confidence).to be_nil
    end
  end
end
