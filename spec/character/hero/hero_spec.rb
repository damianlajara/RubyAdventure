# require "pry"
# # TODO add validation for subject attributes. Ex: Health cannot go over 100 etc

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

  describe "includes base modules" do
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

  describe "#initialize" do
    context "when no arguments are passed in" do
      it "has inherited default values" do
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
      it "has default values" do
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

    context "when arguments are passed in" do
      it "calls super and initializes with passed in values" do
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

  describe "customization" do
    context "#customize" do
      it "is defined" do
        expect(subject).to respond_to(:customize)
      end
      it 'calls #customize_name' do
        expect(subject).to receive(:gets).and_return('')
        expect(subject).to receive(:customize_name).once
        subject.customize
      end
      it 'calls #customize_gender' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('')
        expect(subject).to receive(:customize_gender).once
        subject.customize
      end
      it 'displays welcome message' do
        expect(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.customize }.to output(/welcome/).to_stdout
      end
    end

    context "#customize_name" do
      it "is defined" do
        expect(subject).to respond_to(:customize_name)
      end
      context "when invoked" do
        it 'displays message asking to choose name' do
          expect(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.customize_name }.to output(/what would you like your character to be called/i).to_stdout
        end
      end
      context "when invalid option is entered" do
        it 'reverts to default name' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('')
          subject.customize_name
          expect(subject.name).to eq('Nameless One')

          expect(subject).to receive(:gets).exactly(1).times.and_return('123')
          subject.customize_name
          expect(subject.name).to eq('Nameless One')

          expect(subject).to receive(:gets).exactly(1).times.and_return('asd123')
          subject.customize_name
          expect(subject.name).to eq('Nameless One')

          expect(subject).to receive(:gets).exactly(1).times.and_return('\n')
          subject.customize_name
          expect(subject.name).to eq('Nameless One')

          expect(subject).to receive(:gets).exactly(1).times.and_return('_!@#')
          subject.customize_name
          expect(subject.name).to eq('Nameless One')
        end
      end

      context "when valid option is entered" do
        it "updates name" do
          expect(subject).to receive(:gets).exactly(1).times.and_return('Damian')
          subject.customize_name
          expect(subject.name).to eq('Damian')
        end
      end
    end

    context "#customize_gender" do
      it "is defined" do
        expect(subject).to respond_to(:customize_gender)
      end

      context "when invoked" do
        it 'displays message asking to choose gender' do
          expect(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.customize }.to output(/what is your gender/i).to_stdout
        end
      end

      context "when 1 (male gender) is selected" do
        it 'returns Male' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('1')
          subject.customize_gender
          expect(subject.gender).to eq('Male')
        end
      end

      context "when 2 (female gender) is selected" do
        it 'returns Female' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('2')
          subject.customize_gender
          expect(subject.gender).to eq('Female')
        end
      end

      context "when 3 (custom gender) is selected" do
        it 'returns custom gender' do
          expect(subject).to receive(:gets).exactly(2).times.and_return('3', 'Genderfluid')
          subject.customize_gender
          expect(subject.gender).to eq('Genderfluid')
        end
      end

      context "when invalid custom gender is entered" do
        it 'defaults to Other' do
          expect(subject).to receive(:gets).exactly(2).times.and_return('3', '')
          subject.customize_gender
          expect(subject.gender).to eq('Other')

          expect(subject).to receive(:gets).exactly(2).times.and_return('3', '123')
          subject.customize_gender
          expect(subject.gender).to eq('Other')

          expect(subject).to receive(:gets).exactly(2).times.and_return('3', '@#$!')
          subject.customize_gender
          expect(subject.gender).to eq('Other')

          expect(subject).to receive(:gets).exactly(2).times.and_return('3', '   \n invalid ')
          subject.customize_gender
          expect(subject.gender).to eq('Other')

          expect(subject).to receive(:gets).exactly(2).times.and_return('3', '   whitespace  doesn\'t matter   ')
          subject.customize_gender
          expect(subject.gender).to eq('Other')
        end
      end

      context "when invalid option is entered" do
        it 'defaults to Genderless' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('')
          subject.customize_gender
          expect(subject.gender).to eq('Genderless')

          expect(subject).to receive(:gets).exactly(1).times.and_return('\n another one   !')
          subject.customize_gender
          expect(subject.gender).to eq('Genderless')

          expect(subject).to receive(:gets).exactly(1).times.and_return('@#$%!')
          subject.customize_gender
          expect(subject.gender).to eq('Genderless')

          expect(subject).to receive(:gets).exactly(1).times.and_return('123')
          subject.customize_gender
          expect(subject.gender).to eq('Genderless')

          expect(subject).to receive(:gets).exactly(1).times.and_return('4')
          subject.customize_gender
          expect(subject.gender).to eq('Genderless')
        end
      end
    end

    context "#reset_stats_after_death" do
      it "is defined" do
        expect(subject).to respond_to(:reset_stats_after_death)
      end
      context "when hero dies" do
        it "resets to default attributes" do
          full_hero.reset_stats_after_death
          expect(full_hero).to have_attributes(
            health: 110,
            max_hp: 110,
            money: 0,
            experience: 0,
            inventory: {
              current_potions: [],
              current_armor: [],
              current_weapons: []
            },
            equipped_weapons: [],
            equipped_armor: []
          )
        end
        it "resets health to max_hp" do
          full_hero.max_hp = 150
          full_hero.reset_stats_after_death
          expect(full_hero).to have_attributes(
            health: 150,
          )
        end
        it "still retains base attributes" do
          full_hero.reset_stats_after_death
          expect(full_hero).to have_attributes(
            health: 110,
            max_hp: 110,
            attack: 50,
            defense: 50,
            description: 'My custom hero'
          )
        end
      end
    end

    context "#change_name" do
      it 'is defined' do
        expect(subject).to respond_to(:change_name)
      end

      context "when invoked" do
        before(:example) do
          allow(subject).to receive(:puts).with(a_string_matching(/Are you sure you want to change your name?/i)).ordered
          allow(subject).to receive(:puts).with(a_string_matching(/yes/i)).ordered
          allow(subject).to receive(:puts).with(a_string_matching(/no/i)).ordered
        end

        it 'displays confirmation message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/Are you sure you want to change your name?/i))
          subject.change_name
        end
      end

      context "when 1 (yes) is selected" do
        it 'calls #customize_name' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect(subject).to receive(:customize_name).once
          subject.change_name
        end
        it 'displays success message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/congratulations/i))
          subject.change_name
        end
      end
      context "when 2 (no) or invalid option is selected" do
        it 'displays error message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('2')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/awww man/i))
          subject.change_name

          allow(subject).to receive(:gets).at_least(:once).and_return('90')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/awww man/i))
          subject.change_name

          allow(subject).to receive(:gets).at_least(:once).and_return('')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/awww man/i))
          subject.change_name

          allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/awww man/i))
          subject.change_name
        end
      end
    end

    context "#change_gender" do
      it 'is defined' do
        expect(subject).to respond_to(:change_gender)
      end

      context "when invoked" do
        before(:example) do
          allow(subject).to receive(:puts).with(a_string_matching(/Are you sure you want to change your gender?/i)).ordered
          allow(subject).to receive(:puts).with(a_string_matching(/yes/i)).ordered
          allow(subject).to receive(:puts).with(a_string_matching(/no/i)).ordered
        end

        it 'displays confirmation message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/Are you sure you want to change your gender?/i))
          subject.change_gender
        end
      end

      context "when 1 (yes) is selected" do
        it 'calls #customize_gender' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect(subject).to receive(:customize_gender).once
          subject.change_gender
        end
        it 'displays success message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/congratulations/i))
          subject.change_gender
        end
      end
      context "when 2 (no) or invalid option is selected" do
        it 'displays error message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('2')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/hmmm/i))
          subject.change_gender

          allow(subject).to receive(:gets).at_least(:once).and_return('90')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/hmmm/i))
          subject.change_gender

          allow(subject).to receive(:gets).at_least(:once).and_return('')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/hmmm/i))
          subject.change_gender

          allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:puts).with(a_string_matching(/hmmm/i))
          subject.change_gender
        end
      end
    end

    context "#toggle_battle_scenes" do
      it 'is defined' do
        expect(subject).to respond_to(:toggle_battle_scenes)
      end

      context 'when 1 (yes) is selected' do
        it 'displays confirmation message' do
          toggle = !subject.skip_battle_scenes ? 'disable' : 'enable'
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:gets).and_return('1')
          expect(subject).to receive(:puts).with(a_string_matching(/Battle scenes have been #{toggle}d./i))
          subject.toggle_battle_scenes
        end

        context 'when invoked for the first time' do
          it 'skips battle scenes' do
            expect(subject).to receive(:gets).and_return('1')
            subject.toggle_battle_scenes
            expect(subject.skip_battle_scenes).to eq(true)
          end
        end

        context 'when invoked multiple times' do
          it 'remembers previous state and toggles battle scenes' do
            allow(subject).to receive(:gets).and_return('1')
            subject.toggle_battle_scenes
            expect(subject).to receive(:gets).and_return('1')
            subject.toggle_battle_scenes
            expect(subject.skip_battle_scenes).to eq(false)
          end
        end
      end

      context 'when 2 (no) is selected' do
        it 'displays confirmation message' do
          toggle = subject.skip_battle_scenes ? 'disable' : 'enable'
          allow(subject).to receive(:puts).with(a_kind_of(String))
          expect(subject).to receive(:gets).and_return('2')
          expect(subject).to receive(:puts).with(a_string_matching(/Battle scenes will stay #{toggle}d./i))
          subject.toggle_battle_scenes
        end

        context "when invoked for the first time" do
          it 'stays with default value' do
            expect(subject).to receive(:gets).and_return('2')
            subject.toggle_battle_scenes
            expect(subject.skip_battle_scenes).to eq(false)
          end
        end

        context "when invoked multiple times" do
          it 'reverts to previous state' do
            allow(subject).to receive(:gets).and_return('1')
            subject.toggle_battle_scenes
            expect(subject).to receive(:gets).and_return('2')
            subject.toggle_battle_scenes
            expect(subject.skip_battle_scenes).to eq(true)
          end
        end
      end
    end

    context "#game_options" do
      xit
    end

  end
end
