require 'spaux'

describe Spaux do
  describe '#whatever' do
    it 'returns whatever' do
      spaux = Spaux.new
      expect(spaux.whatever).to eq 'whatever'
    end
  end
end
