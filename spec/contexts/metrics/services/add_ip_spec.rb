describe Metrics::Services::AddIp do
  describe '#call' do
    subject { described_class.new(time: Time, repository: ip_repository).call(address) }

    let(:address) { '192.168.0.1' }
    let(:ip_repository) { instance_double('IpRepository', create: 10) }

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

        context 'v6' do
          let(:address) { '684D:1111:222:3333:4444:5555:6:77' }

          it 'returns failure' do
            expect(subject).to be_failure
          end
        end
      end
    end
  end
end
