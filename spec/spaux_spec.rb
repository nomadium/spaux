require 'spaux'

# to-do: improve tests
describe Spaux::Chef::Client do
  describe '#new' do
    it 'has a work dir' do
      client = Spaux::Chef::Client.new(Dir.mktmpdir)
      expect(client).to respond_to(:work_dir)
    end
    it 'has a chef config' do
      client = Spaux::Chef::Client.new(Dir.mktmpdir)
      expect(client).to respond_to(:config)
    end
    it 'has a spaux config' do
      client = Spaux::Chef::Client.new(Dir.mktmpdir)
      expect(client).to respond_to(:spaux_config)
    end
  end
end

#describe Spaux::Chef::Key

describe Spaux::CLI do
  describe '#converge' do
    xit 'prints "chef client" in stdout' do
      expect { Spaux::CLI.new.converge }.to output(/Starting Chef Client/).to_stdout
    end
  end
  describe '#savekey' do
    it 'prints private key in stdout' do
      expect { Spaux::CLI.new.savekey }.to output(/^-----BEGIN RSA PRIVATE KEY-----/).to_stdout
    end
  end
end
