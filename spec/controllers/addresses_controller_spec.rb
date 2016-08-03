require 'rails_helper'
require 'shared/controllers'
require 'shared/addresses_controller'

RSpec.describe AddressesController, type: :controller do

  let(:user) { FactoryGirl.create :user}
  let(:address) { FactoryGirl.build_stubbed :address }
  let(:attributes) { FactoryGirl.attributes_for(:address).stringify_keys }
  let(:addresses) { address = FactoryGirl.create_list(
      :address, 2, user_billing_address_id: user.id) }
  let(:valid_attributes) { attributes }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    request.env["HTTP_REFERER"] = edit_user_registration_path(user)
    allow(controller).to receive(:load_in_progress_order)
  end

  it { is_expected.to use_before_action(:create_addresses_obj) }

  describe "PUT #update" do
    subject { put :update, {id: address.to_param, address: valid_attributes} }
    
    it_behaves_like "authorize resource", :address
    it_behaves_like 'check abilities', :update, Address

    before do
      allow(controller).to receive(:create_addresses_obj)
      controller.instance_variable_set(:@billing_address, addresses[0])
      controller.instance_variable_set(:@shipping_address, addresses[1])
      allow(controller).to receive(:address_params).
          with(true).and_return Hash.new
      allow(controller).to receive(:address_params).
        with(false).and_return Hash.new
    end
    
    context "when :type is 'billing' and :and_shipping is true" do
      let(:valid_attributes) { 
        attributes.merge('type' => 'billing', 'and_shipping' => 'true') }

      it_behaves_like 'update address with user_address_id', true, :billing
      it_behaves_like 'update address with user_address_id', false, :shipping
      it_behaves_like 'address form errors', :billing
    end

    context "when :type is 'billing' and :and_shipping is false" do
      let(:valid_attributes) { 
        attributes.merge('type' => 'billing', 'and_shipping' => 'false') }

      it_behaves_like 'update address with user_address_id', true, :shipping
      it_behaves_like 'address form errors', :billing
    end

    context "when :type is not 'billing'" do
      let(:valid_attributes) { attributes.merge('type' => 'not_billing') }

      it_behaves_like 'update address with user_address_id', false, :shipping
      it_behaves_like 'address form errors', :shipping
    end
  end
end
