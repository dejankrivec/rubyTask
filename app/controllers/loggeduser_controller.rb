require 'uri'
require 'net/http'

class LoggeduserController < ApplicationController
  
    def createSighting

      #Sighting.delete_all()

      latitude = params[:latitude]
      longitude = params[:longitude]
      image = params[:image]
      user_id = params[:user_id]
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
        sighting = Sighting.create(latitude: latitude, logitude: longitude, image: image, user_id: user_id, flower_id: flower_id, question: getRandomQuestion())
        likes = Like.create(user_id: user_id, sighting_id: sighting.id, likes: 0)
        if sighting.save and likes.save
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
      user_id = params["user_id"]
      sighting_id = params["sighting_id"]
      
      Rails.logger.debug("user_id: " + user_id.to_s)
      Rails.logger.debug("sighting_id: " + sighting_id.to_s)

      like_exist = Like.where(user_id: user_id, sighting_id: sighting_id).first

      if like_exist
        like_exist.likes = like_exist.likes.to_i + 1
        if like_exist.save
          render json: like_exist, status: :ok 
        else
          response = { message: 'Something went wrong'}
          render json: response, status: :bad 
        end
      else
        response = { message: 'Something went wrong'}
        render json: response, status: :bad 
      end
    end

    def destroySighting
      user_id = params["user_id"]
      sighting_id = params["sighting_id"]

      Sighting.where(id: sighting_id,user_id: user_id).destroy_all
      Like.where(user_id: user_id, sighting_id: sighting_id).destroy_all

      response = { message: 'Deleted'}
      render json: response, status: :ok 
    end

    def destroyLikes
      user_id = params["user_id"]
      sighting_id = params["sighting_id"]
      
      Rails.logger.debug("user_id: " + user_id.to_s)
      Rails.logger.debug("sighting_id: " + sighting_id.to_s)

      like_exist = Like.where(user_id: user_id, sighting_id: sighting_id).first

      if like_exist
        like_exist.likes = 0
        if like_exist.save
          render json: like_exist, status: :ok 
        else
          response = { message: 'Something went wrong'}
          render json: response, status: :bad 
        end
      else
        response = { message: 'Something went wrong'}
        render json: response, status: :bad 
      end
    end

    private
    def getRandomQuestion
      url = URI("https://opentdb.com/api.php?amount=1")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)

      response = http.request(request)
      parsed_response = JSON.parse(response.body)
      Rails.logger.debug("body: " + parsed_response["results"][0]["question"].to_s)
      parsed_response["results"][0]["question"].to_s
    end
  end