require 'rails_helper'
require 'shared/controllers'
require 'shared/orders_controller'

RSpec.describe OrdersController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:order) { 
    FactoryGirl.create :order_with_items, user: user, state: 'in_progress' }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET #new" do
    subject { get :new }

    before { allow(Order).to receive(:where).and_return [order] }

    it_behaves_like 'load and authorize resource', :order
    it_behaves_like 'check abilities', :create, Order
    it_behaves_like 'getting books'
  end

  describe "GET #update_shopcart_ajax" do
    subject { get :update_shopcart_ajax }

    before { allow(Order).to receive(:where).and_return [order] }

    it "calls ShopcartUpdateService" do
      expect_any_instance_of(ShopcartUpdateService).to receive(:call)
      subject
    end
    
    it_behaves_like '#set_session', 0 do
      before do 
        expect_any_instance_of(
          ShopcartUpdateService).to receive(:call).and_return 0 
      end
    end

    it_behaves_like 'rendering nothing'
  end

  describe "GET #clear_cookies_shopcart" do
    subject { get :clear_cookies_shopcart, {locale: 'en'} }

    before { allow(Order).to receive(:where).and_return [order] }

    it_behaves_like '#cookies_delete'
    it_behaves_like 'redirecting to books'
  end

  describe "GET #check_cupon_ajax" do
    let(:cupon) { FactoryGirl.create :cupon }

    before do 
      allow(Order).to receive(:where).and_return [order]
    end

    context "when cupon found" do
      subject { get :check_cupon_ajax, {value: cupon.value} }
      
      context "when cupon used" do
        let(:cupon) { FactoryGirl.create :cupon, use: true }

        it_behaves_like 'rendering text', 'This code has been used'
      end

      context "when cupon not used" do
        let(:cupon) { FactoryGirl.create :cupon, discount: 10, use: false }
        
        it_behaves_like 'rendering text', 'Your discount is $10. Continue?'
      end
    end

    context "when cupon not found" do
      subject { get :check_cupon_ajax, {value: 'invalid_value'} }

      it_behaves_like 'rendering text', 'This code is not found'
    end
  end

  describe "GET #show" do
    subject { get :show, {id: order.to_param} }

    it_behaves_like 'load and authorize resource', :order
    it_behaves_like 'check abilities', :read, Order
  end

  describe "GET #index" do
    subject { get :index }
    
    before do 
      relation = Order.all
      allow(relation).to receive(:[]).and_return [order] 
      allow(Order).to receive(:where).and_return relation
    end

    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :read, Order
    it_behaves_like 'assigning', :order
    it_behaves_like 'getting books'

    [:in_queue, :in_delivery, :delivered].each do |item|
      it_behaves_like 'assigning', item
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, {id: order.to_param} }

    before do 
      allow(Order).to receive(:where).and_return [order]
    end

    it_behaves_like 'load and authorize resource', :order
    it_behaves_like 'check abilities', :destroy, Order
    it_behaves_like '#cookies_delete'
    it_behaves_like '#set_session', 0
    it_behaves_like 'redirecting to books'

    it "destroys @order order_items" do
      expect_any_instance_of(Order).to receive_message_chain(
        "order_items.destroy_all")
      subject
    end

    it "sets @order prices and book_count to 0" do
      expect_any_instance_of(Order).to receive(:update).with(
        total_price: 0.0, book_count: 0, order_total: 0.0)
      subject
    end
  end
end
