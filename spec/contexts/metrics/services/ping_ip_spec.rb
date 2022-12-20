describe Metrics::Services::PingIp do
  describe '#find' do
    subject { described_class.new(icmp:, ip_repository:, response_repository:, time: Time).call(address, timeout) }

    let(:icmp) { instance_double('Icmp', ping: { success: true, duration: 0.023 }) }
    let(:ip_repository) do
      instance_double('IpRepository', find: {id: 2, address: '192.168.0.1', created_at: Time.now })
    end
    let(:response_repository) { instance_double('ResponseRepository', create: 1) }

    let(:address) { '192.168.0.1' }
    let(:timeout) { 5 }

    context 'pings address' do
      it { expect(subject).to be_success }

      context "doesn't ping address" do
        let(:icmp) { instance_double('Icmp', ping: { success: false, duration: 0 }) }

        it { expect(subject).to be_success }
      end
    end

    context "doesn't ping address" do
      context "doesn't find ip" do
        let(:ip_repository) { instance_double('IpRepository', find: nil) }

        it { expect(subject).to be_failure }
      end
    end
  end
end
