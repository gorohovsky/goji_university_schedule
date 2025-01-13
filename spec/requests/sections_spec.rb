require 'rails_helper'
require 'support/helper_methods'

describe 'Sections', type: :request do
  let!(:teacher) { create(:teacher) }
  let!(:classroom) { create(:classroom) }

  let(:valid_attributes) do
    section = build(:section)
    section_params(teacher:, classroom:, section:)
  end

  let(:invalid_attributes) do
    section = build(:section, :with_overlapping_time_slots)
    section_params(teacher:, classroom:, section:)
  end

  describe 'GET /show' do
    let(:section) { create(:section) }

    subject do
      get section_url(section), as: :json
      response
    end

    context 'when the section is found' do
      it 'responds with 200 and the section' do
        expect(subject.status).to eq 200
        expect(JSON.parse(subject.body)).to include(
          'teacher_id' => section.teacher.id,
          'subject_id' => section.subject.id,
          'classroom_id' => section.classroom.id
        )
      end
    end

    context 'when the section is not found' do
      before { section.destroy }

      it 'responds with 404 and the error' do
        expect(subject.status).to eq 404
        expect(JSON.parse(subject.body)['error']).to eq "Couldn't find Section with 'id'=#{section.id}"
      end
    end
  end

  describe 'POST /create' do
    subject do
      post sections_url, params: { section: attributes }, as: :json
      response
    end

    context 'with valid parameters' do
      let(:attributes) { valid_attributes }

      it 'creates a new Section' do
        expect { subject }.to change { Section.count }.by 1
      end

      it 'renders a JSON response with the new section' do
        expect(subject.status).to eq 201
        expect(subject.content_type).to match 'application/json'
      end
    end

    context 'with invalid parameters' do
      let(:attributes) { invalid_attributes }

      it 'does not create a new Section' do
        expect { subject }.not_to change { Section.count }
      end

      it 'renders a JSON response with errors for the new section' do
        expect(subject.status).to eq 422
        expect(subject.content_type).to match 'application/json'
        expect(JSON.parse(subject.body)).to eq(
          'time_slot_conflict' => ["'07:30am - 08:20am' and '08:00am - 08:50am' on Monday"]
        )
      end
    end
  end
end
