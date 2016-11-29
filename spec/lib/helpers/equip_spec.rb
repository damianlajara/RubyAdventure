describe "Equip mixin" do
  subject { Hero.new }
  let(:weapon) { Weapon.new('a nail') }
  let(:armor) { Armor.new('a sock') }
  let(:equipped_weapon) { Weapon.new('a hammer').tap { |w| w.equipped = true } }
  let(:equipped_weapon2){ Weapon.new('a weapon').tap { |w| w.equipped = true } }
  let(:equipped_armor) { Armor.new('a hat').tap { |w| w.equipped = true } }
  let(:equipped_armor2) { Armor.new('some armor').tap { |w| w.equipped = true } }

  describe "#equipped_weapons" do
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

    context "when multiple weapons are equipped" do
      it 'returns equipped weapons' do
        subject.add_to_inventory(equipped_weapon)
        subject.add_to_inventory(equipped_weapon2)
        expect(subject.equipped_weapons).not_to be_empty
        expect(subject.equipped_weapons.count).to eq(2)
      end
    end
  end

  describe "#equipped_armor" do
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

    context "when multiple armor are equipped" do
      it 'returns equipped armor' do
        subject.add_to_inventory(equipped_armor)
        subject.add_to_inventory(equipped_armor2)
        expect(subject.equipped_armor).not_to be_empty
        expect(subject.equipped_armor.count).to eq(2)
      end
    end
  end

  describe "#equipped_items?" do
    it 'is defined' do
      expect(subject).to respond_to(:equipped_items?)
    end

    context "when items are equipped" do
      context "when a weapon is equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_weapon)
          expect(subject.equipped_items?).to eq(true)
        end
      end

      context "when multiple weapons are equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_weapon)
          subject.add_to_inventory(equipped_weapon2)
          expect(subject.equipped_items?).to eq(true)
        end
      end

      context "when an armor is equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_armor)
          expect(subject.equipped_items?).to eq(true)
        end
      end

      context "when multiple armor are equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_armor)
          subject.add_to_inventory(equipped_armor2)
          expect(subject.equipped_items?).to eq(true)
        end
      end

      context "when both armor and weapon are equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_weapon)
          subject.add_to_inventory(equipped_armor)
          expect(subject.equipped_items?).to eq(true)
        end
      end

      context "when multiple armor and weapons are equipped" do
        it 'returns true' do
          subject.add_to_inventory(equipped_weapon)
          subject.add_to_inventory(equipped_weapon2)
          subject.add_to_inventory(equipped_armor)
          subject.add_to_inventory(equipped_armor2)
          expect(subject.equipped_items?).to eq(true)
        end
      end
    end

    context "when items are not equipped" do
      context "when no weapons are equipped" do
        context "when invetory is empty" do
          it 'returns false' do
            expect(subject.equipped_items?).to eq(false)
          end
        end
        context "when inventory is not empty" do
          it 'returns false' do
            subject.add_to_inventory(weapon)
            expect(subject.equipped_items?).to eq(false)
          end
        end
      end
    end
  end

  describe "#equippable_items?" do
    it 'is defined' do
      expect(subject).to respond_to(:equippable_items?)
    end
    
  end

  describe "#equip_weapon" do
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

          allow(subject).to receive(:gets).and_return('-1')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('0')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('2')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('12343')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('something_invalid')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout

          allow(subject).to receive(:gets).and_return('should error')
          expect { subject.equip_weapon }.to output(invalid_weapon_equip).to_stdout
        end
      end

      context "when valid answer is entered" do
        context "when no weapons are equipped" do
          it 'equips weapon' do
            subject.add_to_inventory(weapon)
            expect(weapon.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.equip_weapon
            expect(weapon.equipped).to eq(true)
            expect(subject.equipped_weapons).to include(weapon)
          end
          it 'prints out success message' do
            subject.add_to_inventory(weapon)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.equip_weapon }.to output(/succesfully equipped/i).to_stdout
          end
        end
        context "when already have a weapon equipped" do
          it 'does not equip another weapon' do
            subject.add_to_inventory(equipped_weapon)
            subject.add_to_inventory(weapon)
            expect(weapon.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.equip_weapon
            expect(weapon.equipped).to eq(false)
          end
          it 'prints error message' do
            subject.add_to_inventory(equipped_weapon)
            subject.add_to_inventory(weapon)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.equip_weapon }.to output(/you already have a weapon equipped/i).to_stdout
          end
        end
      end
    end
  end

  describe "#equip_armor" do
    it 'is defined' do
      expect(subject).to respond_to(:equip_armor)
    end

    context "when inventory is empty" do
      it 'outputs error message' do
        expect { subject.equip_armor }.to output(/you have no armor to equip/i).to_stdout
      end
    end

    context "when inventory is not empty" do
      it 'calls #display_inventory_armor' do
        subject.add_to_inventory(armor)
        allow(subject).to receive(:gets).and_return('')
        expect(subject).to receive(:display_inventory_armor)
        subject.equip_armor
      end

      context "when invalid answer is entered" do
        let(:invalid_armor_equip) { /Unable to equip armor/i }
        it 'prints out an error message' do
          subject.add_to_inventory(armor)

          allow(subject).to receive(:gets).and_return('-1')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('0')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('2')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('12343')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('something_invalid')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout

          allow(subject).to receive(:gets).and_return('should error')
          expect { subject.equip_armor }.to output(invalid_armor_equip).to_stdout
        end
      end

      context "when valid answer is entered" do
        context "when no armor are equipped" do
          it 'equips armor' do
            subject.add_to_inventory(armor)
            expect(armor.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.equip_armor
            expect(armor.equipped).to eq(true)
            expect(subject.equipped_armor).to include(armor)
          end
          it 'prints out success message' do
            subject.add_to_inventory(armor)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.equip_armor }.to output(/succesfully equipped/i).to_stdout
          end
        end
        context "when already have a armor equipped" do
          it 'does not equip another armor' do
            subject.add_to_inventory(equipped_armor)
            subject.add_to_inventory(armor)
            expect(armor.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.equip_armor
            expect(armor.equipped).to eq(false)
          end
          it 'prints error message' do
            subject.add_to_inventory(equipped_armor)
            subject.add_to_inventory(armor)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.equip_armor }.to output(/you already have a armor equipped/i).to_stdout
          end
        end
      end
    end
  end

  describe "#unequip_weapon" do
    it 'is defined' do
      expect(subject).to respond_to(:unequip_weapon)
    end

    context "when equipped weapons inventory is empty" do
      it 'outputs error message' do
        expect { subject.unequip_weapon }.to output(/you have no weapons to un-equip/i).to_stdout
      end
    end

    context "when equipped weapons inventory is not empty" do
      it 'calls #display_equipped_weapons' do
        subject.add_to_inventory(equipped_weapon)
        allow(subject).to receive(:gets).and_return('')
        expect(subject).to receive(:display_equipped_weapons)
        subject.unequip_weapon
      end

      context "when invalid answer is entered" do
        let(:invalid_weapon_unequip) { /Unable to un-equip weapon/i }
        it 'prints out an error message' do
          subject.add_to_inventory(equipped_weapon)

          allow(subject).to receive(:gets).and_return('-1')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('0')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('2')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('12343')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('something_invalid')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('should error')
          expect { subject.unequip_weapon }.to output(invalid_weapon_unequip).to_stdout
        end
      end

      context "when valid answer is entered" do
        context "when already have a weapon equipped" do
          it 'un-equips weapon' do
            subject.add_to_inventory(equipped_weapon)
            expect(equipped_weapon.equipped).to eq(true)
            allow(subject).to receive(:gets).and_return('1')
            subject.unequip_weapon
            expect(equipped_weapon.equipped).to eq(false)
            expect(subject.equipped_weapons).not_to include(equipped_weapon)
            expect(subject.equipped_weapons).to be_empty
          end
          it 'prints out success message' do
            subject.add_to_inventory(equipped_weapon)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.unequip_weapon }.to output(/succesfully un-equipped/i).to_stdout
          end
        end
        context "when no weapons are equipped" do
          it 'does not un-equip non-existent weapon' do
            subject.add_to_inventory(weapon)
            expect(weapon.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.unequip_weapon
            expect(weapon.equipped).to eq(false)
          end
        end
      end
    end




  end

  describe "#unequip_armor" do
    it 'is defined' do
      expect(subject).to respond_to(:unequip_armor)
    end

    context "when equipped armor inventory is empty" do
      it 'outputs error message' do
        expect { subject.unequip_armor }.to output(/you have no armor to un-equip/i).to_stdout
      end
    end

    context "when equipped armor inventory is not empty" do
      it 'calls #display_equipped_armor' do
        subject.add_to_inventory(equipped_armor)
        allow(subject).to receive(:gets).and_return('')
        expect(subject).to receive(:display_equipped_armor)
        subject.unequip_armor
      end

      context "when invalid answer is entered" do
        let(:invalid_armor_unequip) { /Unable to un-equip armor/i }
        it 'prints out an error message' do
          subject.add_to_inventory(equipped_armor)

          allow(subject).to receive(:gets).and_return('-1')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('0')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('2')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('!@#$')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('12343')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('something_invalid')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout

          allow(subject).to receive(:gets).and_return('should error')
          expect { subject.unequip_armor }.to output(invalid_armor_unequip).to_stdout
        end
      end

      context "when valid answer is entered" do
        context "when already have armor equipped" do
          it 'un-equips armor' do
            subject.add_to_inventory(equipped_armor)
            expect(equipped_armor.equipped).to eq(true)
            allow(subject).to receive(:gets).and_return('1')
            subject.unequip_armor
            expect(equipped_armor.equipped).to eq(false)
            expect(subject.equipped_armor).not_to include(equipped_armor)
            expect(subject.equipped_armor).to be_empty
          end
          it 'prints out success message' do
            subject.add_to_inventory(equipped_armor)
            allow(subject).to receive(:gets).and_return('1')
            expect { subject.unequip_armor }.to output(/succesfully un-equipped/i).to_stdout
          end
        end
        context "when no armor is equipped" do
          it 'does not un-equip non-existent armor' do
            subject.add_to_inventory(armor)
            expect(armor.equipped).to eq(false)
            allow(subject).to receive(:gets).and_return('1')
            subject.unequip_armor
            expect(armor.equipped).to eq(false)
          end
        end
      end
    end
  end

  describe "#display_equipped_items" do
    let(:first_weapon_display_format) { /1\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:second_weapon_display_format) { /2\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:third_weapon_display_format) { /3\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

    let(:first_armor_display_format) { /1\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:second_armor_display_format) { /2\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:third_armor_display_format) { /3\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

    it 'is defined' do
      expect(subject).to respond_to(:display_equipped_items)
    end
    it 'displays header message' do
      expect { subject.display_equipped_items }.to output(/equipped items/i).to_stdout
    end

    context "when items are equipped" do
      context "when only weapons are equipped" do
        it 'displays empty message for armor' do
          expect { subject.display_equipped_items }.to output(/armor: empty/i).to_stdout
        end

        context "when one weapon is equipped" do
          it 'displays current equipped weapon' do
            subject.add_to_inventory(equipped_weapon)
            expect { subject.display_equipped_items }.to output(first_weapon_display_format).to_stdout
          end
        end

        context "when multiple weapons are equipped" do
          it 'displays all current equipped weapons' do
            subject.add_to_inventory(equipped_weapon)
            subject.add_to_inventory(equipped_weapon2)
            expect { subject.display_equipped_items }.to output(first_weapon_display_format).to_stdout
            expect { subject.display_equipped_items }.to output(second_weapon_display_format).to_stdout
            expect { subject.display_equipped_items }.not_to output(third_weapon_display_format).to_stdout
          end
        end
      end

      context "when only armor are equipped" do
        it 'displays empty message for weapons' do
          expect { subject.display_equipped_items }.to output(/weapon: empty/i).to_stdout
        end

        context "when one armor is equipped" do
          it 'displays current equipped armor' do
            subject.add_to_inventory(equipped_armor)
            expect { subject.display_equipped_items }.to output(first_armor_display_format).to_stdout
          end
        end

        context "when multiple armor are equipped" do
          it 'displays all current equipped armor' do
            subject.add_to_inventory(equipped_armor)
            subject.add_to_inventory(equipped_armor2)
            expect { subject.display_equipped_items }.to output(first_armor_display_format).to_stdout
            expect { subject.display_equipped_items }.to output(second_armor_display_format).to_stdout
            expect { subject.display_equipped_items }.not_to output(third_armor_display_format).to_stdout
          end
        end
      end

      context "when both weapons and armor are equipped" do
        before do
          subject.add_to_inventory(equipped_weapon)
          subject.add_to_inventory(equipped_armor)
        end
        it 'does not display empty weapon message' do
          expect { subject.display_equipped_items }.not_to output(/weapon: empty/i).to_stdout
        end
        it 'does not display empty armor message' do
          expect { subject.display_equipped_items }.not_to output(/armor: empty/i).to_stdout
        end
        it 'displays both equipped armor and weapons' do
          subject.add_to_inventory(equipped_weapon2)
          subject.add_to_inventory(equipped_armor2)

          expect { subject.display_equipped_items }.to output(first_weapon_display_format).to_stdout
          expect { subject.display_equipped_items }.to output(second_weapon_display_format).to_stdout
          expect { subject.display_equipped_items }.not_to output(third_weapon_display_format).to_stdout

          expect { subject.display_equipped_items }.to output(first_armor_display_format).to_stdout
          expect { subject.display_equipped_items }.to output(second_armor_display_format).to_stdout
          expect { subject.display_equipped_items }.not_to output(third_armor_display_format).to_stdout
        end
      end
    end

    context "when there are no equipped items" do
      it 'displays empty message for weapons' do
        expect { subject.display_equipped_items }.to output(/weapon: empty/i).to_stdout
      end
      it 'displays empty message for armor' do
        expect { subject.display_equipped_items }.to output(/armor: empty/i).to_stdout
      end
    end
  end
end
