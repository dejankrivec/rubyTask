class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register getUsers getFlowers getSightingsByFlower]

 # POST /register token no need
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created 
    else
      render json: @user.errors, status: :bad
    end 
  end

  def getUsers
    users = User.all
    if users
      render json: users, status: :created 
    else
      response = { message: 'User does not exist'}
      render json: response, status: :bad
    end
  end

  def getSightingsByFlower
    flower = request.headers["flower"]
    Rails.logger.debug("flower::" + flower)

    sightings = Sighting.where(flower_id: flower)

    if !sightings.empty?
      render json: sightings, status: :ok
    else
      render json: {
        message: 'No entries'
      }, status: :bad_request
    end
  end

  def getFlowers
    flowers = Flower.all

    if flowers
      render json: flowers
    else
      render json: {
        message: 'No entries'
      }
    end
  end

  def login
    Rails.logger.debug("login")
    authenticate params[:email], params[:password]
  end

  private
  def authenticate(email, password)
    Rails.logger.debug("authenticate")
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }, status: :ok
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(
      :email,
      :username,
      :password
    )
  end
end