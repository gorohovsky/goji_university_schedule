require 'rails_helper'

describe Section, type: :model do
  describe 'validations' do
    subject { new_section.save }

    context 'when the teacher does not teach the subject' do
      let(:subject_without_teacher) { create(:subject) }
      let(:new_section) { build(:section, subject: subject_without_teacher) }

      specify 'no new section is created' do
        expect { subject }.not_to change { Section.count }
      end

      specify 'the new section contains a corresponding error' do
        subject
        expect(new_section.errors.messages).to eq(teacher_subject_conflict: ["The teacher doesn't teach the subject"])
      end
    end

    context 'when the teacher teaches the subject' do
      let(:new_section) { build(:section) }

      specify 'a new section is created' do
        expect { subject }.to change { Section.count }.by 1
      end
    end
  end
end
