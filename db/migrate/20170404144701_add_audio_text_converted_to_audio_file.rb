class AddAudioTextConvertedToAudioFile < ActiveRecord::Migration[5.0]
  def change
  	add_column :audio_files, :text_converted, :string
  end
end
