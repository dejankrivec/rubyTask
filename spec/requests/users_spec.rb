require "#{Rails.root}/lib/json_jwt_token.rb"

describe "POST Create user", type: :request do
    it 'should return success message' do
        #post "/auth/register/?email=d&username=d&password=d"
        #expect(response).to be_successful
        ## to be sure that user was created in database
        expect { post "/auth/register/?email=d&username=d&password=d"}.to change(User, :count).by(1)
    end
    
end

describe "Get Users API", type: :request do
    it 'should return all users' do
      FactoryBot.create_list(:user, 10)

      get '/getUsers'
      json = JSON.parse(response.body)

      # test if response code is 200
      expect(response).to be_successful
  
      # test if we get all users
      expect(json.length).to eq(10)
    end
end

describe "GET get Flowers when seeded", type: :request do
    it 'should return array of flowers' do
        FactoryBot.create_list(:flower, 15)
  
        get '/getFlowers'
        json = JSON.parse(response.body)
  
        # test if response code is 200
        expect(response).to be_successful
    
        # test if we get all flowers
        expect(json.length).to eq(15)
      end
end

describe "GET get Flowers not seeded", type: :request do
    it 'should return message' do

        get '/getFlowers'
        json = JSON.parse(response.body)
  
        # test if response code is 200
        expect(response).to be_successful
    
        # test if we get all flowers
        expect(json.length).to eq(0)
      end
end

describe "GET get Sightings for specific flower", type: :request do
    it 'should return list of sightings' do
        FactoryBot.create_list(:user, 10)
        FactoryBot.create_list(:flower, 15)
        FactoryBot.create_list(:sighting, 10)

        get '/getSightings', headers: { 'flower' => 0.to_s }
        json = JSON.parse(response.body)
  
        # test if response code is 200
        (expect(response.status).to eq(400))

        expect(json).to match({"message" => "No entries"})
    end
end

describe "GET Sightings for specific flower does not exist", type: :request do
    it 'should return error message' do

        get '/getSightings', headers: { 'flower' => 1.to_s }
        json = JSON.parse(response.body)
  
        # test if response code is 400
        (expect(response.status).to eq(400))
        expect(json).to match({"message" => "No entries"})
    end
end

describe "POST Create sighting token missing", type: :request do
    it 'should return error message' do

        post '/createSighting?latitude=123&longitude=123&image=123&flower_id=1'
        json = JSON.parse(response.body)
  
        # test if response code is 400
        (expect(response.status).to eq(500))
        expect(json).to match({"message" => "Nil JSON web token"})
    end
end

describe "POST Create sighting token expired", type: :request do
    it 'should return error message' do
        FactoryBot.create_list(:user, 10)

        token = JsonWebToken.encode(user_id: 0)

        post '/createSighting?latitude=123&longitude=123&image=123&flower_id=1', headers: { :Authorization => "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1NDM1OTE0ODd9.8N0eiCgF7vaGmJuhcSANSW_Zq_UY_AzFZmrZ--1XDWM"}
        json = JSON.parse(response.body)
  
        # test if response code is 400
        (expect(response.status).to eq(500))
        expect(json).to match({"message" => "Signature has expired"})
    end
end

describe "POST Create sighting token valid", type: :request do

    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)

        FactoryBot.create(:flower)
        @flower = FactoryBot.create(:flower)
    end

    it 'should return created sighting' do
        post '/auth/login', params: {"email": @user.email, "password": @user.password}
        body =  JSON.parse(response.body)

        (expect(response.status).to eq(200))
        #params: {"latitude": "123", "longitude": "123", "image": "123", "flower_id": @flower.id }
        #post '/createSighting?latitude=123&longitude=123&image=123&flower_id=', headers: { :Authorization => "Bearer " + body['access_token']}
        post '/createSighting', params: {"latitude": "123", "longitude": "123", "image": "123", "flower_id": @flower.id }, headers: { :Authorization => "Bearer " + body['access_token']}
        json = JSON.parse(response.body)
  
        # test if response code is 201 => created
        (expect(response.status).to eq(201))
    end
end

describe 'POST login',  type: :request do

    ## check how to create valid user
    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)
    end

    it 'should return JWT token' do

    post '/auth/login', params: {"email": @user.email, "password": @user.password}
    body =  JSON.parse(response.body)
    (expect(response.status).to eq(200))

    ## we can also check for json body
    #expect(body).to match( "access_token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMTA2LCJleHAiOjE1NDM3NTc0NDB9.zpH5nR3BLoZ8t9NO8-xc0HFRgbGGC9RmLJC3wkORz_0", "message"=>"Login Successful")  
    end
end

describe "POST Destroy sighting", type: :request do

    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)

        FactoryBot.create(:sighting)
        @sighting = FactoryBot.create(:sighting)
    end

    it 'Correct id' do

        post '/auth/login', params: {"email": @user.email, "password": @user.password}
        body =  JSON.parse(response.body)

        post '/destroySighting', params: {"sighting_id": @sighting.id},  headers: { :Authorization => "Bearer " + body['access_token']}
        body =  JSON.parse(response.body)

        (expect(response.status).to eq(200))
        expect(body).to match({"message" => "Deleted"})
    end
end

describe "POST Destroy sighting", type: :request do

    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)

        FactoryBot.create(:sighting)
        @sighting = FactoryBot.create(:sighting)
    end

    it 'Wrong id' do

        post '/auth/login', params: {"email": @user.email, "password": @user.password}
        body =  JSON.parse(response.body)

        post '/destroySighting', params: {"sighting_id": "-1"},  headers: { :Authorization => "Bearer " + body['access_token']}
        body =  JSON.parse(response.body)

        (expect(response.status).to eq(200))
        expect(body).to match({"message" => "Deleted"})
    end
end

describe "POST Like sighting", type: :request do

    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)

        FactoryBot.create(:sighting)
        @sighting = FactoryBot.create(:sighting)

        @like = Like.create(user_id: @user.id, sighting_id: @sighting.id, likes: 0)
    end

    it 'post like sighting' do

        post '/auth/login', params: {"email": @user.email, "password": @user.password}
        body =  JSON.parse(response.body)

        post '/likeSighting', params: {"sighting_id": @sighting.id},  headers: { :Authorization => "Bearer " + body['access_token']}
        body =  JSON.parse(response.body)

        (expect(response.status).to eq(200))

        ## body returns likes for sighting with created_at so we cannot test response but we test respond state 
        #expect(body).to match({"message" => "Liked"})
    end
end

describe "POST destroy like", type: :request do

    before do
        FactoryBot.create(:user)
        @user = FactoryBot.create(:user)

        FactoryBot.create(:sighting)
        @sighting = FactoryBot.create(:sighting)

        @like = Like.create(user_id: @user.id, sighting_id: @sighting.id, likes: 0)
    end

    it 'post destroy like' do

        post '/auth/login', params: {"email": @user.email, "password": @user.password}
        body =  JSON.parse(response.body)

        post '/destroyLikes', params: {"sighting_id": @sighting.id},  headers: { :Authorization => "Bearer " + body['access_token']}
        body =  JSON.parse(response.body)

        (expect(response.status).to eq(200))
        ## body returns likes for sighting with created_at so we cannot test response but we test respond state 
        ##expect(body).to match({"message" => "Deleted"})
        
    end
end