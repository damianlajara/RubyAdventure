# TODO add validation for subject attributes. Ex: Health cannot go over 100 etc

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

  describe 'customization' do
    context '#customize' do
      it 'is defined' do
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

    context '#customize_name' do
      it 'is defined' do
        expect(subject).to respond_to(:customize_name)
      end
      context 'when invoked' do
        it 'displays message asking to choose name' do
          expect(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.customize_name }.to output(/what would you like your character to be called/i).to_stdout
        end
      end
      context 'when invalid option is entered' do
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

      context 'when valid option is entered' do
        it 'updates name' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('Damian')
          subject.customize_name
          expect(subject.name).to eq('Damian')
        end
      end
    end

    context '#customize_gender' do
      it 'is defined' do
        expect(subject).to respond_to(:customize_gender)
      end

      context 'when invoked' do
        it 'displays message asking to choose gender' do
          expect(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.customize }.to output(/what is your gender/i).to_stdout
        end
      end

      context 'when 1 (male gender) is selected' do
        it 'returns Male' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('1')
          subject.customize_gender
          expect(subject.gender).to eq('Male')
        end
      end

      context 'when 2 (female gender) is selected' do
        it 'returns Female' do
          expect(subject).to receive(:gets).exactly(1).times.and_return('2')
          subject.customize_gender
          expect(subject.gender).to eq('Female')
        end
      end

      context 'when 3 (custom gender) is selected' do
        it 'returns custom gender' do
          expect(subject).to receive(:gets).exactly(2).times.and_return('3', 'Genderfluid')
          subject.customize_gender
          expect(subject.gender).to eq('Genderfluid')
        end
      end

      context 'when invalid custom gender is entered' do
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

      context 'when invalid option is entered' do
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

    context '#reset_stats_after_death' do
      it 'is defined' do
        expect(subject).to respond_to(:reset_stats_after_death)
      end

      context 'when hero dies' do
        it 'resets to default attributes' do
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
        it 'resets health to max_hp' do
          full_hero.max_hp = 150
          full_hero.reset_stats_after_death
          expect(full_hero).to have_attributes(
            health: 150
          )
        end
        it 'still retains base attributes' do
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

    context '#change_name' do
      it 'is defined' do
        expect(subject).to respond_to(:change_name)
      end

      context 'when invoked' do
        it 'displays confirmation message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.change_name }.to output(/Are you sure you want to change your name?/i).to_stdout
          expect { subject.change_name }.to output(/1\) yes/i).to_stdout
          expect { subject.change_name }.to output(/2\) no/i).to_stdout
        end
      end

      context 'when 1 (yes) is selected' do
        it 'calls #customize_name' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect(subject).to receive(:customize_name).once
          subject.change_name
        end
        it 'displays success message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect { subject.change_name }.to output(/congratulations/i).to_stdout
        end
      end
      context 'when 2 (no) or invalid option is selected' do
        let(:awww_man) { /awww man/i }
        it 'displays error message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('2')
          expect { subject.change_name }.to output(awww_man).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('90')
          expect { subject.change_name }.to output(awww_man).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.change_name }.to output(awww_man).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
          expect { subject.change_name }.to output(awww_man).to_stdout
        end
      end
    end

    context '#change_gender' do
      it 'is defined' do
        expect(subject).to respond_to(:change_gender)
      end

      context 'when invoked' do
        it 'displays confirmation message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.change_gender }.to output(/Are you sure you want to change your gender?/i).to_stdout
          expect { subject.change_gender }.to output(/1\) yes/i).to_stdout
          expect { subject.change_gender }.to output(/2\) no/i).to_stdout
        end
      end

      context 'when 1 (yes) is selected' do
        it 'calls #customize_gender' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect(subject).to receive(:customize_gender).once
          subject.change_gender
        end
        it 'displays success message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('1')
          expect { subject.change_gender }.to output(/congratulations/i).to_stdout
        end
      end

      context 'when 2 (no) or invalid option is selected' do
        let(:hmmm) { /hmmm/i }
        it 'displays error message' do
          allow(subject).to receive(:gets).at_least(:once).and_return('2')
          expect { subject.change_gender }.to output(hmmm).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('90')
          expect { subject.change_gender }.to output(hmmm).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('')
          expect { subject.change_gender }.to output(hmmm).to_stdout

          allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
          expect { subject.change_gender }.to output(hmmm).to_stdout
        end
      end
    end

    context '#toggle_battle_scenes' do
      let(:toggle) { !subject.skip_battle_scenes ? 'disable' : 'enable' }
      let(:untoggled) { subject.skip_battle_scenes ? 'disable' : 'enable' }

      it 'is defined' do
        expect(subject).to respond_to(:toggle_battle_scenes)
      end

      it 'displays confirmation message' do
        allow(subject).to receive(:gets).and_return('')
        expect { subject.toggle_battle_scenes }.to output(/Do you want to #{toggle} all of the battle scenes?/i).to_stdout
      end

      context 'when 1 (yes) is selected' do
        it 'displays confirmation message' do
          expect(subject).to receive(:gets).and_return('1')
          expect { subject.toggle_battle_scenes }.to output(/Battle scenes have been #{toggle}d./i).to_stdout
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
          expect(subject).to receive(:gets).and_return('2')
          expect { subject.toggle_battle_scenes }.to output(/Battle scenes will stay #{untoggled}d./i).to_stdout
        end

        context 'when invoked for the first time' do
          it 'stays with default value' do
            expect(subject).to receive(:gets).and_return('2')
            subject.toggle_battle_scenes
            expect(subject.skip_battle_scenes).to eq(false)
          end
        end

        context 'when invoked multiple times' do
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

    context '#game_options' do
      it 'is defined' do
        expect(subject).to respond_to(:game_options)
      end
      it 'displays header message' do
        allow(subject).to receive(:gets).and_return('')
        expect { subject.game_options }.to output(/game options/i).to_stdout
      end
      it 'displays game options' do
        allow(subject).to receive(:gets).and_return('')
        expect { subject.game_options }.to output(/1\) change name/i).to_stdout
        expect { subject.game_options }.to output(/2\) change gender/i).to_stdout
        expect { subject.game_options }.to output(/3\) toggle battle scenes/i).to_stdout
      end

      context 'when 1 (change name) is selected' do
        it 'calls change_name' do
          allow(subject).to receive(:gets).and_return('1')
          expect(subject).to receive(:change_name).once
          subject.game_options
        end
      end

      context 'when 2 (change gender) is selected' do
        it 'calls change_gender' do
          allow(subject).to receive(:gets).and_return('2')
          expect(subject).to receive(:change_gender).once
          subject.game_options
        end
      end

      context 'when 3 (toggle battle scenes) is selected' do
        it 'calls toggle_battle_scenes' do
          allow(subject).to receive(:gets).and_return('3')
          expect(subject).to receive(:toggle_battle_scenes).once
          subject.game_options
        end
      end

      context 'when invalid option is entered' do
        let(:invalid) { /invalid option/i }
        let(:exiting) { /exiting/i }

        it 'displays error message' do
          allow(subject).to receive(:gets).and_return('')
          expect { subject.game_options }.to output(invalid).to_stdout

          allow(subject).to receive(:gets).and_return('123')
          expect { subject.game_options }.to output(invalid).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.game_options }.to output(invalid).to_stdout

          allow(subject).to receive(:gets).and_return('something')
          expect { subject.game_options }.to output(invalid).to_stdout

          allow(subject).to receive(:gets).and_return('invalid options')
          expect { subject.game_options }.to output(invalid).to_stdout
        end
        it 'displays exiting menu message' do
          allow(subject).to receive(:gets).and_return('')
          expect { subject.game_options }.to output(exiting).to_stdout

          allow(subject).to receive(:gets).and_return('123')
          expect { subject.game_options }.to output(exiting).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.game_options }.to output(exiting).to_stdout

          allow(subject).to receive(:gets).and_return('something')
          expect { subject.game_options }.to output(exiting).to_stdout

          allow(subject).to receive(:gets).and_return('invalid options')
          expect { subject.game_options }.to output(exiting).to_stdout
        end
      end
    end
  end

  describe 'Inventory' do
    let(:weapon) { Weapon.new('a knife') }
    let(:armor) { Armor.new('a helmet') }
    let(:potion) { Potion.new('a potion') }

    context '#add_to_inventory' do
      it 'is defined' do
        expect(subject).to respond_to(:add_to_inventory)
      end

      context 'when passed an item' do
        context 'when invalid' do
          it 'returns false' do
            expect(subject.add_to_inventory({})).to eq(false)
            expect(subject.add_to_inventory('')).to eq(false)
            expect(subject.add_to_inventory('123412')).to eq(false)
            expect(subject.add_to_inventory('!@#%#')).to eq(false)
            expect(subject.add_to_inventory(9876)).to eq(false)
            expect(subject.add_to_inventory(not_valid: 'hi')).to eq(false)
            expect(subject.add_to_inventory([])).to eq(false)
          end
        end

        context 'when valid' do
          context "when item doesn't already exist (new item)" do
            it 'adds item to inventory' do
              expect(subject.inventory[:current_weapons]).to be_empty
              subject.add_to_inventory(weapon)
              expect(subject.inventory[:current_weapons]).not_to be_empty

              expect(subject.inventory[:current_armor]).to be_empty
              subject.add_to_inventory(armor)
              expect(subject.inventory[:current_armor]).not_to be_empty

              expect(subject.inventory[:current_potions]).to be_empty
              subject.add_to_inventory(potion)
              expect(subject.inventory[:current_potions]).not_to be_empty
            end
            it 'does not modify rest of inventory' do
              expect(subject.inventory[:current_armor]).to be_empty
              expect(subject.inventory[:current_weapons]).to be_empty
              expect(subject.inventory[:current_potions]).to be_empty

              expect(subject.add_to_inventory(weapon)).to eq(true)
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_weapons].count).to eq(1)
              expect(subject.inventory[:current_armor]).to be_empty
              expect(subject.inventory[:current_potions]).to be_empty

              expect(subject.add_to_inventory(armor)).to eq(true)
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_weapons].count).to eq(1)
              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_armor].count).to eq(1)
              expect(subject.inventory[:current_potions]).to be_empty

              expect(subject.add_to_inventory(potion)).to eq(true)
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_weapons].count).to eq(1)
              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_armor].count).to eq(1)
              expect(subject.inventory[:current_potions]).not_to be_empty
              expect(subject.inventory[:current_potions].count).to eq(1)
            end
            it 'returns true' do
              expect(subject.add_to_inventory(weapon)).to eq(true)
              expect(subject.add_to_inventory(Weapon.new('a shovel'))).to eq(true)

              expect(subject.add_to_inventory(armor)).to eq(true)
              expect(subject.add_to_inventory(Armor.new('a shoe'))).to eq(true)

              expect(subject.add_to_inventory(potion)).to eq(true)
              expect(subject.add_to_inventory(Potion.new('lemonade'))).to eq(true)
            end
          end

          context 'when item already exists (duplicate item)' do
            it 'does not add to inventory' do
              subject.add_to_inventory(weapon)
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_weapons].count).to eq(1)
              expect(subject.add_to_inventory(weapon)).to eq(false)
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_weapons].count).to eq(1)

              subject.add_to_inventory(armor)
              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_armor].count).to eq(1)
              expect(subject.add_to_inventory(armor)).to eq(false)
              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_armor].count).to eq(1)

              subject.add_to_inventory(potion)
              expect(subject.inventory[:current_potions]).not_to be_empty
              expect(subject.inventory[:current_potions].count).to eq(1)
              expect(subject.add_to_inventory(potion)).to eq(false)
              expect(subject.inventory[:current_potions]).not_to be_empty
              expect(subject.inventory[:current_potions].count).to eq(1)
            end
            it 'returns false' do
              expect(subject.add_to_inventory(weapon)).to eq(true)
              expect(subject.add_to_inventory(armor)).to eq(true)
              expect(subject.add_to_inventory(potion)).to eq(true)

              expect(subject.add_to_inventory(weapon)).to eq(false)
              expect(subject.add_to_inventory(armor)).to eq(false)
              expect(subject.add_to_inventory(potion)).to eq(false)
            end
          end
        end
      end
    end

    context '#remove_from_inventory' do
      it 'is defined' do
        expect(subject).to respond_to(:remove_from_inventory)
      end

      context 'when passed an item' do
        context 'when invalid' do
          it 'returns false' do
            expect(subject.remove_from_inventory({})).to eq(false)
            expect(subject.remove_from_inventory('')).to eq(false)
            expect(subject.remove_from_inventory('123412')).to eq(false)
            expect(subject.remove_from_inventory('!@#%#')).to eq(false)
            expect(subject.remove_from_inventory(9876)).to eq(false)
            expect(subject.remove_from_inventory(not_valid: 'hi')).to eq(false)
            expect(subject.remove_from_inventory([])).to eq(false)
          end
        end

        context 'when valid' do
          context 'when item already exists' do
            it 'removes item from inventory' do
              subject.add_to_inventory(weapon)

              expect(subject.inventory[:current_weapons]).not_to be_empty
              subject.remove_from_inventory(weapon)
              expect(subject.inventory[:current_weapons]).to be_empty
              subject.remove_from_inventory(weapon)
              expect(subject.inventory[:current_weapons]).to be_empty

              subject.add_to_inventory(armor)

              expect(subject.inventory[:current_armor]).not_to be_empty
              subject.remove_from_inventory(armor)
              expect(subject.inventory[:current_armor]).to be_empty
              subject.remove_from_inventory(armor)
              expect(subject.inventory[:current_armor]).to be_empty

              subject.add_to_inventory(potion)

              expect(subject.inventory[:current_potions]).not_to be_empty
              subject.remove_from_inventory(potion)
              expect(subject.inventory[:current_potions]).to be_empty
              subject.remove_from_inventory(potion)
              expect(subject.inventory[:current_potions]).to be_empty
            end
            it 'does not modify rest of inventory' do
              subject.add_to_inventory(weapon)
              subject.add_to_inventory(armor)
              subject.add_to_inventory(potion)

              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_weapons]).not_to be_empty
              expect(subject.inventory[:current_potions]).not_to be_empty

              expect(subject.remove_from_inventory(weapon)).to eq(true)
              expect(subject.inventory[:current_weapons]).to be_empty
              expect(subject.inventory[:current_armor]).not_to be_empty
              expect(subject.inventory[:current_armor].count).to eq(1)
              expect(subject.inventory[:current_potions]).not_to be_empty
              expect(subject.inventory[:current_potions].count).to eq(1)

              expect(subject.remove_from_inventory(armor)).to eq(true)
              expect(subject.inventory[:current_weapons]).to be_empty
              expect(subject.inventory[:current_armor]).to be_empty
              expect(subject.inventory[:current_potions]).not_to be_empty
              expect(subject.inventory[:current_potions].count).to eq(1)

              expect(subject.remove_from_inventory(potion)).to eq(true)
              expect(subject.inventory[:current_weapons]).to be_empty
              expect(subject.inventory[:current_armor]).to be_empty
              expect(subject.inventory[:current_potions]).to be_empty
            end
            it 'returns true' do
              subject.add_to_inventory(weapon)
              subject.add_to_inventory(armor)
              subject.add_to_inventory(potion)

              expect(subject.remove_from_inventory(weapon)).to eq(true)
              expect(subject.remove_from_inventory(armor)).to eq(true)
              expect(subject.remove_from_inventory(potion)).to eq(true)
            end
          end

          context "when item doesn't already exist (new item)" do
            it 'does not add to inventory' do
              expect(subject.remove_from_inventory(weapon)).to eq(false)
              expect(subject.inventory[:current_weapons]).to be_empty

              expect(subject.remove_from_inventory(armor)).to eq(false)
              expect(subject.inventory[:current_armor]).to be_empty

              expect(subject.remove_from_inventory(potion)).to eq(false)
              expect(subject.inventory[:current_potions]).to be_empty
            end
            it 'returns false' do
              expect(subject.remove_from_inventory(weapon)).to eq(false)
              expect(subject.remove_from_inventory(armor)).to eq(false)
              expect(subject.remove_from_inventory(potion)).to eq(false)
            end
          end
        end
      end
    end

    context '#current_inventory_weapons' do
      let(:broom) { Weapon.new('a broom').tap { |i| i.equipped = true } }
      let(:bat) { Weapon.new('a bat').tap { |i| i.equipped = true } }
      let(:hangar) { Weapon.new('a hangar') }

      it 'is defined' do
        expect(subject).to respond_to(:current_inventory_weapons)
      end
      it 'filters and selects weapons that are not equipped' do
        subject.add_to_inventory(weapon)
        subject.add_to_inventory(broom)
        subject.add_to_inventory(bat)
        subject.add_to_inventory(hangar)

        expect(subject.current_inventory_weapons).not_to be_empty
        expect(subject.current_inventory_weapons.count).to eq(2)
        expect(subject.current_inventory_weapons.map(&:name)).to include('a hangar', 'a knife')
      end
      it 'returns an empty array when inventory is empty' do
        subject.add_to_inventory(broom)
        subject.add_to_inventory(bat)
        expect(subject.current_inventory_weapons).to be_empty
      end
    end

    context '#current_inventory_armor' do
      let(:jacket) { Armor.new('a jacket').tap { |i| i.equipped = true } }
      let(:hat) { Armor.new('a hat').tap { |i| i.equipped = true } }
      let(:ring) { Armor.new('a ring') }

      it 'is defined' do
        expect(subject).to respond_to(:current_inventory_armor)
      end
      it 'filters and selects armor that are not equipped' do
        subject.add_to_inventory(armor)
        subject.add_to_inventory(jacket)
        subject.add_to_inventory(hat)
        subject.add_to_inventory(ring)

        expect(subject.current_inventory_armor).not_to be_empty
        expect(subject.current_inventory_armor.count).to eq(2)
        expect(subject.current_inventory_armor.map(&:name)).to include('a ring', 'a helmet')
      end
      it 'returns an empty array when inventory is empty' do
        subject.add_to_inventory(jacket)
        subject.add_to_inventory(hat)
        expect(subject.current_inventory_armor).to be_empty
      end
    end

    context '#current_inventory_potions' do
      let(:soup) { Potion.new('chicken noodle soup') }
      let(:empanada) { Potion.new('crispy empanada') }
      let(:quipe) { Potion.new('se nota que soy dominicano') }

      it 'is defined' do
        expect(subject).to respond_to(:current_inventory_potions)
      end
      it 'selects all available potions' do
        subject.add_to_inventory(potion)
        subject.add_to_inventory(soup)
        subject.add_to_inventory(empanada)
        subject.add_to_inventory(quipe)

        expect(subject.current_inventory_potions).not_to be_empty
        expect(subject.current_inventory_potions.count).to eq(4)
        expect(subject.current_inventory_potions.map(&:name)).to include('a potion', 'chicken noodle soup', 'crispy empanada', 'se nota que soy dominicano')
      end
      it 'returns an empty array when inventory is empty' do
        expect(subject.current_inventory_potions).to be_empty
      end
    end

    context '#inventory_empty?' do
      it 'is defined' do
        expect(subject).to respond_to(:inventory_empty?)
      end

      context 'when all inventory weapons, armor and potions are empty' do
        it 'returns true' do
          expect(subject.inventory_empty?).to eq(true)
        end
      end

      context 'when any inventory weapons, armor and potions have items' do
        it 'returns false' do
          subject.add_to_inventory(weapon)
          expect(subject.inventory_empty?).to eq(false)

          subject.add_to_inventory(armor)
          expect(subject.inventory_empty?).to eq(false)

          subject.add_to_inventory(potion)
          expect(subject.inventory_empty?).to eq(false)

          subject.remove_from_inventory(weapon)
          expect(subject.inventory_empty?).to eq(false)

          subject.remove_from_inventory(armor)
          expect(subject.inventory_empty?).to eq(false)

          subject.remove_from_inventory(potion)
          expect(subject.inventory_empty?).to eq(true)
        end
      end
    end

    context '#display_inventory_weapons' do
      let(:first_weapon_display_format) { /1\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:second_weapon_display_format) { /2\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:third_weapon_display_format) { /3\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

      context 'when inventory is empty' do
        it 'prints out empty' do
          expect { subject.display_inventory_weapons }.to output(/empty/i).to_stdout
        end
      end

      context 'when inventory has one item' do
        it 'prints out current weapon' do
          subject.add_to_inventory(weapon)
          expect { subject.display_inventory_weapons }.to output(first_weapon_display_format).to_stdout
        end
      end

      context 'when inventory has multiple items' do
        it 'prints out all weapons in inventory' do
          subject.add_to_inventory(weapon)
          subject.add_to_inventory(Weapon.new('a scissor'))
          expect { subject.display_inventory_weapons }.to output(first_weapon_display_format).to_stdout
          expect { subject.display_inventory_weapons }.to output(second_weapon_display_format).to_stdout
          expect { subject.display_inventory_weapons }.not_to output(third_weapon_display_format).to_stdout
        end
      end
    end

    context '#display_inventory_armor' do
      let(:first_armor_display_format) { /1\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:second_armor_display_format) { /2\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:third_armor_display_format) { /3\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

      context 'when inventory is empty' do
        it 'prints out empty' do
          expect { subject.display_inventory_armor }.to output(/empty/i).to_stdout
        end
      end

      context 'when inventory has one item' do
        it 'prints out current armor' do
          subject.add_to_inventory(armor)
          expect { subject.display_inventory_armor }.to output(first_armor_display_format).to_stdout
        end
      end

      context 'when inventory has multiple items' do
        it 'prints out all armor in inventory' do
          subject.add_to_inventory(armor)
          subject.add_to_inventory(Armor.new('a coat'))
          expect { subject.display_inventory_armor }.to output(first_armor_display_format).to_stdout
          expect { subject.display_inventory_armor }.to output(second_armor_display_format).to_stdout
          expect { subject.display_inventory_armor }.not_to output(third_armor_display_format).to_stdout
        end
      end
    end

    context '#display_inventory_potions' do
      let(:first_potion_display_format) { /1\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:second_potion_display_format) { /2\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
      let(:third_potion_display_format) { /3\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

      context 'when inventory is empty' do
        it 'prints out empty' do
          expect { subject.display_inventory_potions }.to output(/empty/i).to_stdout
        end
      end

      context 'when inventory has one item' do
        it 'prints out current potion' do
          subject.add_to_inventory(potion)
          expect { subject.display_inventory_potions }.to output(first_potion_display_format).to_stdout
        end
      end

      context 'when inventory has multiple items' do
        it 'prints out all potions in inventory' do
          subject.add_to_inventory(potion)
          subject.add_to_inventory(Potion.new('a water bottle'))
          expect { subject.display_inventory_potions }.to output(first_potion_display_format).to_stdout
          expect { subject.display_inventory_potions }.to output(second_potion_display_format).to_stdout
          expect { subject.display_inventory_potions }.not_to output(third_potion_display_format).to_stdout
        end
      end
    end

    context '#display_inventory_items' do
      it 'calls display_inventory_weapons, display_inventory_armor and display_inventory_potions' do
        expect(subject).to receive(:display_inventory_weapons)
        expect(subject).to receive(:display_inventory_armor)
        expect(subject).to receive(:display_inventory_potions)
        subject.display_inventory_items
      end
    end
  end
end
