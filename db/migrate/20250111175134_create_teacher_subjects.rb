class CreateTeacherSubjects < ActiveRecord::Migration[7.2]
  def change
    create_table :teacher_subjects do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end

    add_index :teacher_subjects, %i[teacher_id subject_id], unique: true
  end
end
