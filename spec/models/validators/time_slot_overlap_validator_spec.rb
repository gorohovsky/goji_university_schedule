require 'rails_helper'

describe Validators::TimeSlotOverlapValidator do
  subject { section.valid? }

  context 'when section does not have overlapping time slots' do
    let(:section) { build(:section) }

    specify 'section is valid' do
      expect(subject).to be true
    end
  end

  context 'when section has overlapping time slots' do
    let(:section) { build(:section, :with_overlapping_time_slots) }

    specify 'section is invalid' do
      expect(subject).to be false
    end

    specify 'section contains corresponding errors' do
      subject
      expect(section.errors.messages).to eq(time_slot_conflict: ["'07:30am - 08:20am' and '08:00am - 08:50am' on Monday"])
    end
  end
end
