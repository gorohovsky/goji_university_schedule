class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end

    add_index :enrollments, %i[student_id section_id], unique: true
  end
end
