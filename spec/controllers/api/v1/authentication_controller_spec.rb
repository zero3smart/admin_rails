require "spec_helper"

describe Api::V1::AuthenticationController, type: :controller do
	before(:all) do
		@phone = '420123456789'
		@uuid = '3s2d4fd2f4fd2'
		@language = 'en'
	end

	describe "POST :authenticate" do
		it "returns response 200" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			expect(response).to be_success
		end
		
		it "returns blank JSON object" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			JSON.parse(response.body).should == {}
		end

		it "returns error 106 - Cannot send verification SMS (country code is missing)" do
			post :authenticate, phone: "773646660", uuid: @uuid, language: @language
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is blank)" do
			post :authenticate, phone: "", uuid: @uuid, language: @language
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is too short)" do
			post :authenticate, phone: "6466", uuid: @uuid, language: @language
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is too long)" do
			post :authenticate, phone: "4207736466601112", uuid: @uuid, language: @language
			JSON.parse(response.body).should have_content('"code"=>106')
		end
	end

	describe "POST :verify_code" do
		it "returns response 200" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: @uuid, verification_code: device.verification_code
			expect(response).to be_success
		end

		it "returns JSON object \"user\"" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: @uuid, verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"phone"=>"+'+@phone+'"')
		end

		it "returns error 110 (using verification_code twice)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: @uuid, verification_code: device.verification_code
			post :verify_code, phone: @phone, uuid: @uuid, verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"code"=>110')
		end

		it "returns error 109 (bad validation code)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: @uuid, verification_code: "000"
			JSON.parse(response.body).should have_content('"code"=>109')
		end

		it "returns error 109 (no validation code)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: @uuid
			JSON.parse(response.body).should have_content('"code"=>109')
		end

		it "returns error 111 (bad phone number)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: "420773773773", uuid: @uuid, verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 111 (bad uuid)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :verify_code, phone: @phone, uuid: "3333333333333", verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 106 (sms limit reached)" do
			10.times do post :authenticate, phone: @phone, uuid: @uuid, language: @language end
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :authenticate, phone: @phone, uuid: @uuid
			JSON.parse(response.body).should have_content('"code"=>106')
		end
	end

	describe "POST :resend_verification_code" do
		it "returns response 200" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :resend_verification_code, phone: @phone, uuid: @uuid
			expect(response).to be_success
		end

		it "returns blank JSON object" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :resend_verification_code, phone: @phone, uuid: @uuid
			JSON.parse(response.body).should == {}
		end

		it "returns error 114 (resend limit reached)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :resend_verification_code, phone: @phone, uuid: @uuid
			post :resend_verification_code, phone: @phone, uuid: @uuid
			JSON.parse(response.body).should have_content('"code"=>114')
		end

		it "returns error 106 (sms limit reached)" do
			10.times do post :authenticate, phone: @phone, uuid: @uuid, language: @language end
			device = Device.where(phone: "+420773646660", uuid: @uuid).first
			post :resend_verification_code, phone: @phone, uuid: @uuid
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 111 (bad phone number)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :resend_verification_code, phone: "420773773773", uuid: @uuid
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 111 (bad uuid)" do
			post :authenticate, phone: @phone, uuid: @uuid, language: @language
			device = Device.where(phone: "+"+@phone, uuid: @uuid).first
			post :resend_verification_code, phone: @phone, uuid: "3333333333333"
			JSON.parse(response.body).should have_content('"code"=>111')
		end
	end

	describe "POST :validate" do
		it "returns response 200" do
			device = FactoryGirl.create(:device)
			post :validate, user_id: device.user_id, auth_token: device.auth_token, uuid: device.uuid, connection_type: "wifi"
			expect(response).to be_success
		end

		it "returns object with the same uuid" do
			device = FactoryGirl.create(:device)
			post :validate, user_id: device.user_id, auth_token: device.auth_token, uuid: device.uuid, connection_type: "wifi"
			JSON.parse(response.body).should have_content('"uuid"=>"'+@uuid+'"')
		end

		it "returns error 103 (bad token)" do
			device = FactoryGirl.create(:device)
			post :validate, user_id: device.user_id, auth_token: "x1xxxx11xxxxx1xxx_x", uuid: device.uuid, connection_type: "wifi"
			JSON.parse(response.body).should have_content('"code"=>103')
		end

		it "returns error 102 (old token)" do
			device = FactoryGirl.create(:device)
			post :validate, user_id: device.user_id, auth_token: device.last_token, uuid: device.uuid, connection_type: "wifi"
			JSON.parse(response.body).should have_content('"code"=>102')
		end

		it "returns error 111 (bad user id)" do
			device = FactoryGirl.create(:device)
			post :validate, user_id: "0", auth_token: device.auth_token, uuid: device.uuid, connection_type: "wifi"
			JSON.parse(response.body).should have_content('"code"=>111')
		end
	end

	describe "POST :deauthenticate" do
		it "returns response 200" do
			device = FactoryGirl.create(:device)
			post :deauthenticate, user_id: device.user_id, auth_token: device.auth_token, uuid: device.uuid
			expect(response).to be_success
		end

		it "returns blank JSON object" do
			device = FactoryGirl.create(:device)
			post :deauthenticate, user_id: device.user_id, auth_token: device.auth_token, uuid: device.uuid
			JSON.parse(response.body).should == {}
		end

		it "returns error 102 (old token)" do
			device = FactoryGirl.create(:device)
			post :deauthenticate, user_id: device.user_id, auth_token: device.last_token, uuid: device.uuid
			JSON.parse(response.body).should have_content('"code"=>102')
		end

		it "returns error 111 (bad user id)" do
			device = FactoryGirl.create(:device)
			post :deauthenticate, user_id: "0", auth_token: device.auth_token, uuid: device.uuid
			JSON.parse(response.body).should have_content('"code"=>111')
		end
	end
end
