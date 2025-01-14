require 'rails_helper'

describe 'Enrollments', type: :request do
  describe 'GET /show' do
    let!(:enrollment) { create(:enrollment) }

    subject do
      get enrollment_url(enrollment), as: :json
      response
    end

    context 'when the enrollment is found' do
      it 'responds with 200 and the enrollment' do
        expect(subject.status).to eq 200
        expect(JSON.parse(subject.body)).to include(
          'section_id' => enrollment.section.id,
          'student_id' => enrollment.student.id
        )
      end
    end

    context 'when the enrollment is not found' do
      before { enrollment.destroy }

      it 'responds with 404 and the error' do
        expect(subject.status).to eq 404
        expect(JSON.parse(subject.body)['error']).to eq "Couldn't find Enrollment with 'id'=#{enrollment.id}"
      end
    end
  end

  describe 'POST /create' do
    let!(:student) { create(:student) }
    let!(:section) { create(:section) }
    let(:attributes) { { 'student_id' => student.id, 'section_id' => section.id } }

    subject do
      post enrollments_url, params: { enrollment: attributes }, as: :json
      response
    end

    context 'with valid parameters' do
      it 'creates a new Enrollment' do
        expect { subject }.to change(Enrollment, :count).by 1
      end

      it 'renders a JSON response with the new enrollment' do
        expect(subject.status).to eq 201
        expect(subject.content_type).to match 'application/json'
      end
    end

    shared_examples 'enrollment creation error' do |status_code|
      it 'does not create a new Enrollment' do
        expect { subject }.not_to change { Enrollment.count }
      end

      it "responds with #{status_code} and errors" do
        expect(subject.status).to eq status_code
        expect(JSON.parse(subject.body)).to eq error_message
      end
    end

    context 'with invalid parameters' do
      let(:error_message) { { 'error' => "Couldn't find #{association.class} with 'id'=#{association.id}" } }

      context 'when student does not exist' do
        let(:association) { student }
        before { student.destroy! }
        it_behaves_like 'enrollment creation error', 404
      end

      context 'when section does not exist' do
        let(:association) { section }
        before { section.destroy! }
        it_behaves_like 'enrollment creation error', 404
      end
    end

    context 'when the enrollment already exists' do
      let!(:enrollment) { create(:enrollment, student:, section:) }
      let(:error_message) { { 'error' => 'Record already exists' } }

      it_behaves_like 'enrollment creation error', 409
    end
  end

  describe 'DELETE /destroy' do
    let!(:enrollment) { create(:enrollment) }

    subject do
      delete enrollment_url(enrollment), as: :json
      response
    end

    it 'destroys the requested enrollment' do
      expect { subject }.to change { Enrollment.count }.by(-1)
    end

    it 'responds with 204' do
      expect(subject.status).to eq 204
    end
  end
end
