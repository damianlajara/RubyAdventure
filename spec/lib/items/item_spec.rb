describe Item do
  subject(:item) { Item.new }
  let(:full_item) do
    Item.new('an item', {
      price: 1000,
      sell_value: 500,
      description: 'meaningless item'
    })
  end

  describe "attributes" do
    it "has a name" do
      expect(subject).to respond_to(:name)
    end
    it "has a price" do
      expect(subject).to respond_to(:price)
    end
    it "has a sell_value" do
      expect(subject).to respond_to(:sell_value)
    end
    it "has a description" do
      expect(subject).to respond_to(:description)
    end
  end

  describe "#initialize" do
    context "when parameters are passed in" do
      context "when name as first parameter is passed in" do
        let(:ruby) { Item.new('ruby') }
        it 'initializes with passed in name' do
          expect(ruby).to have_attributes(name: 'ruby')
        end
        it 'reverts other attributes to default values' do
          expect(subject).to have_attributes(
            price: a_value >= 0,
            sell_value: a_value >= 0,
            description: a_string_matching('')
          )
        end
      end

      context "when optional arguments as second parameter is passed in" do
        let(:nameless) do
          Item.new(
            price: 500,
            sell_value: 250,
            description: 'nameless item'
          )
        end
        it 'initializes with passed optional arguments' do
          expect(nameless).to have_attributes(
            price: 500,
            sell_value: 250,
            description: 'nameless item'
          )
        end
        it 'defaults name to an empty string' do
          expect(nameless).to have_attributes(name: a_string_matching(''))
        end
      end

      context "when both name and optional arguments as parameters are passed in" do
        it 'initializes with passed in name' do
          expect(full_item).to have_attributes(name: 'an item')
        end
        it 'initializes with passed optional arguments' do
          expect(full_item).to have_attributes(
            price: 1000,
            sell_value: 500,
            description: 'meaningless item'
          )
        end
      end

      context "when neither name nor optional arguments as parameters are passed in" do
        it 'reverts all attributes to default values' do
          expect(subject).to have_attributes(
            name: a_string_matching(''),
            price: a_value >= 0,
            sell_value: a_value >= 0,
            description: a_string_matching('')
          )
        end
      end
    end
  end

  describe "#to_s" do
    it 'returns name' do
      expect(subject.to_s).to eq(subject.name)
    end
  end
end
