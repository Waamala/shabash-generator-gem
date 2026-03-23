require "spec_helper"
require "mero_ideas/generator"

RSpec.describe MeroIdeas::Generator do
  let(:generator) { described_class.new }

  describe "#generate" do
    it "returns specified number of ideas" do
      ideas = generator.generate(count: 3)
      expect(ideas.size).to eq(3)
    end

    it "returns array of hashes with required keys" do
      idea = generator.generate(count: 1).first
      expect(idea.keys).to include(:format, :theme, :activity, :audience, :location, :title, :description, :tags)
    end

    it "respects format filter" do
      ideas = generator.generate(count: 1, filter: { format: ["Конференция"] })
      expect(ideas.first[:format]).to eq("Конференция")
    end

    it "respects multiple filters" do
      ideas = generator.generate(
        count: 1,
        filter: {
          format: ["Воркшоп"],
          theme: ["Инновации и технологии"]
        }
      )
      idea = ideas.first
      expect(idea[:format]).to eq("Воркшоп")
      expect(idea[:theme]).to eq("Инновации и технологии")
    end
  end

  describe "#generate_by_type" do
    it "generates business type ideas" do
      ideas = generator.generate_by_type("business", 1)
      expect(["конференция", "воркшоп", "хакатон"]).to include(ideas.first[:format].downcase)
    end

    it "generates team building ideas" do
      ideas = generator.generate_by_type("team_building", 1)
      expect(["тимбилдинг", "спортивное соревнование", "ролевая игра"]).to include(ideas.first[:activity].downcase)
    end

    it "falls back to default for unknown type" do
      expect {
        generator.generate_by_type("unknown", 1)
      }.not_to raise_error
    end
  end
end