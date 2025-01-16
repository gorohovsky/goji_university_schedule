require 'rails_helper'

describe SectionSchedule, type: :model do
  describe 'validations' do
    describe 'time slot duration' do
      before { section_schedule.valid? }

      subject { section_schedule.errors }

      shared_examples 'valid duration' do
        it 'is valid' do
          expect(subject).not_to have_key(:invalid_duration)
        end
      end

      shared_examples 'invalid duration' do
        it 'is invalid' do
          expect(subject[:invalid_duration]).to eq [described_class::DURATION_ERROR]
        end
      end

      context 'when 50 minutes' do
        let(:section_schedule) { build(:section_schedule, time_slot: [:Monday, '9:00am', '9:50am']) }

        it_behaves_like 'valid duration'
      end

      context 'when 80 minutes' do
        let(:section_schedule) { build(:section_schedule, time_slot: [:Monday, '9:00am', '10:20am']) }

        it_behaves_like 'valid duration'
      end

      context 'when another duration' do
        let(:section_schedule) { build(:section_schedule, time_slot: [:Monday, '9:00am', '10:30am']) }

        it_behaves_like 'invalid duration'
      end
    end
  end

  describe '#overlaps?' do
    let(:section_schedule) { build(:section_schedule, time_slot: [:Monday, '10:00am', '11:00am']) }

    shared_examples 'correct overlap check' do |result|
      let(:section_schedules) { time_slots.map { build(:section_schedule, time_slot: _1) } }

      subject { section_schedules.map! { section_schedule.overlaps?(_1) }.uniq! }

      it 'returns the correct result' do
        expect(subject).to eq [result]
      end
    end

    context 'when the time slot overlaps another one' do
      let(:time_slots) do
        [
          [:Monday, '9:00am', '10:30am'],
          [:Monday, '10:00am', '11:00am'],
          [:Monday, '10:05am', '10:55am'],
          [:Monday, '10:30am', '12:00pm'],
          [:Monday, '09:00am', '12:00pm']
        ]
      end
      it_behaves_like 'correct overlap check', true
    end

    context 'when the time slot does not overlap another one' do
      let(:time_slots) do
        [
          [:Monday, '9:00am', '10:00am'],
          [:Monday, '11:00am', '12:00pm'],
          [:Tuesday, '10:00am', '11:00am']
        ]
      end
      it_behaves_like 'correct overlap check', false
    end
  end
end
