require "pry"
# TODO add validation for subject attributes. Ex: Health cannot go over 100 etc

describe Character do
  subject { Character.new }
  let(:full_character) do
    Character.new(
      health: 110,
      level: 2,
      attack: 25,
      defense: 40,
      money: 100,
      experience: 10,
      description: 'My custom character'
    )
  end

  describe "#initialize" do
    context "when no arguments passed in" do
      it "has default values" do
        expect(subject).to have_attributes(
          name: 'Nameless One',
          health: 100,
          level: 1,
          attack: 10,
          defense: 10,
          money: 0,
          experience: 0,
          description: ''
        )
      end
    end

    context "when arguments passed in" do
      it "has passed in values" do
        expect(full_character).to have_attributes(
          name: 'Nameless One',
          health: 110,
          level: 2,
          attack: 25,
          defense: 40,
          money: 100,
          experience: 10,
          description: 'My custom character'
        )
      end
    end
  end

  describe "included modules" do
    context "when base class is created" do
      it 'include Validator module' do
        extended_class = class Bar; include Validator; end
        expect(extended_class.included_modules).to include Validator
      end
      it 'include Display module' do
        extended_class = class Bar; include Display; end
        expect(extended_class.included_modules).to include Display
      end
      it 'include Procs module' do
        extended_class = class Bar; include Procs; end
        expect(extended_class.included_modules).to include Procs
      end
      it 'include Utility module' do
        extended_class = class Bar; include Utility; end
        expect(extended_class.included_modules).to include Utility
      end
    end
  end
  # describe "#reset_stats" do
  #   it "is defined" do
  #     expect(subject).to respond_to(:reset_stats)
  #   end
  #
  #   it "resets to default settings" do
  #     full_character.reset_stats
  #     expect(full_character).to have_attributes(
  #       health: 100,
  #       level: 1,
  #       attack: 0,
  #       defense: 00,
  #       money: 0,
  #       experience: 0,
  #       inventory: {
  #         current_potions: [],
  #         current_armor: [],
  #         current_weapons: []
  #       }
  #     )
  #   end
  # end
  #
  # describe "#customize_name" do
  #   it "is defined" do
  #     expect(subject).to respond_to(:customize_name)
  #   end
  #
  #   it "sets name" do
  #     allow(subject).to receive(:gets).exactly(1).times.and_return('Damian')
  #     subject.customize_name
  #     expect(subject.name).to eq('Damian')
  #   end
  # end
  #
  # describe "#customize_gender" do
  #   let(:gender) { {male: 'Male', female: 'Female', other: 'Other'} }
  #
  #   it "is defined" do
  #     expect(subject).to respond_to(:customize_gender)
  #   end
  #
  #   context "when Male as gender is selected" do
  #     it 'returns Male' do
  #       allow(subject).to receive(:gets).and_return('1')
  #       subject.customize_gender
  #       expect(subject.gender).to eq('Male')
  #     end
  #   end
  #
  #   context "when Female as gender is selected" do
  #     it 'returns Female' do
  #       allow(subject).to receive(:gets).and_return('2')
  #       subject.customize_gender
  #       expect(subject.gender).to eq('Female')
  #     end
  #   end
  #
  #   context "when custom gender choice is selected" do
  #     it 'returns custom gender' do
  #       allow(subject).to receive(:gets).exactly(2).times.and_return('3', 'Other')
  #       subject.customize_gender
  #       expect(subject.gender).to eq('Other')
  #     end
  #
  #     it 'defaults to Other when invalid input' do
  #       allow(subject).to receive(:gets).exactly(2).times.and_return('3', "")
  #       subject.customize_gender
  #       expect(subject.gender).to eq('Other')
  #     end
  #   end
  #
  #   context "when unknown choice is selected" do
  #     it "returns Genderless" do
  #       allow(subject).to receive(:gets).exactly(1).times.and_return('Genderless')
  #       subject.customize_gender
  #       expect(subject.gender).to eq('Genderless')
  #     end
  #   end
  # end
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
  # describe "#customize" do
  #   after { subject.customize }
  #
  #   it "is defined" do
  #     expect(subject).to respond_to(:customize)
  #   end
  #
  #   it "customizes name" do
  #     expect(subject).to receive(:customize_name)
  #   end
  #
  #   it "customizes gender" do
  #     expect(subject).to receive(:customize_gender).once
  #   end
  #
  #   it "customizes class" do
  #     expect(subject).to receive(:customize_class).once
  #   end
  #
  #   it "prints welcome message" do
  #     expect(subject).to receive(:display_welcome_message).once
  #   end
  # end
end
