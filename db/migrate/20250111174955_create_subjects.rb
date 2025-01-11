class CreateSubjects < ActiveRecord::Migration[7.2]
  def change
    create_table :subjects do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :subjects, :name, unique: true
  end
end
