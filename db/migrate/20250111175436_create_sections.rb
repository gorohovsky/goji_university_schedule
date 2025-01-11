class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sections, %i[teacher_id subject_id classroom_id], unique: true
  end
end
