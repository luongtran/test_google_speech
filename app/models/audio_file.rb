class AudioFile < ApplicationRecord
	require "google/cloud/speech"
    require 'googleauth'
    

	has_attached_file :audio

	validates_attachment_presence :audio
	#validates_attachment_content_type :audio, :content_type => [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ]
    
    validates_attachment_size :audio, :less_than => 20.megabytes  

    before_save :convert_audio_to_text

    

    def convert_audio_to_text

        
    	speech = Google::Cloud::Speech.new

        #speech.authorization = Google::Auth.get_application_default([Google::Apis::Speech::AUTH_DRIVE_FILE])
        audio_file = convert_audio_to_flac(self.audio.queued_for_write[:original].path, self.audio_file_name)

    	audio = speech.audio audio_file, encoding: :flac, sample_rate: 8000
    	
        job = audio.recognize_job
        
        job.done? #=> false
        job.reload!
        job.done? #=> true
        

        if(job.done?) 
            
            results = job.results;
            if(results && !results.empty?) 
               result = results.first
               result.transcript #=> "how old is the Brooklyn Bridge"
               result.confidence #=> 0.9826789498329163
                self.text_converted = result.transcript
            end
            
        end
    end

    def convert_audio_to_flac(audio_path, audio_file_name)
        file_extension = audio_file_name.split(".")[1]
       
        flac_path = audio_path.gsub(".#{file_extension}", ".flac")
        system("ffmpeg -i #{audio_path} #{flac_path}")
        flac_path
    end 
end
