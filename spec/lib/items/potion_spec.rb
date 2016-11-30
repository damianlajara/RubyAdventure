describe Potion do
  subject(:potion) { Potion.new('a water bottle') }
  it 'inherits from Item' do
    expect(Potion.superclass).to eq(Item)
  end

  describe 'attributes' do
    it 'has health' do
      expect(subject).to respond_to(:health)
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
            expect(potion).to have_attributes(name: 'a water bottle')
          end
        end

        context 'when empty' do
          it 'raises error' do
            expect { Potion.new('') }.to raise_error(invalid)
          end
        end
      end

      context 'when only optional arguments are passed in' do
        it 'raises error' do
          expect { Potion.new(health: 250) }.to raise_error(invalid)
        end
      end

      context 'when both name and optional arguments are passed in' do
        it 'initializes with passed in arguments' do
          expect(Potion.new('a bat', health: 500)).to have_attributes(health: 500)
        end
        it 'overrides default values' do
          expect(Potion.new('soup',
            health: 500,
            price: 40,
            sell_value: 20
          )).to have_attributes(
            name: 'soup',
            health: 500,
            price: 40,
            sell_value: 20,
            description: ''
          )
        end
      end
    end

    context 'when no arguments are passed in' do
      it 'raises argument error' do
        expect { Potion.new }.to raise_error(ArgumentError)
      end
    end
  end
end
