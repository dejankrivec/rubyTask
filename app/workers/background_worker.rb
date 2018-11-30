class BackgroundWorker
    include SuckerPunch::Job
  
    def perform(sighting_id)
      question = getRandomQuestion()

      if !question.nil?
        sighting = Sighting.where(id: sighting_id).first

        if sighting
            sighting.question = question
            sighting.save
        end
      end
    end

    private
    def getRandomQuestion
      url = URI("https://opentdb.com/api.php?amount=1")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.read_timeout = 15
      http.open_timeout = 15
      req = Net::HTTP::Get.new(url.to_s)
      
      begin
        response = http.start() {|http|
          http.request(req)
        }
        rescue Net::OpenTimeout, Net::ReadTimeout
          Rails.logger.debug("timeout exception")
          return
      end

      Rails.logger.debug("body: " + response.to_s)
      parsed_response = JSON.parse(response.body)
      Rails.logger.debug("body: " + parsed_response["results"][0]["question"].to_s)
      parsed_response["results"][0]["question"].to_s
    end
end