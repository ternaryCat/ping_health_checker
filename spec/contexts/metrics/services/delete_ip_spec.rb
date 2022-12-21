describe Metrics::Services::DeleteIp do
  describe '#call' do
    subject { described_class.new(time: Time, repository: ip_repository).call(address) }

    let(:address) { '192.168.0.1' }
    let(:ip_repository) { instance_double('IpRepository', find: { id: 10 }, delete: nil) }

    context 'valid' do
      it 'returns success' do
        expect(subject).to be_success
      end
    end

    context 'invalid' do
      context 'address' do
        let(:address) { '256.0.0.0' }

        it 'returns failure' do
          expect(subject).to be_failure
        end
      end

      context 'ip is not created' do
        let(:ip_repository) { instance_double('IpRepository', find: nil, delete: nil) }

        it 'returns failure' do
          expect(subject).to be_failure
        end
      end
    end
  end
end
