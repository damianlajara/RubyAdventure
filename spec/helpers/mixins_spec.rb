describe Display do
  describe "#choose_array_option" do
    subject { Class.new { include Display }.new }
    let(:invalid_options) { ["0", "5", "", "jhg", "100", "-5"] }
    let(:options) { %w(item1 item2 item3 item4) }

    it "is defined" do
      expect(subject).to respond_to(:choose_array_option)
    end

    it "raises error when array passed in is empty" do
      expect { subject.choose_array_option([], true) }.to raise_error
    end

    context "when argument result_as_num is passed in as true" do
      it "returns valid option as num" do
        allow(subject).to receive(:gets).once.and_return("1", "2", "3", "4")
        expect(subject.choose_array_option(options, true)).to eq 1
        expect(subject.choose_array_option(options, true)).to eq 2
        expect(subject.choose_array_option(options, true)).to eq 3
        expect(subject.choose_array_option(options, true)).to eq 4
      end

      it "defaults to 1 when invalid options entered" do
        allow(subject).to receive(:gets).once.and_return(*invalid_options)
        invalid_options.count.times do
          expect(subject.choose_array_option(options, true)).to eq 1
        end
      end
    end

    context "when argument result_as_num is passed in as false" do
      it "returns valid array item from array" do
        allow(subject).to receive(:gets).once.and_return("1", "2", "3", "4")
        expect(subject.choose_array_option(options, false)).to eq "item1"
        expect(subject.choose_array_option(options, false)).to eq "item2"
        expect(subject.choose_array_option(options, false)).to eq "item3"
        expect(subject.choose_array_option(options, false)).to eq "item4"
      end

      it "defaults to first array item when invalid options entered" do
        allow(subject).to receive(:gets).once.and_return(*invalid_options)
        invalid_options.count.times do
          expect(subject.choose_array_option(options, false)).to eq "item1"
        end
      end
    end

    context "when argument result_as_num is ommitted." do
      it "defaults to false" do
        allow(subject).to receive(:gets).once.and_return("1", "2", "3", "4")
        expect(subject.choose_array_option(options)).to eq "item1"
        expect(subject.choose_array_option(options)).to eq "item2"
        expect(subject.choose_array_option(options)).to eq "item3"
        expect(subject.choose_array_option(options)).to eq "item4"
      end

      it "defaults to first array item when invalid options entered" do
        allow(subject).to receive(:gets).once.and_return(*invalid_options)
        invalid_options.count.times do
          expect(subject.choose_array_option(options)).to eq "item1"
        end
      end
    end

  end
end
