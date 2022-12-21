describe Metrics::Services::CalculateResponsesAnalytics do
  describe '#call' do
    subject do
      described_class.new(
        ip_repository:,
        response_repository:,
      ).call(address, start_datetime, end_datetime)
    end

    let(:address) { '192.168.0.1' }
    let(:start_datetime) { '12.12.2022 00:00' }
    let(:end_datetime) { '22.12.2022 23:59' }

    let(:ip_repository) { instance_double('IpRepository', find_with_deleted: { id: 10 }) }
    let(:response_repository) do
      instance_double(
        'ResponseRepository',
        average_duration: 0.75,
        min_duration: 0.5,
        max_duration: 1.0,
        median_duration: 0.75,
        standard_deviation_duration: 0.25,
        loss_percent: 20.0
      )
    end

    it 'returns success' do
      expect(subject).to be_success
    end

    it 'calculates analytics' do
      expect(subject.value!).to eq(
        {
          average_duration: 0.75,
          min_duration: 0.5,
          max_duration: 1.0,
          median_duration: 0.75,
          standard_deviation_duration: 0.25,
          packages_loss_percent: 20.0
        }
      )
    end
  end
end
