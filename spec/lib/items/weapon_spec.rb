describe Weapon do
  subject(:weapon) { Weapon.new('a knife') }
  it 'inherits from Item' do
    expect(Weapon.superclass).to eq(Item)
  end

  describe 'attributes' do
    it 'has damage' do
      expect(subject).to respond_to(:damage)
    end
    it 'has equipped' do
      expect(subject).to respond_to(:equipped)
      expect(subject).to respond_to(:equipped=)
    end
  end

  describe '#initialize' do
    it 'has item default values' do
      expect(subject).to have_attributes(
        price: a_value >= 0,
        sell_value: a_value >= 0,
        description: a_string_matching('')
      )
    end

    context 'when arguments are passed in' do
      let(:invalid) { /invalid name entered/i }
      context 'when name is passed in' do
        context 'when not empty' do
          it 'initializes with passed in name' do
            expect(weapon).to have_attributes(name: 'a knife')
          end
        end

        context 'when empty' do
          it 'raises error' do
            expect { Weapon.new('') }.to raise_error(invalid)
          end
        end
      end

      context 'when only optional arguments are passed in' do
        it 'raises error' do
          expect { Weapon.new(damage: 250) }.to raise_error(invalid)
        end
      end

      context 'when both name and optional arguments are passed in' do
        it 'initializes with passed in arguments' do
          expect(Weapon.new('a bat', damage: 500)).to have_attributes(damage: 500)
        end
        it 'overrides default values' do
          expect(Weapon.new('a shuriken',
            damage: 500,
            price: 40,
            sell_value: 20
          )).to have_attributes(
            name: 'a shuriken',
            damage: 500,
            price: 40,
            sell_value: 20,
            description: ''
          )
        end
      end
    end

    context 'when no arguments are passed in' do
      it 'raises argument error' do
        expect { Weapon.new }.to raise_error(ArgumentError)
      end
    end
  end
end
