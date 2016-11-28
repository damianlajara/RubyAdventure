describe 'customize mixin' do
  subject { Hero.new }
  let(:full_hero) do
    Hero.new(
      health: 110,
      level: 1,
      attack: 50,
      defense: 50,
      money: 100,
      experience: 50,
      description: 'My custom hero'
    )
  end
  
  context '#customize' do
    it 'is defined' do
      expect(subject).to respond_to(:customize)
    end
    it 'calls #customize_name' do
      expect(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:customize_name).once
      subject.customize
    end
    it 'calls #customize_gender' do
      expect(subject).to receive(:gets).exactly(1).times.and_return('')
      expect(subject).to receive(:customize_gender).once
      subject.customize
    end
    it 'displays welcome message' do
      expect(subject).to receive(:gets).at_least(:once).and_return('')
      expect { subject.customize }.to output(/welcome/).to_stdout
    end
  end

  context '#customize_name' do
    it 'is defined' do
      expect(subject).to respond_to(:customize_name)
    end
    context 'when invoked' do
      it 'displays message asking to choose name' do
        expect(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.customize_name }.to output(/what would you like your character to be called/i).to_stdout
      end
    end
    context 'when invalid option is entered' do
      it 'reverts to default name' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('')
        subject.customize_name
        expect(subject.name).to eq('Nameless One')

        expect(subject).to receive(:gets).exactly(1).times.and_return('123')
        subject.customize_name
        expect(subject.name).to eq('Nameless One')

        expect(subject).to receive(:gets).exactly(1).times.and_return('asd123')
        subject.customize_name
        expect(subject.name).to eq('Nameless One')

        expect(subject).to receive(:gets).exactly(1).times.and_return('\n')
        subject.customize_name
        expect(subject.name).to eq('Nameless One')

        expect(subject).to receive(:gets).exactly(1).times.and_return('_!@#')
        subject.customize_name
        expect(subject.name).to eq('Nameless One')
      end
    end

    context 'when valid option is entered' do
      it 'updates name' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('Damian')
        subject.customize_name
        expect(subject.name).to eq('Damian')
      end
    end
  end

  context '#customize_gender' do
    it 'is defined' do
      expect(subject).to respond_to(:customize_gender)
    end

    context 'when invoked' do
      it 'displays message asking to choose gender' do
        expect(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.customize }.to output(/what is your gender/i).to_stdout
      end
    end

    context 'when 1 (male gender) is selected' do
      it 'returns Male' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('1')
        subject.customize_gender
        expect(subject.gender).to eq('Male')
      end
    end

    context 'when 2 (female gender) is selected' do
      it 'returns Female' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('2')
        subject.customize_gender
        expect(subject.gender).to eq('Female')
      end
    end

    context 'when 3 (custom gender) is selected' do
      it 'returns custom gender' do
        expect(subject).to receive(:gets).exactly(2).times.and_return('3', 'Genderfluid')
        subject.customize_gender
        expect(subject.gender).to eq('Genderfluid')
      end
    end

    context 'when invalid custom gender is entered' do
      it 'defaults to Other' do
        expect(subject).to receive(:gets).exactly(2).times.and_return('3', '')
        subject.customize_gender
        expect(subject.gender).to eq('Other')

        expect(subject).to receive(:gets).exactly(2).times.and_return('3', '123')
        subject.customize_gender
        expect(subject.gender).to eq('Other')

        expect(subject).to receive(:gets).exactly(2).times.and_return('3', '@#$!')
        subject.customize_gender
        expect(subject.gender).to eq('Other')

        expect(subject).to receive(:gets).exactly(2).times.and_return('3', '   \n invalid ')
        subject.customize_gender
        expect(subject.gender).to eq('Other')

        expect(subject).to receive(:gets).exactly(2).times.and_return('3', '   whitespace  doesn\'t matter   ')
        subject.customize_gender
        expect(subject.gender).to eq('Other')
      end
    end

    context 'when invalid option is entered' do
      it 'defaults to Genderless' do
        expect(subject).to receive(:gets).exactly(1).times.and_return('')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')

        expect(subject).to receive(:gets).exactly(1).times.and_return('\n another one   !')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')

        expect(subject).to receive(:gets).exactly(1).times.and_return('@#$%!')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')

        expect(subject).to receive(:gets).exactly(1).times.and_return('123')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')

        expect(subject).to receive(:gets).exactly(1).times.and_return('4')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')
      end
    end
  end

  context '#reset_stats_after_death' do
    it 'is defined' do
      expect(subject).to respond_to(:reset_stats_after_death)
    end

    context 'when hero dies' do
      it 'resets to default attributes' do
        full_hero.reset_stats_after_death
        expect(full_hero).to have_attributes(
          health: 110,
          max_hp: 110,
          money: 0,
          experience: 0,
          inventory: {
            current_potions: [],
            current_armor: [],
            current_weapons: []
          },
          equipped_weapons: [],
          equipped_armor: []
        )
      end
      it 'resets health to max_hp' do
        full_hero.max_hp = 150
        full_hero.reset_stats_after_death
        expect(full_hero).to have_attributes(
          health: 150
        )
      end
      it 'still retains base attributes' do
        full_hero.reset_stats_after_death
        expect(full_hero).to have_attributes(
          health: 110,
          max_hp: 110,
          attack: 50,
          defense: 50,
          description: 'My custom hero'
        )
      end
    end
  end

  context '#change_name' do
    it 'is defined' do
      expect(subject).to respond_to(:change_name)
    end

    context 'when invoked' do
      it 'displays confirmation message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.change_name }.to output(/Are you sure you want to change your name?/i).to_stdout
        expect { subject.change_name }.to output(/1\) yes/i).to_stdout
        expect { subject.change_name }.to output(/2\) no/i).to_stdout
      end
    end

    context 'when 1 (yes) is selected' do
      it 'calls #customize_name' do
        allow(subject).to receive(:gets).at_least(:once).and_return('1')
        expect(subject).to receive(:customize_name).once
        subject.change_name
      end
      it 'displays success message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('1')
        expect { subject.change_name }.to output(/congratulations/i).to_stdout
      end
    end
    context 'when 2 (no) or invalid option is selected' do
      let(:awww_man) { /awww man/i }
      it 'displays error message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('2')
        expect { subject.change_name }.to output(awww_man).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('90')
        expect { subject.change_name }.to output(awww_man).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.change_name }.to output(awww_man).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
        expect { subject.change_name }.to output(awww_man).to_stdout
      end
    end
  end

  context '#change_gender' do
    it 'is defined' do
      expect(subject).to respond_to(:change_gender)
    end

    context 'when invoked' do
      it 'displays confirmation message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.change_gender }.to output(/Are you sure you want to change your gender?/i).to_stdout
        expect { subject.change_gender }.to output(/1\) yes/i).to_stdout
        expect { subject.change_gender }.to output(/2\) no/i).to_stdout
      end
    end

    context 'when 1 (yes) is selected' do
      it 'calls #customize_gender' do
        allow(subject).to receive(:gets).at_least(:once).and_return('1')
        expect(subject).to receive(:customize_gender).once
        subject.change_gender
      end
      it 'displays success message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('1')
        expect { subject.change_gender }.to output(/congratulations/i).to_stdout
      end
    end

    context 'when 2 (no) or invalid option is selected' do
      let(:hmmm) { /hmmm/i }
      it 'displays error message' do
        allow(subject).to receive(:gets).at_least(:once).and_return('2')
        expect { subject.change_gender }.to output(hmmm).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('90')
        expect { subject.change_gender }.to output(hmmm).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('')
        expect { subject.change_gender }.to output(hmmm).to_stdout

        allow(subject).to receive(:gets).at_least(:once).and_return('!@#$')
        expect { subject.change_gender }.to output(hmmm).to_stdout
      end
    end
  end

  context '#toggle_battle_scenes' do
    let(:toggle) { !subject.skip_battle_scenes ? 'disable' : 'enable' }
    let(:untoggled) { subject.skip_battle_scenes ? 'disable' : 'enable' }

    it 'is defined' do
      expect(subject).to respond_to(:toggle_battle_scenes)
    end

    it 'displays confirmation message' do
      allow(subject).to receive(:gets).and_return('')
      expect { subject.toggle_battle_scenes }.to output(/Do you want to #{toggle} all of the battle scenes?/i).to_stdout
    end

    context 'when 1 (yes) is selected' do
      it 'displays confirmation message' do
        expect(subject).to receive(:gets).and_return('1')
        expect { subject.toggle_battle_scenes }.to output(/Battle scenes have been #{toggle}d./i).to_stdout
      end

      context 'when invoked for the first time' do
        it 'skips battle scenes' do
          expect(subject).to receive(:gets).and_return('1')
          subject.toggle_battle_scenes
          expect(subject.skip_battle_scenes).to eq(true)
        end
      end

      context 'when invoked multiple times' do
        it 'remembers previous state and toggles battle scenes' do
          allow(subject).to receive(:gets).and_return('1')
          subject.toggle_battle_scenes
          expect(subject).to receive(:gets).and_return('1')
          subject.toggle_battle_scenes
          expect(subject.skip_battle_scenes).to eq(false)
        end
      end
    end

    context 'when 2 (no) is selected' do
      it 'displays confirmation message' do
        expect(subject).to receive(:gets).and_return('2')
        expect { subject.toggle_battle_scenes }.to output(/Battle scenes will stay #{untoggled}d./i).to_stdout
      end

      context 'when invoked for the first time' do
        it 'stays with default value' do
          expect(subject).to receive(:gets).and_return('2')
          subject.toggle_battle_scenes
          expect(subject.skip_battle_scenes).to eq(false)
        end
      end

      context 'when invoked multiple times' do
        it 'reverts to previous state' do
          allow(subject).to receive(:gets).and_return('1')
          subject.toggle_battle_scenes
          expect(subject).to receive(:gets).and_return('2')
          subject.toggle_battle_scenes
          expect(subject.skip_battle_scenes).to eq(true)
        end
      end
    end
  end

  context '#game_options' do
    it 'is defined' do
      expect(subject).to respond_to(:game_options)
    end
    it 'displays header message' do
      allow(subject).to receive(:gets).and_return('')
      expect { subject.game_options }.to output(/game options/i).to_stdout
    end
    it 'displays game options' do
      allow(subject).to receive(:gets).and_return('')
      expect { subject.game_options }.to output(/1\) change name/i).to_stdout
      expect { subject.game_options }.to output(/2\) change gender/i).to_stdout
      expect { subject.game_options }.to output(/3\) toggle battle scenes/i).to_stdout
    end

    context 'when 1 (change name) is selected' do
      it 'calls change_name' do
        allow(subject).to receive(:gets).and_return('1')
        expect(subject).to receive(:change_name).once
        subject.game_options
      end
    end

    context 'when 2 (change gender) is selected' do
      it 'calls change_gender' do
        allow(subject).to receive(:gets).and_return('2')
        expect(subject).to receive(:change_gender).once
        subject.game_options
      end
    end

    context 'when 3 (toggle battle scenes) is selected' do
      it 'calls toggle_battle_scenes' do
        allow(subject).to receive(:gets).and_return('3')
        expect(subject).to receive(:toggle_battle_scenes).once
        subject.game_options
      end
    end

    context 'when invalid option is entered' do
      let(:invalid) { /invalid option/i }
      let(:exiting) { /exiting/i }

      it 'displays error message' do
        allow(subject).to receive(:gets).and_return('')
        expect { subject.game_options }.to output(invalid).to_stdout

        allow(subject).to receive(:gets).and_return('123')
        expect { subject.game_options }.to output(invalid).to_stdout

        allow(subject).to receive(:gets).and_return('!@#$')
        expect { subject.game_options }.to output(invalid).to_stdout

        allow(subject).to receive(:gets).and_return('something')
        expect { subject.game_options }.to output(invalid).to_stdout

        allow(subject).to receive(:gets).and_return('invalid options')
        expect { subject.game_options }.to output(invalid).to_stdout
      end
      it 'displays exiting menu message' do
        allow(subject).to receive(:gets).and_return('')
        expect { subject.game_options }.to output(exiting).to_stdout

        allow(subject).to receive(:gets).and_return('123')
        expect { subject.game_options }.to output(exiting).to_stdout

        allow(subject).to receive(:gets).and_return('!@#$')
        expect { subject.game_options }.to output(exiting).to_stdout

        allow(subject).to receive(:gets).and_return('something')
        expect { subject.game_options }.to output(exiting).to_stdout

        allow(subject).to receive(:gets).and_return('invalid options')
        expect { subject.game_options }.to output(exiting).to_stdout
      end
    end
  end
end
