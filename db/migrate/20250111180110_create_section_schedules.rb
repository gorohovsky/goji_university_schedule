class CreateSectionSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :section_schedules do |t|
      t.references :section, null: false, foreign_key: true
      t.integer :day_of_week, limit: 2, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end

    add_index :section_schedules, %i[section_id day_of_week start_time end_time], unique: true
  end
end
