require 'rails_helper'
require 'shared/controllers'

RSpec.describe OrderItemsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:order_item) { FactoryGirl.create :order_item }
  let(:attributes) { {'book_id' => order_item.book_id, 'quantity' => '3'} }
  let(:order) { 
    FactoryGirl.create :order_with_items, user: user, state: 'in_progress' }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    allow(Order).to receive(:where).and_return [order]
    allow(Book).to receive(:find_by_id).and_return order_item.book
    allow(OrderItem).to receive(:find_by_book_id).and_return order_item
  end

  describe "PUT #update" do
    subject { put :update, {id: order_item.to_param, order_item: attributes} }
    
    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :update, OrderItem
    
    it "calls OrderUpdateService" do
      expect_any_instance_of(OrderUpdateService).to receive(:call)
      subject
    end

    it "updates order_items" do
      expect_any_instance_of(OrderItem).to receive(:update)
      subject
    end

    it_behaves_like 'rendering nothing'
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, {id: order_item.to_param} }
    
    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :destroy, OrderItem
    
    it "updates @order" do
      expect_any_instance_of(Order).to receive(:update)
      subject
    end

    it "destroys order_item" do
      expect(order_item).to receive(:destroy)
      subject
    end

    it_behaves_like 'rendering nothing'
  end
end
