require 'rails_helper'
require 'shared/controllers'

RSpec.describe OrderStepsController, type: :controller do
  let(:step) { [:address, :delivery, :payment, :confirm, :complete].sample }
  let(:user) { FactoryGirl.create :user }
  let(:order) { 
    FactoryGirl.create :order_with_items, user: user, state: 'in_progress' }
  let(:cupon) { FactoryGirl.create :cupon, use: false }
  let(:form_params) { {'billing_address'  => {},
                       'shipping_address' => {},
                       'delivery_type'    => {},
                       'payment'          => {}} }
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    allow(Order).to receive(:where).and_return [order]
    allow(controller).to receive(:redirect_to_step)
  end

  it { is_expected.to use_before_action(:redirect_to_step) }

  describe "GET #show" do
    subject { get :show, { id: step } }

    it_behaves_like "user authentication"
    it_behaves_like 'assigning', :order_steps_form

    context "when step is :complete" do
      let(:step) { :complete }

      it "gets last order queue of current_user" do
        expect(Order).to receive(:last_order_queue).with(user)
        subject
      end

      it_behaves_like '#set_session', 0
      it_behaves_like '#cookies_delete'
    end
    
    it "updates cupon" do
      allow(controller).to receive(:params).and_return({value: 'not_nil'})
      allow(Cupon).to receive(:cheking).and_return [cupon]
      expect(cupon).to receive(:update)
      subject
    end

    it "renders wizard" do
      allow(controller).to receive(:render).and_return nil
      expect(controller).to receive(:render_wizard)
      subject
    end
  end

  describe "PUT #update" do
    let(:order_steps_form) { OrderStepsForm.new(order, form_params) }

    subject { put :update, { id: step, order_steps_form: form_params } }

    it_behaves_like "user authentication"
    it_behaves_like 'assigning', :order_steps_form
    
    it "renders wizard" do
      allow(OrderStepsForm).to receive(:new).and_return order_steps_form
      allow(controller).to receive(:render).and_return nil
      expect(controller).to receive(:render_wizard).with(order_steps_form)
      subject
    end
  end
end
