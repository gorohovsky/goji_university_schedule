require 'rails_helper'
require 'support/shared_examples/section'

describe Validators::TeacherClassroomAvailabilityValidator do
  context 'when creating a section' do
    subject { new_section.save }

    describe 'teacher allocation' do
      let!(:teacher) { create(:teacher) }

      context 'when the teacher is busy with another section' do
        let!(:section1) { create(:section, teacher:) }
        let!(:section2) { create(:section, :without_overlapping_time_slots, teacher:) }
        let(:new_section) { build(:section, teacher:) }
        let(:error_message) { { teacher_section_conflict: ["The teacher is busy with section #{section1.id}"] } }

        it_behaves_like 'creation error'
      end

      context "when the teacher's schedule allows for the new section" do
        let!(:section) { create(:section, teacher:) }
        let(:new_section) { build(:section, :without_overlapping_time_slots, teacher:) }

        it_behaves_like 'successful creation'
      end
    end

    describe 'classroom allocation' do
      let!(:classroom) { create(:classroom) }

      context 'when the classroom is occupied by another section' do
        let!(:section1) { create(:section, classroom:) }
        let!(:section2) { create(:section, :without_overlapping_time_slots, classroom:) }
        let(:new_section) { build(:section, classroom:) }
        let(:error_message) { { classroom_section_conflict: ["The classroom is busy with section #{section1.id}"] } }

        it_behaves_like 'creation error'
      end

      context "when the classroom's schedule allows for the new section" do
        let!(:section) { create(:section, classroom:) }
        let(:new_section) { build(:section, :without_overlapping_time_slots, classroom:) }

        it_behaves_like 'successful creation'
      end
    end
  end

  context 'when updating a section' do
    let(:updated_section) { section1 }

    describe 'teacher replacement' do
      let!(:teacher1) { create(:teacher) }
      let!(:teacher2) { create(:teacher, subject: teacher1.subjects.first) }

      subject { updated_section.update(teacher: teacher2) }

      context 'when assigning teacher to an overlapping section' do
        let!(:section1) { create(:section, teacher: teacher1) }
        let!(:section2) { create(:section, teacher: teacher2) }
        let(:error_message) { { teacher_section_conflict: ["The teacher is busy with section #{section2.id}"] } }

        it_behaves_like 'update error'
      end

      context "when the teacher's schedule allows for the new section" do
        let!(:section1) { create(:section, teacher: teacher1) }
        let!(:section2) { create(:section, :without_overlapping_time_slots, teacher: teacher2) }

        it_behaves_like 'successful update', :teacher_id
      end
    end

    describe 'classroom replacement' do
      let!(:classroom1) { create(:classroom) }
      let!(:classroom2) { create(:classroom) }

      subject { updated_section.update(classroom: classroom2) }

      context 'when the classroom is occupied by another section' do
        let!(:section1) { create(:section, classroom: classroom1) }
        let!(:section2) { create(:section, classroom: classroom2) }
        let(:error_message) { { classroom_section_conflict: ["The classroom is busy with section #{section2.id}"] } }

        it_behaves_like 'update error'
      end

      context "when the classroom's schedule allows for the new section" do
        let!(:section1) { create(:section, classroom: classroom1) }
        let!(:section2) { create(:section, :without_overlapping_time_slots, classroom: classroom2) }

        it_behaves_like 'successful update', :classroom_id
      end
    end
  end
end
