require 'rails_helper'

describe Enrollment, type: :model do
  describe 'validation' do
    context 'when an overlapping enrollment exists' do
      let!(:concurrent_sections) { create_pair(:section) }
      let!(:student) { create(:student) }
      let!(:enrollment) { create(:enrollment, section: concurrent_sections[0], student:) }

      context 'when saving' do
        let(:new_enrollment) { build(:enrollment, section: concurrent_sections[1], student:) }

        subject { new_enrollment.save }

        specify 'no new enrollment is created' do
          expect { subject }.not_to change { Enrollment.count }
        end

        specify 'the new enrollment contains a corresponding error' do
          subject
          expect(new_enrollment.errors.messages).to eq(
            enrollment_conflict: [
              "Sections #{concurrent_sections[1].id} and #{concurrent_sections[0].id} overlap in their schedules"
            ]
          )
        end
      end

      context 'when update' do
        subject { enrollment.update(created_at: Time.current) }

        specify 'the enrollment is updated' do
          expect { subject }.to change { enrollment.reload.created_at }
        end
      end
    end
  end
end
