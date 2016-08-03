require 'rails_helper'
require 'shared/controllers'

RSpec.describe UsersController, type: :controller do

  shared_examples '#updates' do
    it "updates current_user" do
      expect(user).to receive(:update)
      subject
    end 

    context "if current_user was updated" do
      before { allow(user).to receive(:update).and_return true }
      it "signs in current_user"
      it "sets flash"
    end
    context "if current_user was not updated" do
      it "sets flash"
    end    
  end

  let(:user) { FactoryGirl.create :user }
  let(:attributes) { FactoryGirl.attributes_for(:user).stringify_keys }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    allow(controller).to receive(:load_in_progress_order)
  end
  [:authorize_current_user, :create_addresses_obj].each do |item|
    it { is_expected.to use_before_action(item) }
  end

  describe "PUT #update_password" do
    subject { put :update_password, { 
      user: {old_password: user.password, password: 'new_pass'}, 
      user_id: user.id } }

    it_behaves_like "user authentication"
    it_behaves_like 'check abilities', :update, User
  end

  describe "GET #update_data" do
    subject { put :update_data, { 
      user: {firstname: 'firstname', 
             lastname: 'lastname', 
             email: 'mail@mail.com'}, 
      user_id: user.id } }

    it_behaves_like "user authentication"
    it_behaves_like 'check abilities', :update, User
  end

end
