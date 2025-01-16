require 'rails_helper'

describe Teacher, type: :model do
  describe '#subject?' do
    let(:teacher) { create(:teacher) }

    subject { teacher.subject?(some_subject) }

    context 'when the teacher teaches the subject' do
      let(:some_subject) { teacher.subjects.first }

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when the teacher does not teach the subject' do
      let(:some_subject) { create(:subject) }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
