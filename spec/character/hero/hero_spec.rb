require "pry"
describe Hero do
  subject { Hero.new }
  let(:basic_stats) { %w(health level attack defense money exp)}
  let(:full_attributes) do
    {
      health: 310,
      level: 6,
      attack: 250,
      defense: 400,
      money: 1_000,
      experience: 1500
    }
  end
  let(:fake_attributes) { { awesomeness: 100, coolness: 110, everything_else: 99 } }
  let(:fake_hero) { Hero.new full_attributes.merge(fake_attributes) }
  let(:full_hero) { Hero.new(full_attributes) }

  describe "#initialize" do
    context "when no arguments passed in" do
      it "has default values" do
        expect(subject).to have_attributes(
          # Character defaults
          name: 'Nameless One',
          gender: 'genderless',
          health: 100,
          level: 1,
          attack: 10,
          defense: 10,
          money: 0,
          experience: 0,
          equipped_weapons: [],
          equipped_armor: [],
          weapon_count: 0,
          armor_count: 0,
          potion_count: 0,
          skip_battle_scenes: false,
          # Hero defaults
          max_hp: 100,
          dungeon_level: 1,
          inventory: {
            current_potions: [],
            current_armor: [],
            current_weapons: []
          }
        )
      end
    end

    context "when arguments passed in" do
      it "ignores invalid passed in options" do
        fake_attributes.each do |fake_attribute, value|
            expect(fake_hero.instance_variables).not_to include fake_attribute
        end
      end

      it "has passed in values" do
        expect(full_hero).to have_attributes(
          # Character defaults + passed in values
          name: 'Nameless One',
          gender: 'genderless',
          health: 310,
          level: 6,
          attack: 250,
          defense: 400,
          money: 1_000,
          experience: 1500,
          equipped_weapons: [],
          equipped_armor: [],
          weapon_count: 0,
          armor_count: 0,
          potion_count: 0,
          skip_battle_scenes: false,
          # Hero defaults
          max_hp: 100,
          dungeon_level: 1,
          inventory: {
            current_potions: [],
            current_armor: [],
            current_weapons: []
          }
        )
      end
    end
  end
end
