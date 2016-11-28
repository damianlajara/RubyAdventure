describe 'Inventory mixin' do
  subject { Hero.new }
  let(:weapon) { Weapon.new('a knife') }
  let(:armor) { Armor.new('a helmet') }
  let(:potion) { Potion.new('a potion') }

  context '#add_to_inventory' do
    it 'is defined' do
      expect(subject).to respond_to(:add_to_inventory)
    end

    context 'when passed an item' do
      context 'when invalid' do
        it 'returns false' do
          expect(subject.add_to_inventory({})).to eq(false)
          expect(subject.add_to_inventory('')).to eq(false)
          expect(subject.add_to_inventory('123412')).to eq(false)
          expect(subject.add_to_inventory('!@#%#')).to eq(false)
          expect(subject.add_to_inventory(9876)).to eq(false)
          expect(subject.add_to_inventory(not_valid: 'hi')).to eq(false)
          expect(subject.add_to_inventory([])).to eq(false)
        end
      end

      context 'when valid' do
        context "when item doesn't already exist (new item)" do
          it 'adds item to inventory' do
            expect(subject.inventory[:current_weapons]).to be_empty
            subject.add_to_inventory(weapon)
            expect(subject.inventory[:current_weapons]).not_to be_empty

            expect(subject.inventory[:current_armor]).to be_empty
            subject.add_to_inventory(armor)
            expect(subject.inventory[:current_armor]).not_to be_empty

            expect(subject.inventory[:current_potions]).to be_empty
            subject.add_to_inventory(potion)
            expect(subject.inventory[:current_potions]).not_to be_empty
          end
          it 'does not modify rest of inventory' do
            expect(subject.inventory[:current_armor]).to be_empty
            expect(subject.inventory[:current_weapons]).to be_empty
            expect(subject.inventory[:current_potions]).to be_empty

            expect(subject.add_to_inventory(weapon)).to eq(true)
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_weapons].count).to eq(1)
            expect(subject.inventory[:current_armor]).to be_empty
            expect(subject.inventory[:current_potions]).to be_empty

            expect(subject.add_to_inventory(armor)).to eq(true)
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_weapons].count).to eq(1)
            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_armor].count).to eq(1)
            expect(subject.inventory[:current_potions]).to be_empty

            expect(subject.add_to_inventory(potion)).to eq(true)
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_weapons].count).to eq(1)
            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_armor].count).to eq(1)
            expect(subject.inventory[:current_potions]).not_to be_empty
            expect(subject.inventory[:current_potions].count).to eq(1)
          end
          it 'returns true' do
            expect(subject.add_to_inventory(weapon)).to eq(true)
            expect(subject.add_to_inventory(Weapon.new('a shovel'))).to eq(true)

            expect(subject.add_to_inventory(armor)).to eq(true)
            expect(subject.add_to_inventory(Armor.new('a shoe'))).to eq(true)

            expect(subject.add_to_inventory(potion)).to eq(true)
            expect(subject.add_to_inventory(Potion.new('lemonade'))).to eq(true)
          end
        end

        context 'when item already exists (duplicate item)' do
          it 'does not add to inventory' do
            subject.add_to_inventory(weapon)
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_weapons].count).to eq(1)
            expect(subject.add_to_inventory(weapon)).to eq(false)
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_weapons].count).to eq(1)

            subject.add_to_inventory(armor)
            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_armor].count).to eq(1)
            expect(subject.add_to_inventory(armor)).to eq(false)
            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_armor].count).to eq(1)

            subject.add_to_inventory(potion)
            expect(subject.inventory[:current_potions]).not_to be_empty
            expect(subject.inventory[:current_potions].count).to eq(1)
            expect(subject.add_to_inventory(potion)).to eq(false)
            expect(subject.inventory[:current_potions]).not_to be_empty
            expect(subject.inventory[:current_potions].count).to eq(1)
          end
          it 'returns false' do
            expect(subject.add_to_inventory(weapon)).to eq(true)
            expect(subject.add_to_inventory(armor)).to eq(true)
            expect(subject.add_to_inventory(potion)).to eq(true)

            expect(subject.add_to_inventory(weapon)).to eq(false)
            expect(subject.add_to_inventory(armor)).to eq(false)
            expect(subject.add_to_inventory(potion)).to eq(false)
          end
        end
      end
    end
  end

  context '#remove_from_inventory' do
    it 'is defined' do
      expect(subject).to respond_to(:remove_from_inventory)
    end

    context 'when passed an item' do
      context 'when invalid' do
        it 'returns false' do
          expect(subject.remove_from_inventory({})).to eq(false)
          expect(subject.remove_from_inventory('')).to eq(false)
          expect(subject.remove_from_inventory('123412')).to eq(false)
          expect(subject.remove_from_inventory('!@#%#')).to eq(false)
          expect(subject.remove_from_inventory(9876)).to eq(false)
          expect(subject.remove_from_inventory(not_valid: 'hi')).to eq(false)
          expect(subject.remove_from_inventory([])).to eq(false)
        end
      end

      context 'when valid' do
        context 'when item already exists' do
          it 'removes item from inventory' do
            subject.add_to_inventory(weapon)

            expect(subject.inventory[:current_weapons]).not_to be_empty
            subject.remove_from_inventory(weapon)
            expect(subject.inventory[:current_weapons]).to be_empty
            subject.remove_from_inventory(weapon)
            expect(subject.inventory[:current_weapons]).to be_empty

            subject.add_to_inventory(armor)

            expect(subject.inventory[:current_armor]).not_to be_empty
            subject.remove_from_inventory(armor)
            expect(subject.inventory[:current_armor]).to be_empty
            subject.remove_from_inventory(armor)
            expect(subject.inventory[:current_armor]).to be_empty

            subject.add_to_inventory(potion)

            expect(subject.inventory[:current_potions]).not_to be_empty
            subject.remove_from_inventory(potion)
            expect(subject.inventory[:current_potions]).to be_empty
            subject.remove_from_inventory(potion)
            expect(subject.inventory[:current_potions]).to be_empty
          end
          it 'does not modify rest of inventory' do
            subject.add_to_inventory(weapon)
            subject.add_to_inventory(armor)
            subject.add_to_inventory(potion)

            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_weapons]).not_to be_empty
            expect(subject.inventory[:current_potions]).not_to be_empty

            expect(subject.remove_from_inventory(weapon)).to eq(true)
            expect(subject.inventory[:current_weapons]).to be_empty
            expect(subject.inventory[:current_armor]).not_to be_empty
            expect(subject.inventory[:current_armor].count).to eq(1)
            expect(subject.inventory[:current_potions]).not_to be_empty
            expect(subject.inventory[:current_potions].count).to eq(1)

            expect(subject.remove_from_inventory(armor)).to eq(true)
            expect(subject.inventory[:current_weapons]).to be_empty
            expect(subject.inventory[:current_armor]).to be_empty
            expect(subject.inventory[:current_potions]).not_to be_empty
            expect(subject.inventory[:current_potions].count).to eq(1)

            expect(subject.remove_from_inventory(potion)).to eq(true)
            expect(subject.inventory[:current_weapons]).to be_empty
            expect(subject.inventory[:current_armor]).to be_empty
            expect(subject.inventory[:current_potions]).to be_empty
          end
          it 'returns true' do
            subject.add_to_inventory(weapon)
            subject.add_to_inventory(armor)
            subject.add_to_inventory(potion)

            expect(subject.remove_from_inventory(weapon)).to eq(true)
            expect(subject.remove_from_inventory(armor)).to eq(true)
            expect(subject.remove_from_inventory(potion)).to eq(true)
          end
        end

        context "when item doesn't already exist (new item)" do
          it 'does not add to inventory' do
            expect(subject.remove_from_inventory(weapon)).to eq(false)
            expect(subject.inventory[:current_weapons]).to be_empty

            expect(subject.remove_from_inventory(armor)).to eq(false)
            expect(subject.inventory[:current_armor]).to be_empty

            expect(subject.remove_from_inventory(potion)).to eq(false)
            expect(subject.inventory[:current_potions]).to be_empty
          end
          it 'returns false' do
            expect(subject.remove_from_inventory(weapon)).to eq(false)
            expect(subject.remove_from_inventory(armor)).to eq(false)
            expect(subject.remove_from_inventory(potion)).to eq(false)
          end
        end
      end
    end
  end

  context '#current_inventory_weapons' do
    let(:broom) { Weapon.new('a broom').tap { |i| i.equipped = true } }
    let(:bat) { Weapon.new('a bat').tap { |i| i.equipped = true } }
    let(:hangar) { Weapon.new('a hangar') }

    it 'is defined' do
      expect(subject).to respond_to(:current_inventory_weapons)
    end
    it 'filters and selects weapons that are not equipped' do
      subject.add_to_inventory(weapon)
      subject.add_to_inventory(broom)
      subject.add_to_inventory(bat)
      subject.add_to_inventory(hangar)

      expect(subject.current_inventory_weapons).not_to be_empty
      expect(subject.current_inventory_weapons.count).to eq(2)
      expect(subject.current_inventory_weapons.map(&:name)).to include('a hangar', 'a knife')
    end
    it 'returns an empty array when inventory is empty' do
      subject.add_to_inventory(broom)
      subject.add_to_inventory(bat)
      expect(subject.current_inventory_weapons).to be_empty
    end
  end

  context '#current_inventory_armor' do
    let(:jacket) { Armor.new('a jacket').tap { |i| i.equipped = true } }
    let(:hat) { Armor.new('a hat').tap { |i| i.equipped = true } }
    let(:ring) { Armor.new('a ring') }

    it 'is defined' do
      expect(subject).to respond_to(:current_inventory_armor)
    end
    it 'filters and selects armor that are not equipped' do
      subject.add_to_inventory(armor)
      subject.add_to_inventory(jacket)
      subject.add_to_inventory(hat)
      subject.add_to_inventory(ring)

      expect(subject.current_inventory_armor).not_to be_empty
      expect(subject.current_inventory_armor.count).to eq(2)
      expect(subject.current_inventory_armor.map(&:name)).to include('a ring', 'a helmet')
    end
    it 'returns an empty array when inventory is empty' do
      subject.add_to_inventory(jacket)
      subject.add_to_inventory(hat)
      expect(subject.current_inventory_armor).to be_empty
    end
  end

  context '#current_inventory_potions' do
    let(:soup) { Potion.new('chicken noodle soup') }
    let(:empanada) { Potion.new('crispy empanada') }
    let(:quipe) { Potion.new('se nota que soy dominicano') }

    it 'is defined' do
      expect(subject).to respond_to(:current_inventory_potions)
    end
    it 'selects all available potions' do
      subject.add_to_inventory(potion)
      subject.add_to_inventory(soup)
      subject.add_to_inventory(empanada)
      subject.add_to_inventory(quipe)

      expect(subject.current_inventory_potions).not_to be_empty
      expect(subject.current_inventory_potions.count).to eq(4)
      expect(subject.current_inventory_potions.map(&:name)).to include('a potion', 'chicken noodle soup', 'crispy empanada', 'se nota que soy dominicano')
    end
    it 'returns an empty array when inventory is empty' do
      expect(subject.current_inventory_potions).to be_empty
    end
  end

  context '#inventory_empty?' do
    it 'is defined' do
      expect(subject).to respond_to(:inventory_empty?)
    end

    context 'when all inventory weapons, armor and potions are empty' do
      it 'returns true' do
        expect(subject.inventory_empty?).to eq(true)
      end
    end

    context 'when any inventory weapons, armor and potions have items' do
      it 'returns false' do
        subject.add_to_inventory(weapon)
        expect(subject.inventory_empty?).to eq(false)

        subject.add_to_inventory(armor)
        expect(subject.inventory_empty?).to eq(false)

        subject.add_to_inventory(potion)
        expect(subject.inventory_empty?).to eq(false)

        subject.remove_from_inventory(weapon)
        expect(subject.inventory_empty?).to eq(false)

        subject.remove_from_inventory(armor)
        expect(subject.inventory_empty?).to eq(false)

        subject.remove_from_inventory(potion)
        expect(subject.inventory_empty?).to eq(true)
      end
    end
  end

  context '#display_inventory_weapons' do
    let(:first_weapon_display_format) { /1\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:second_weapon_display_format) { /2\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:third_weapon_display_format) { /3\) \w+[\s\w]+damage: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

    context 'when inventory is empty' do
      it 'prints out empty' do
        expect { subject.display_inventory_weapons }.to output(/empty/i).to_stdout
      end
    end

    context 'when inventory has one item' do
      it 'prints out current weapon' do
        subject.add_to_inventory(weapon)
        expect { subject.display_inventory_weapons }.to output(first_weapon_display_format).to_stdout
      end
    end

    context 'when inventory has multiple items' do
      it 'prints out all weapons in inventory' do
        subject.add_to_inventory(weapon)
        subject.add_to_inventory(Weapon.new('a scissor'))
        expect { subject.display_inventory_weapons }.to output(first_weapon_display_format).to_stdout
        expect { subject.display_inventory_weapons }.to output(second_weapon_display_format).to_stdout
        expect { subject.display_inventory_weapons }.not_to output(third_weapon_display_format).to_stdout
      end
    end
  end

  context '#display_inventory_armor' do
    let(:first_armor_display_format) { /1\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:second_armor_display_format) { /2\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:third_armor_display_format) { /3\) \w+[\s\w]+defense: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

    context 'when inventory is empty' do
      it 'prints out empty' do
        expect { subject.display_inventory_armor }.to output(/empty/i).to_stdout
      end
    end

    context 'when inventory has one item' do
      it 'prints out current armor' do
        subject.add_to_inventory(armor)
        expect { subject.display_inventory_armor }.to output(first_armor_display_format).to_stdout
      end
    end

    context 'when inventory has multiple items' do
      it 'prints out all armor in inventory' do
        subject.add_to_inventory(armor)
        subject.add_to_inventory(Armor.new('a coat'))
        expect { subject.display_inventory_armor }.to output(first_armor_display_format).to_stdout
        expect { subject.display_inventory_armor }.to output(second_armor_display_format).to_stdout
        expect { subject.display_inventory_armor }.not_to output(third_armor_display_format).to_stdout
      end
    end
  end

  context '#display_inventory_potions' do
    let(:first_potion_display_format) { /1\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:second_potion_display_format) { /2\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }
    let(:third_potion_display_format) { /3\) \w+[\s\w]+health: \d+\s+price: \d+\s+sell_value: \d+\s+description:[\s\w]+/i }

    context 'when inventory is empty' do
      it 'prints out empty' do
        expect { subject.display_inventory_potions }.to output(/empty/i).to_stdout
      end
    end

    context 'when inventory has one item' do
      it 'prints out current potion' do
        subject.add_to_inventory(potion)
        expect { subject.display_inventory_potions }.to output(first_potion_display_format).to_stdout
      end
    end

    context 'when inventory has multiple items' do
      it 'prints out all potions in inventory' do
        subject.add_to_inventory(potion)
        subject.add_to_inventory(Potion.new('a water bottle'))
        expect { subject.display_inventory_potions }.to output(first_potion_display_format).to_stdout
        expect { subject.display_inventory_potions }.to output(second_potion_display_format).to_stdout
        expect { subject.display_inventory_potions }.not_to output(third_potion_display_format).to_stdout
      end
    end
  end

  context '#display_inventory_items' do
    it 'calls display_inventory_weapons, display_inventory_armor and display_inventory_potions' do
      expect(subject).to receive(:display_inventory_weapons)
      expect(subject).to receive(:display_inventory_armor)
      expect(subject).to receive(:display_inventory_potions)
      subject.display_inventory_items
    end
  end
end
