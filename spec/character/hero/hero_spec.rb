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

  end

  #
  # describe "#customize_class" do
  #   it "is defined" do
  #     expect(subject).to respond_to(:customize_class)
  #   end
  #
  #   context "when soldier is selected" do
  #     let(:soldiers) { %w(Barbarian Knight Paladin Samurai) }
  #
  #     it "sets base class to soldier" do
  #       allow(subject).to receive(:gets).and_return("1")
  #       subject.customize_class
  #       expect(subject.base_class).to eq(:soldier)
  #     end
  #
  #     it "sets main_class to a valid specification of soldier" do
  #       soldiers.count.times do |choice|
  #         allow(subject).to receive(:gets).exactly(2).times.and_return("1", choice.next.to_s)
  #         subject.customize_class
  #         expect(subject.main_class).to eq(soldiers[choice])
  #       end
  #     end
  #   end
  #
  #   context "when mage is selected" do
  #     let(:mages) { %w(Necromancer Wizard Illusionist Alchemist) }
  #
  #     it "sets base class to mage" do
  #       allow(subject).to receive(:gets).and_return("2")
  #       subject.customize_class
  #       expect(subject.base_class).to eq(:mage)
  #     end
  #
  #     it "sets main_class to a valid specification of mage" do
  #       mages.count.times do |choice|
  #         allow(subject).to receive(:gets).exactly(2).times.and_return("2", choice.next.to_s)
  #         subject.customize_class
  #         expect(subject.main_class).to eq(mages[choice])
  #       end
  #     end
  #   end
  #
  #   context "when ranged is selected" do
  #     let(:ranged) { %w(Archer Gunner Tamer Elf) }
  #
  #     it "sets base class to ranged" do
  #       allow(subject).to receive(:gets).and_return("3")
  #       subject.customize_class
  #       expect(subject.base_class).to eq(:ranged)
  #     end
  #
  #     it "sets main_class to a valid specification of ranged" do
  #       ranged.count.times do |choice|
  #         allow(subject).to receive(:gets).exactly(2).times.and_return("3", choice.next.to_s)
  #         subject.customize_class
  #         expect(subject.main_class).to eq(ranged[choice])
  #       end
  #     end
  #   end
  #
  #   context "when invalid option is entered" do
  #     it "defaults to soldier" do
  #       ["4", "k", "", "hi"].each do |result|
  #         allow(subject).to receive(:gets).and_return(result)
  #         subject.customize_class
  #         expect(subject.base_class).to eq(:soldier)
  #       end
  #     end
  #   end
  # end
  #
  # describe "#display_game_options_header" do
  #   it "is defined" do
  #     expect(subject).to respond_to(:display_game_options_header).with(1).argument
  #   end
  #
  #   it "displays a message containing Game Options" do
  #     expect(subject).to receive(:puts).with(a_string_matching(/Game Options/i))
  #     subject.display_game_options_header(1)
  #   end
  # end
  #
  # describe "#game_options" do
  #   let(:options) { ["Toggle Battle Scenes", "Change Class", "Change Gender", "Change Name"] }
  #   after { subject.game_options }
  #
  #   it "displays a header message" do
  #     expect(subject).to receive(:display_game_options_header).once
  #   end
  #
  #   context "when Toggle Battle Scenes is selected" do
  #     it "toggles battle scenes" do
  #       allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(1)
  #       expect(subject).to receive(:toggle_battle_scenes).once
  #     end
  #   end
  #
  #   context "when change class is selected" do
  #     context "when it asks user for confirmation" do
  #       context "when user selects to proceed" do
  #         it "changes class" do
  #           allow(subject).to receive(:choose_array_option).with(options, true).and_return(2)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(1)
  #           expect(subject).to receive(:reset_stats).once
  #           expect(subject).to receive(:customize_class).once
  #         end
  #       end
  #
  #       context "when user selects to stop" do
  #         it "class stays the same" do
  #           allow(subject).to receive(:gets).and_return("1", "2")
  #           subject.customize_class
  #           main_class = subject.main_class
  #           allow(subject).to receive(:choose_array_option).with(options, true).and_return(2)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(2)
  #           expect(subject.main_class).to eq main_class
  #         end
  #       end
  #     end
  #   end
  #
  #   context "when change gender is selected" do
  #     context "when it asks user for confirmation" do
  #       context "when user selects to proceed" do
  #         it "changes gender" do
  #           allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(3)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(1)
  #           expect(subject).to receive(:customize_gender).once
  #         end
  #       end
  #
  #       context "when user selects to stop" do
  #         it "gender stays the same" do
  #           allow(subject).to receive(:gets).and_return("1", "2")
  #           subject.customize_gender
  #           gender = subject.gender
  #           allow(subject).to receive(:choose_array_option).with(options, true).and_return(3)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(2)
  #           expect(subject.gender).to eq gender
  #         end
  #       end
  #     end
  #   end
  #
  #   context "when change name is selected" do
  #     context "when it asks user for confirmation" do
  #       context "when user selects to proceed" do
  #         it "changes name" do
  #           allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(4)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(1)
  #           expect(subject).to receive(:customize_name).once
  #         end
  #       end
  #
  #       context "when user selects to stop" do
  #         it "name stays the same" do
  #           allow(subject).to receive(:gets).and_return("Damian")
  #           subject.customize_name
  #           name = subject.name
  #           allow(subject).to receive(:choose_array_option).with(options, true).and_return(4)
  #           allow(subject).to receive(:choose_array_option).with(["yes","no"], true).and_return(2)
  #           expect(subject.name).to eq name
  #         end
  #       end
  #     end
  #   end
  #
  #   context "when any other type of input is entered" do
  #     it "displays exiting message and returns to main menu" do
  #       allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(5)
  #       allow(subject).to receive(:puts).with(a_string_matching(/Game Options/i))
  #       expect(subject).to receive(:puts).with(a_string_matching(/exiting/i))
  #     end
  #   end
  # end
  #
  # describe "#display_welcome_message" do
  #   it "should be defined" do
  #     expect(subject).to respond_to(:display_welcome_message)
  #   end
  #
  #   it "welcomes user" do
  #     expect(subject).to receive(:puts).with(a_string_matching(/Welcome/i)).once
  #     subject.display_welcome_message
  #   end
  # end
  #
end
