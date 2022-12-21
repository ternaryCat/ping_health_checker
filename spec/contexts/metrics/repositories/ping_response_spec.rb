describe Metrics::Repositories::PingResponse do
  let(:address) { '192.168.0.1' }
  let(:ip_id) { 1 }
  let(:created_at) { Time.now }

  let(:start_datetime) { '12.12.2022 00:00' }
  let(:end_datetime) { '22.12.2022 23:59' }

  before do
    Container['database.connection'][:ips].insert(address:, created_at: Time.now)

    Container['database.connection'][:ping_responses].insert(
      ip_id:,
      success: true,
      duration: 0.5,
      created_at: Time.parse(start_datetime)
    )
    Container['database.connection'][:ping_responses].insert(
      ip_id:,
      success: true,
      duration: 1,
      created_at: Time.parse(end_datetime)
    )
    Container['database.connection'][:ping_responses].insert(
      ip_id:,
      success: false,
      duration: 1,
      created_at: Time.parse(end_datetime)
    )
  end

  describe '#create' do
    subject do
      described_class.new(connection: Container['database.connection']).create(ip_id, success, duration, created_at)
    end

    let(:success) { true }
    let(:duration) { 0.2 }

    it 'returns id' do
      expect(subject).to be(4)
    end

    context 'invalid' do
      context 'created_at' do
        let(:created_at) { '-1' }

        it 'raises error' do
          expect{ subject }.to raise_error(Sequel::Error)
        end
      end
    end
  end


  describe '#average_duration' do
    subject do
      described_class.new(
        connection: Container['database.connection']
      ).average_duration(ip_id, start_datetime, end_datetime)
    end

    it 'calculates average duration only for successes' do
      expect(subject).to be(0.75)
    end
  end

  describe '#min_duration' do
    subject do
      described_class.new(
        connection: Container['database.connection']
      ).min_duration(ip_id, start_datetime, end_datetime)
    end

    it 'calculates average duration only for successes' do
      expect(subject).to be(0.5)
    end
  end

  describe '#max_duration' do
    subject do
      described_class.new(
        connection: Container['database.connection']
      ).max_duration(ip_id, start_datetime, end_datetime)
    end

    it 'calculates average duration only for successes' do
      expect(subject).to be(1.0)
    end
  end

  describe '#median_duration' do
    subject do
      described_class.new(
        connection: Container['database.connection']
      ).median_duration(ip_id, start_datetime, end_datetime)
    end

    before do
      20.times do
        Container['database.connection'][:ping_responses].insert(
          ip_id:,
          success: true,
          duration: 0.6,
          created_at: start_datetime
        )
      end
    end

    it 'calculates median duration only for successes' do
      expect(subject).to be(0.6)
    end
  end

  describe '#loss_percent' do
    subject do
      described_class.new(
        connection: Container['database.connection']
      ).loss_percent(ip_id, start_datetime, end_datetime)
    end

    it 'calculates loss percent' do
      expect(subject.round(2)).to be(33.33)
    end
  end
end
