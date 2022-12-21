describe Metrics::Repositories::Ip do
  let(:address) { '192.168.0.1' }

  describe '#create' do
    subject { described_class.new(connection: Container['database.connection']).create(address, created_at) }

    let(:created_at) { Time.now }

    context 'valid' do
      it 'returns id' do
        expect(subject).to be(1)
      end

      context 'ip v6' do
        let(:address) { '684D:1111:222:3333:4444:5555:6:77' }

        it 'returns id' do
          expect(subject).to be(1)
        end
      end
    end

    context 'invalid' do
      context 'address' do
        let(:address) { '256.0.0.0' }

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

    context 'ip is deleted' do
      before do
        Container['database.connection'][:ips].insert(address:, created_at: Time.now, deleted_at: Time.now)
      end

      it "doesn't find record" do
        expect(subject).to be_nil
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

  describe '#find_with_deleted' do
    subject { described_class.new(connection: Container['database.connection']).find_with_deleted(address) }

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

    context 'ip is deleted' do
      before do
        Container['database.connection'][:ips].insert(address:, created_at: Time.now, deleted_at: Time.now)
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

  describe '#delete' do
    subject { described_class.new(connection: Container['database.connection']).delete(1, deleted_at) }

    let(:deleted_at) { Time.now }

    before do
      Container['database.connection'][:ips].insert(address:, created_at: Time.now)
    end

    it 'updates deleted_at' do
      expect do
        subject
      end.to change { Container['database.connection'][:ips].where(address: address).first[:deleted_at]&.to_s }
           .from(nil)
           .to(deleted_at.to_s)
    end
  end

  describe '#all_addresses' do
    let(:repository) { described_class.new(connection: Container['database.connection']) }

    before do
      Container['database.connection'][:ips].insert(address:, created_at: Time.now)
    end

    it 'finds address' do
      repository.all_addresses { |row| expect(row).to eq(address) }
    end
  end
end
