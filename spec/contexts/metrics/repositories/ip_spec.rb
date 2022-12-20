describe Metrics::Repositories::Ip do
  describe '#create' do
    subject { described_class.new(connection: Container['database.connection']).create(ip, created_at) }

    let(:ip) { '192.168.0.1' }
    let(:created_at) { Time.now }

    context 'valid' do
      it 'returns id' do
        expect(subject).to be(1)
      end

      context 'ip v6' do
        let(:ip) { '684D:1111:222:3333:4444:5555:6:77' }

        it 'returns id' do
          expect(subject).to be(1)
        end
      end
    end

    context 'invalid' do
      context 'ip' do
        let(:ip) { '256.0.0.0' }

        it 'raises error' do
          expect{ subject }.to raise_error(Sequel::Error)
        end
      end

      context 'created_at' do
        let(:created_at) { '-1' }

        it 'raises error' do
          expect{ subject }.to raise_error(Sequel::Error)
        end
      end
    end
  end

  describe '#find' do
    subject { described_class.new(connection: Container['database.connection']).find(address) }

    let(:address) { '192.168.0.1' }

    context 'ip is created' do
      before do
        Container['database.connection'][:ips].insert(address:, created_at: Time.now)
      end

      it 'finds record' do
        expect(subject[:id]).to be(1)
      end

      it 'right address' do
        expect(subject[:address]).to eq(address)
      end
    end

    context "ip isn't created" do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'address is invalid' do
      let(:address) { '-1' }

      it 'raises error' do
        expect{ subject }.to raise_error(Sequel::Error)
      end
    end
  end

  describe '#all_addresses' do
    let(:repository) { described_class.new(connection: Container['database.connection']) }
    let(:address) { '192.168.0.1' }

    before do
      Container['database.connection'][:ips].insert(address:, created_at: Time.now)
    end

    it 'finds address' do
      repository.all_addresses { |row| expect(row).to eq(address) }
    end
  end
end
