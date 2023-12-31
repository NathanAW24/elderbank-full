require 'rails_helper'
require "factory_bot_rails"


RSpec.describe AtmMachinesController, type: :controller do
    describe "create" do
        ####### VIDEO DEMO FUZZ TESTING
        before do
            @fuzzed_atm_dict = {
              atm_machine_name: Faker::Alphanumeric.alpha(number: rand(5..10)),
              store_name: Faker::Alphanumeric.alpha(number: rand(5..20)),
              balance: rand(-1000.0..1000.0).round(2)
            }
          end
          
          context "with positive or zero balance" do
            before do
              # Ensure the balance is positive or zero
              @fuzzed_atm_dict[:balance] = [@fuzzed_atm_dict[:balance], 0.0].max
            end
          
            it "creates atm successfully given correct fuzzed inputs" do
              post :create, params: { atm_machine: @fuzzed_atm_dict }
          
              expect(response).to have_http_status(:success)
              parsed_response = JSON.parse(response.body)
              expected_json = {
                'id' => parsed_response['id'],
                'atm_machine_name' => @fuzzed_atm_dict[:atm_machine_name],
                'store_name' => @fuzzed_atm_dict[:store_name],
                'balance' => @fuzzed_atm_dict[:balance].to_s
              }
              parsed_response.delete("created_at")
              parsed_response.delete("updated_at")
              expect(parsed_response).to eq(expected_json)
            end
          end
          
          context "with negative balance" do
            before do
              # Ensure the balance is negative
              @fuzzed_atm_dict[:balance] = [-1.0, @fuzzed_atm_dict[:balance]].min
            end
          
            it "returns 422 unprocessable entity for negative balance" do
              post :create, params: { atm_machine: @fuzzed_atm_dict }
              expect(response).to have_http_status(422)
            end
          end
          #######
        
        # fuzzer stops
        it "creates a new atm if given correct params" do
            @send_params = {atm_machine: {atm_machine_name:"Testing ATM", store_name:"Testing Store Name", balance: 1234.0 }}
            post :create , params: @send_params
            expected_json = {'id': 8, 'atm_machine_name': 'Testing ATM', 'store_name': 'Testing Store Name', 'balance': '1234.0'}
            expect(response).to have_http_status(:success)
            parsed_response = JSON.parse(response.body)
            parsed_response.delete("created_at")
            parsed_response.delete("updated_at")
            parsed_response = parsed_response.transform_keys(&:to_sym)
            expect(parsed_response).to eq(expected_json)
        end # Normal unit test

        it "does not create if negative balance" do
            @send_params = {atm_machine:{atm_machine_name:"Testing ATM",store_name: "Testing Store Name", balance:-1 }}
            post :create , params: @send_params
            expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create an atm machine if wrong params" do
            @send_params = {atm_machine:{id: "XMM" }} 
            post :create , params: @send_params
            expect(response).to have_http_status(:unprocessable_entity)
        end # Robust test case (invalid parameter)
    end

    describe "index" do 
        it "shows all atm machines details" do
            get :index
            expect(response).to have_http_status(:success)
        end # Normal unit test
    end

    describe "show" do
        it "shows details if the specific atm exist" do
            send_params = {id: 1 }
            post :show , params: send_params
            expect(response).to have_http_status(:success)
        end # Normal unit test

        it "does not show any details if atm does not exist" do
            send_params = {id: 20000 }
            expect { post :show , params: send_params }.to raise_error(ActiveRecord::RecordNotFound)
        end # Boundary test case

        it "does not show any details if id is -1 " do
            send_params = {id: -1 }
            expect { post :show , params: send_params }.to raise_error(ActiveRecord::RecordNotFound)
        end # Boundary test case
    end

    describe "update" do
        it "updates valid atm_machine ids" do
            send_params = {id:1, atm_machine: {atm_machine_name:"Testing ATM", store_name:"Testing Store Name", balance: 1234 }}
            put :update , params: send_params
            expect(response).to have_http_status(:success)
        end # Normal unit test

        it "does not update atm_machine if the id is wrong" do
            send_params = {id: "jdasjdoas" }
            expect { put :update , params: send_params }.to raise_error(ActiveRecord::RecordNotFound)
        end # Robust test case (invalid parameter)
        it "does not update if atm_machine id is -1" do
            send_params = {id:-1, atm_machine:{atm_machine_name:"Testing ATM",store_name: "Testing Store Name", balance:1234 }}
            expect { post :update , params: send_params }.to raise_error(ActiveRecord::RecordNotFound)
        end
        it "updates with another name given valid params" do
            send_params = {id:1, atm_machine:{atm_machine_name:"Another ATM Name",store_name: "Another Store Name", balance:1234 }}
            put :update , params: send_params
            expect(response).to have_http_status(:success)
        end
        it "does not update with negative balance" do
            send_params = {id:1, atm_machine:{atm_machine_name:"Another ATM Name",store_name: "Another Store Name", balance:-1 }}
            put :update , params: send_params
            expect(response).to have_http_status(:unprocessable_entity)
        end
        
    end

    describe "destroy" do
        it "deletes valid atm_machine ids" do
            send_params = {id: 7 }
            post :destroy , params: send_params
            expect(response).to have_http_status(:success)
        end # Normal unit test

        it "does not delete valid atm_machine ids if tied as foreign key" do
            send_params = {id: 1 }
            expect {post :destroy , params: send_params}.to raise_error(ActiveRecord::InvalidForeignKey)
        end # Boundary test case

        it "does not delete atm_machine if the id is wrong" do
            send_params = {id: "jdasjdoas" }
            expect {post :destroy , params: send_params}.to raise_error(ActiveRecord::RecordNotFound)
        end # Robust test case (invalid parameter)
        it "should fail if negative id " do
            send_params = {id: "jdasjdoas" }
            expect {post :destroy , params: send_params}.to raise_error(ActiveRecord::RecordNotFound)
        end
    
    end
end

