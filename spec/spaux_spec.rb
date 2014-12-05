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
#describe Spaux::Chef::Knife
#describe Spaux::CLI::SSHSubcommand

describe Spaux::CLI do
  describe '#converge' do
    it 'prints "chef client" in stdout' do
      begin
        spaux = Spaux::CLI.new
      rescue SystemExit
        expect { spaux.converge }.to output(/Starting Chef Client/).to_stdout
      end
    end
  end
  describe '#savekey' do
    it 'prints private key in stdout' do
      expect { Spaux::CLI.new.savekey }.to output(/^-----BEGIN RSA PRIVATE KEY-----/).to_stdout
    end
  end
  describe '#knife' do
    it 'prints expect knife output in stdout' do
      begin
        spaux = Spaux::CLI.new
      rescue SystemExit
        expect { spaux.knife("help", "list") }.to output(/help topics/).to_stdout
      end
    end
  end
end
