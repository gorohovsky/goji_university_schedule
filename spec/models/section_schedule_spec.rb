require 'rails_helper'

describe SectionSchedule, type: :model do
  describe '#overlaps?' do
    let(:time_slot) { build(:section_schedule, day_of_week: 1, start_time: '10:00am', end_time: '11:00am') }

    subject { time_slots.map! { time_slot.overlaps?(_1) }.uniq! }

    context 'when the time slot overlaps another one' do
      let(:time_slots) do
        [
          build(:section_schedule, day_of_week: 1, start_time: '9:00am', end_time: '10:30am'),
          build(:section_schedule, day_of_week: 1, start_time: '10:00am', end_time: '11:00am'),
          build(:section_schedule, day_of_week: 1, start_time: '10:05am', end_time: '10:55am'),
          build(:section_schedule, day_of_week: 1, start_time: '10:30am', end_time: '12:00pm'),
          build(:section_schedule, day_of_week: 1, start_time: '09:00am', end_time: '12:00pm')
        ]
      end

      it 'returns true' do
        expect(subject).to eq [true]
      end
    end

    context 'when the time slot does not overlap another one' do
      let(:time_slots) do
        [
          build(:section_schedule, day_of_week: 1, start_time: '9:00am', end_time: '10:00am'),
          build(:section_schedule, day_of_week: 1, start_time: '11:00am', end_time: '12:00pm'),
          build(:section_schedule, day_of_week: 2, start_time: '10:00am', end_time: '11:00am')
        ]
      end

      it 'returns false' do
        expect(subject).to eq [false]
      end
    end
  end
end
