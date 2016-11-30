describe Armor do
  subject(:armor) { Armor.new('a hat') }
  it 'inherits from Item' do
    expect(Armor.superclass).to eq(Item)
  end

  describe 'attributes' do
    it 'has defense' do
      expect(subject).to respond_to(:defense)
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
        description: a_string_matching(''),
        equipped: false
      )
    end

    context 'when arguments are passed in' do
      let(:invalid) { /invalid name entered/i }
      context 'when name is passed in' do
        context 'when not empty' do
          it 'initializes with passed in name' do
            expect(armor).to have_attributes(name: 'a hat')
          end
        end

        context 'when empty' do
          it 'raises error' do
            expect { Armor.new('') }.to raise_error(invalid)
          end
        end
      end

      context 'when only optional arguments are passed in' do
        it 'raises error' do
          expect { Armor.new(defense: 250) }.to raise_error(invalid)
        end
      end

      context 'when both name and optional arguments are passed in' do
        it 'initializes with passed in arguments' do
          expect(Armor.new('a bat', defense: 500)).to have_attributes(defense: 500)
        end
        it 'overrides default values' do
          expect(Armor.new('a shuriken',
            defense: 500,
            price: 40,
            sell_value: 20
          )).to have_attributes(
            name: 'a shuriken',
            equipped: false,
            defense: 500,
            price: 40,
            sell_value: 20,
            description: ''
          )
        end
      end
    end

    context 'when no arguments are passed in' do
      it 'raises argument error' do
        expect { Armor.new }.to raise_error(ArgumentError)
      end
    end
  end
end
