# TODO add validation for subject attributes. Ex: Health cannot go over 100 etc
# TODO: Clean up contexts and describes. Stop using the two interchangebly
describe Hero do
  subject { Hero.new }
  let(:full_hero) do
    Hero.new(
      health: 110,
      level: 1,
      attack: 50,
      defense: 50,
      money: 100,
      experience: 50,
      description: 'My custom hero'
    )
  end

  describe 'includes base mixin modules' do
    it 'includes Customize module' do
      extended_class = class Bar; include Customize; end
      expect(extended_class.included_modules).to include Customize
    end
    it 'includes Inventory module' do
      extended_class = class Bar; include Inventory; end
      expect(extended_class.included_modules).to include Inventory
    end
    it 'includes Equip module' do
      extended_class = class Bar; include Equip; end
      expect(extended_class.included_modules).to include Equip
    end
    it 'includes HeroHelper module' do
      extended_class = class Bar; include Formulas::HeroHelper; end
      expect(extended_class.included_modules).to include Formulas::HeroHelper
    end
  end

  describe '#initialize' do
    context 'when no arguments are passed in' do
      it 'has inherited default values' do
        expect(subject).to have_attributes(
          name: 'Nameless One',
          health: 100,
          level: 1,
          attack: 10,
          defense: 10,
          money: 0,
          experience: 0,
          description: '',
          main_class: 'Hero'
        )
      end
      it 'has default values' do
        expect(subject).to have_attributes(
          gender: 'genderless',
          inventory: { current_potions: [], current_armor: [], current_weapons: [] },
          skip_battle_scenes: false,
          dungeon_level: 1,
          current_dungeon: nil,
          dungeons_conquered: [],
          hints: 0,
          keys: [],
          treasures_found: [],
          base_class: :soldier # default base class is soldier
        )
      end
    end

    context 'when arguments are passed in' do
      it 'calls super and initializes with passed in values' do
        expect(full_hero).to have_attributes(
          name: 'Nameless One',
          health: 110,
          level: 1,
          attack: 50,
          defense: 50,
          money: 100,
          experience: 50,
          description: 'My custom hero',
          main_class: 'Hero'
        )
      end
    end
  end

end
