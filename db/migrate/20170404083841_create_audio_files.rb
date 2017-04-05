class CreateAudioFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :audio_files do |t|
      t.string :file_name
      t.float :file_amount
      t.string :file_type

      t.timestamps
    end
  end
end
