def section_params(teacher:, classroom:, section:)
  {
    'teacher_id' => teacher.id,
    'subject_id' => teacher.subjects.first.id,
    'classroom_id' => classroom.id,
    'section_schedules_attributes' => section.section_schedules.map do |ss|
      {
        'day_of_week' => ss.day_of_week_for_database,
        'start_time' => ss.formatted_start_time,
        'end_time' => ss.formatted_end_time
      }
    end
  }
end
