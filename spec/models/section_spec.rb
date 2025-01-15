require 'rails_helper'
require 'support/shared_examples/section'

describe Section, type: :model do
  describe 'validations' do
    subject { new_section.save }

    describe 'teacher-subject consistency' do
      context 'when the teacher does not teach the subject' do
        let(:subject_without_teacher) { create(:subject) }
        let(:new_section) { build(:section, subject: subject_without_teacher) }
        let(:error_message) { { teacher_subject_conflict: ["The teacher doesn't teach the subject"] } }

        it_behaves_like 'creation error'
      end

      context 'when the teacher teaches the subject' do
        let(:new_section) { build(:section) }
        it_behaves_like 'successful creation'
      end
    end
  end

  describe '#overlaps?' do
    let(:section1) { build(:section) }

    subject { section1.overlaps? section2 }

    context 'when the section overlaps another section' do
      let(:section2) { build(:section, extra_time_slots: [[:Friday, '11:30am', '12:20pm']]) }

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when the section does not overlap another section' do
      let(:section2) { build(:section, :without_overlapping_time_slots) }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
