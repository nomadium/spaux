require 'spaux'

describe Spaux do
  describe '#whatever' do
    it 'returns whatever' do
      spaux = Spaux.new
      expect(spaux.whatever).to eq 'whatever'
    end
  end
end

describe Spaux::CLI do
  describe '#whatever' do
    it 'prints "whatever" in stdout' do
      expect { Spaux::CLI.new.whatever }.to output("whatever\n").to_stdout
    end
  end
end
