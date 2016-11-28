describe "Equip mixin" do
  subject { Hero.new }

  describe "#equipped_weapons" do
    let(:equipped_weapon) { Weapon.new('a hammer').tap { |w| w.equipped = true } }
    let(:equipped_weapon2) { Weapon.new('a gun').tap { |w| w.equipped = true } }

    it 'is defined' do
      expect(subject).to respond_to(:equipped_weapons)
    end

    context "when no weapons are equipped" do
      it 'returns an empty array' do
        expect(subject.equipped_weapons).to be_empty
      end
    end

    context "when one weapon is equipped" do
      it 'returns equipped weapon' do
        subject.add_to_inventory(equipped_weapon)
        expect(subject.equipped_weapons).not_to be_empty
        expect(subject.equipped_weapons.count).to eq(1)
      end
    end
  end

  describe "#equipped_armor" do
    let(:equipped_armor) { Armor.new('a hat').tap { |w| w.equipped = true } }
    let(:equipped_armor2) { Armor.new('a scarf').tap { |w| w.equipped = true } }

    it 'is defined' do
      expect(subject).to respond_to(:equipped_armor)
    end

    context "when no armor are equipped" do
      it 'returns an empty array' do
        expect(subject.equipped_armor).to be_empty
      end
    end

    context "when one armor is equipped" do
      it 'returns equipped armor' do
        subject.add_to_inventory(equipped_armor)
        expect(subject.equipped_armor).not_to be_empty
        expect(subject.equipped_armor.count).to eq(1)
      end
    end
  end

  describe "#equip_weapon" do
    let(:weapon) { Weapon.new('a nail') }
    it 'is defined' do
      expect(subject).to respond_to(:equip_weapon)
    end

    context "when inventory is empty" do
      it 'outputs error message' do
        expect { subject.equip_weapon }.to output(/you have no weapons to equip/i).to_stdout
      end
    end

    context "when inventory is not empty" do
      it 'calls #display_inventory_weapons' do
        subject.add_to_inventory(weapon)
        allow(subject).to receive(:gets).and_return('')
        expect(subject).to receive(:display_inventory_weapons)
        subject.equip_weapon
      end

      context "when invalid answer is entered" do
        let(:invalid_weapon_equip) { /Unable to equip weapon/i }
        it 'prints out an error message' do
          subject.add_to_inventory(weapon)
          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('-1')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('0')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('2')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('12343')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('something_invalid')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:display_inventory_weapons)
          allow(subject).to receive(:gets).and_return('should error')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout
        end
      end

      context "when valid answer is entered" do
        context "when no weapons are equipped" do
          it 'equips weapon' do
            skip
          end
          it 'prints out success message' do
            skip
          end
        end
        context "when already have a weapon equipped" do
          it 'does not equip weapon' do
            skip
          end
          it 'prints error message' do
            skip
          end
        end
      end
    end

  end
end
