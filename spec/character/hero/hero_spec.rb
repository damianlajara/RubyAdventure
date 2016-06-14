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

      it "merges valid passed in values" do
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

  describe "#add_to_inventory" do
    let(:weapon) { Weapon.new("Sword", { damage: 10 }, price: 150, sell_value: 100) }
    let(:armor) { Armor.new("Shield", { defense: 20 }, price: 200, sell_value: 150) }
    let(:potion) { Potion.new("Elixir", { health: 30 }, price: 250, sell_value: 200) }

    it "is defined" do
      expect(subject).to respond_to(:add_to_inventory)
    end

    it "accepts an item as parameter" do
      expect(subject).to respond_to(:add_to_inventory).with(1).argument
    end

    it "is of type Item" do
      allow(subject).to receive(:add_to_inventory).with(weapon) do |weapon|
        expect(weapon.class.to_s).to match /Weapon|Armor|Potion/i
      end
      subject.add_to_inventory(weapon)
    end

    context "when passed in item is of type Weapon" do
      it "is of type Weapon" do

      end
      xit "adds item to inventory of current weapons" do

      end
      xit "increases the weapon count by 1" do

      end

      xit "returns true for successful" do

      end
    end

    context "when passed in item is of type Armor" do
      xit "adds item to inventory of current armor" do

      end
      xit "increases the armor count by 1" do

      end

      xit "returns true for successful" do

      end
    end

    context "when passed in item is of type Potion" do
      xit "adds item to inventory of current potions" do

      end
      xit "increases the potion count by 1" do

      end

      xit "returns true for successful" do

      end
    end

    context "when item passed in is invalid" do
      xit "does not add item to inventory" do

      end
      xit "returns false" do

      end
    end
  end


end
