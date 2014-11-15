require 'spaux'

describe Spaux do
  describe '#whatever' do
    it 'returns whatever' do
      spaux = Spaux.new
      expect(spaux.whatever).to eq 'whatever'
    end
  end
end

describe Spaux::Chef::Client do
  describe '#new' do
    it 'has a work dir' do
      client = Spaux::Chef::Client.new
      expect(client).to respond_to(:work_dir)
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
