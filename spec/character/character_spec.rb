require "pry"
# TODO add validation for subject attributes. Ex: Health cannot go over 100 etc

describe Character do
  subject { Character.new }

  describe "includes base modules" do
    it 'includes Validator module' do
      extended_class = class Bar; include Validator; end
      expect(extended_class.included_modules).to include Validator
    end
    it 'includes Display module' do
      extended_class = class Bar; include Display; end
      expect(extended_class.included_modules).to include Display
    end
    it 'includes Procs module' do
      extended_class = class Bar; include Procs; end
      expect(extended_class.included_modules).to include Procs
    end
    it 'includes Utility module' do
      extended_class = class Bar; include Utility; end
      expect(extended_class.included_modules).to include Utility
    end
  end

  describe "#initialize" do
    context "when no arguments passed in" do
      it "has default values" do
        expect(subject).to have_attributes(
          name: 'Nameless One',
          health: 100,
          max_hp: 100,
          level: 1,
          attack: 10,
          defense: 10,
          money: 0,
          experience: 0,
          description: '',
          main_class: 'Character'
        )
      end
    end

    context "when arguments passed in" do
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
      it "has passed in values" do
        expect(full_character).to have_attributes(
          name: 'Nameless One',
          health: 110,
          max_hp: 110,
          level: 2,
          attack: 25,
          defense: 40,
          money: 100,
          experience: 10,
          description: 'My custom character',
          main_class: 'Character'
        )
      end
    end
  end

  describe "knows its health status" do
    context "when initialized" do
      it "its alive" do
        expect(subject.alive?).to eq(true)
      end
      it "its not dead" do
        expect(subject.dead?).to eq(false)
      end
    end
    context "when health is zero" do
      let(:dead_character) { Character.new(health: 0) }
      it "its dead" do
        expect(dead_character.dead?).to eq(true)
      end
      it "its not alive" do
        expect(dead_character.alive?).to eq(false)
      end
    end
    context "when health is greater than zero" do
      let(:alive_character) { Character.new(health: 50) }
      it "its alive" do
        expect(alive_character.alive?).to eq(true)
      end
      it "its not dead" do
        expect(alive_character.dead?).to eq(false)
      end
    end
  end

  describe "#health=" do
    let(:health_character) { Character.new }
    it 'resets negative values to zero' do
      health_character.health = -50;
      expect(health_character.health).to eq(0)
      health_character.health = -1;
      expect(health_character.health).to eq(0)
    end
    it 'does not go over max hp' do
      health_character.health = 101;
      expect(health_character.health).to eq(100)
      health_character.health = 150;
      expect(health_character.health).to eq(100)
    end
    it 'updates if health is valid' do
      health_character.health = 0;
      expect(health_character.health).to eq(0)
      health_character.health = 50;
      expect(health_character.health).to eq(50)
      health_character.health = 100;
      expect(health_character.health).to eq(100)
    end
  end

  describe "#do_damage_to" do
    let(:sender) { Character.new }
    let(:receiver) { Character.new }
    it 'exists and accepts one parameter (receiver)' do
      expect(subject).to respond_to(:do_damage_to).with(1).argument
    end
    it 'returns damage dealt' do
      expect(sender.do_damage_to(receiver)).to be_a(Fixnum)
    end
    it 'deals damage to receiver' do
      sender.do_damage_to(receiver)
      expect(receiver.health).to be < 100 # can damage be zero?
    end
  end

end
