hero = Hero.new(
  health: 100,
  level: 1,
  attack: 25,
  defense: 40,
  money: 210000, #TODO Change this to a very small number for release. It's only this high for debug reasons
  exp: 0
)

describe Hero do
  describe "#apply_ketchup" do
    subject { burger }
    before  { burger.apply_ketchup }

    context "with ketchup" do
      let(:burger) { Burger.new(:ketchup => true) }

      it { should have_ketchup_on_it }
    end

    context "without ketchup" do
      let(:burger) { Burger.new(:ketchup => false) }

      it { should_not have_ketchup_on_it }
    end
  end
end
