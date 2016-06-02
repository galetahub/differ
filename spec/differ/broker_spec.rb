require 'spec_helper'

describe Differ::Broker do
  let(:string1) { File.read(Differ.root_path.join('spec/factories/files/file1.txt')) }
  let(:sometext) { 'New line here' }
  let(:someline) { "#{sometext}\n" }

  context 'compare not changed files' do
    let(:broker) { described_class.new(string1, string1) }

    it 'must create unchanged lines' do
      expect {
        broker.compare
      }.to change { broker.lines.size }.by(string1.lines.size)

      string1.lines.each_with_index do |line, index|
        expect(broker.lines[index].state).to eq :unchanged
        expect(broker.lines[index].value).to eq line
        expect(broker.lines[index].position).to eq index
      end
    end
  end

  context 'compare files with new line' do
    let(:broker) { described_class.new(string1, string2) }

    context 'at start' do
      let(:string2) { someline + string1 }

      it 'must create insert line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size + 1)

        expect(broker.lines.first.state).to eq :insert
        expect(broker.lines.first.value).to eq someline
      end
    end

    context 'at middle' do
      let(:string2) { string1.lines.insert(2, someline).join }

      it 'must create insert line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size + 1)

        expect(broker.lines[2].state).to eq :insert
        expect(broker.lines[2].value).to eq someline
      end
    end

    context 'at end' do
      let(:string2) { string1 + "#{sometext}" }

      it 'must create insert line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size + 1)

        expect(broker.lines.last.state).to eq :insert
        expect(broker.lines.last.value).to eq sometext
      end
    end
  end

  context 'compare files with deleted line' do
    let(:broker) { described_class.new(string1, string2) }

    context 'at start' do
      let(:string2) { string1.lines[1..-1].join }

      it 'must create delete line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size)

        expect(broker.lines.first.value).to eq string1.lines[0]
        expect(broker.lines.first.state).to eq :deleted
      end
    end

    context 'at middle' do
      let(:string2) { File.read(Differ.root_path.join('spec/factories/files/file3.txt')) }

      it 'must create delete line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size)

        expect(broker.lines[2].value).to eq string1.lines[2]
        expect(broker.lines[2].state).to eq :deleted
      end
    end

    context 'at end' do
      let(:string2) { string1.lines[0..-2].join }

      it 'must create delete line' do
        expect {
          broker.compare
        }.to change { broker.lines.size }.by(string1.lines.size)

        expect(broker.lines.last.value).to eq string1.lines.last
        expect(broker.lines.last.state).to eq :deleted
      end
    end
  end

  context 'compare two files' do
    let(:string2) { File.read(Differ.root_path.join('spec/factories/files/file2.txt')) }
    let(:broker) { described_class.new(string1, string2) }

    it 'must build lines with states' do
      expect {
        broker.compare
      }.to change { broker.lines.size }.by(7)

      expect(broker.lines[0].value).to eq "Some\n|Another\n"
      expect(broker.lines[0].state).to eq :changed

      expect(broker.lines[1].value).to eq "Simple\n"
      expect(broker.lines[1].state).to eq :deleted

      expect(broker.lines[2].value).to eq "Text\n"
      expect(broker.lines[2].state).to eq :unchanged

      expect(broker.lines[3].value).to eq "File\n"
      expect(broker.lines[3].state).to eq :unchanged

      expect(broker.lines[4].value).to eq "With\n"
      expect(broker.lines[4].state).to eq :insert

      expect(broker.lines[5].value).to eq "Additional\n"
      expect(broker.lines[5].state).to eq :insert

      expect(broker.lines[6].value).to eq "Lines\n"
      expect(broker.lines[6].state).to eq :insert
    end
  end
end
