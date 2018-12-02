require 'uri'
require 'net/http'
require "#{Rails.root}/app/workers/background_worker.rb"

class LoggeduserController < ApplicationController
  
    def createSighting

      #Sighting.delete_all()

      latitude = params[:latitude]
      longitude = params[:longitude]
      image = params[:image]
      user_id = @current_user.id.to_s
      flower_id = params[:flower_id]

      Rails.logger.debug("latitude: " + latitude)
      Rails.logger.debug("longitude: " + longitude)
      Rails.logger.debug("image: " + image)
      Rails.logger.debug("user_id: " + user_id)
      Rails.logger.debug("flower_id: " + flower_id)

      if Sighting.exists?(:user_id => user_id.to_i, :flower_id=> flower_id.to_i)
        response = { message: 'Already exist'}
        render json: response, status: :bad 
        return
      end

      if User.exists?(:id => user_id.to_i) and Flower.exists?(:id => flower_id.to_i)
        question = getRandomQuestion();
        sighting = Sighting.create(latitude: latitude, logitude: longitude, image: image, user_id: user_id, flower_id: flower_id, question: question)

        like = Like.create(user_id: user_id, likes: 0)
        like.sighting = sighting

        if sighting.save and like.save
          if question.nil?
            BackgroundWorker.perform_in(3600, sighting.id) # 3600 seconds equals 1 hour
          end
          render json: sighting, status: :created 
        else
          response = { message: 'Something went wrong'}
          render json: response, status: :bad 
        end     
      else
        response = { message: 'user or flower with id does not exist'}
        render json: response, status: :bad 
      end
    end

    def likeSighting
      user_id = @current_user.id.to_s
      sighting_id = params["sighting_id"]
      
      Rails.logger.debug("user_id: " + user_id.to_s)
      Rails.logger.debug("sighting_id: " + sighting_id.to_s)

      like_exist = Like.where(user_id: user_id, sighting_id: sighting_id).first

      if like_exist
        like_exist.likes = like_exist.likes.to_i + 1
        if like_exist.save
          render json: like_exist, status: :ok 
        else
          response = { message: 'Sorry we couldnt save like'}
          render json: response, status: :bad 
        end
      else
        response = { message: 'Wrong sighting id to like'}
        render json: response, status: :bad 
      end
    end

    def destroySighting
      user_id = @current_user.id.to_s
      sighting_id = params["sighting_id"]

      Like.where(user_id: user_id, sighting_id: sighting_id).destroy_all
      Sighting.where(id: sighting_id,user_id: user_id).destroy_all
      
      response = { message: 'Deleted'}
      render json: response, status: :ok 
    end

    def destroyLikes
      user_id = @current_user.id.to_s
      sighting_id = params["sighting_id"]
      
      Rails.logger.debug("user_id: " + user_id.to_s)
      Rails.logger.debug("sighting_id: " + sighting_id.to_s)

      like_exist = Like.where(user_id: user_id, sighting_id: sighting_id).first

      if like_exist
        like_exist.likes = 0
        if like_exist.save
          render json: like_exist, status: :ok 
        else
          response = { message: 'Sorry we couldn destroy likes'}
          render json: response, status: :bad 
        end
      else
        response = { message: 'Wrong sighting id to destroy likes'}
        render json: response, status: :bad 
      end
    end

    private
    def getRandomQuestion
      url = URI("https://opentdb.com/api.php?amount=1")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.read_timeout = 20
      http.open_timeout = 20
      req = Net::HTTP::Get.new(url.to_s)
      
      begin
        response = http.start() {|http|
          http.request(req)
        }
        rescue Net::OpenTimeout, Net::ReadTimeout
          return
      end

      Rails.logger.debug("body: " + response.to_s)
      parsed_response = JSON.parse(response.body)
      Rails.logger.debug("body: " + parsed_response["results"][0]["question"].to_s)
      parsed_response["results"][0]["question"].to_s
    end
  end