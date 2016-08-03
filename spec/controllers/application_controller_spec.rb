require 'rails_helper'
require 'shared/application_controller'

RSpec.describe ApplicationController, type: :controller do
  controller {}

  let(:user) { FactoryGirl.build_stubbed(:user) }

  [:load_in_progress_order, 
   :configure_permitted_parameters, 
   :set_locale].each do |filter|
    it { is_expected.to use_before_action(filter) }
  end
  
  it { is_expected.to rescue_from(CanCan::AccessDenied) }

  describe "#set_locale" do

    subject { controller.set_locale }

    context "when params[:locale] is not nil" do
      before do
        allow(controller).to receive(:params).and_return({locale: :de})
        subject
      end

      it "sets I18n.locale equal to params[:locale]" do
        expect(I18n.locale).to eq controller.params[:locale]
      end

      it_behaves_like 'setting omniauth locale'
    end

    context "when params[:locale] is nil "\
            "but session[:omniauth_login_locale] is not" do

      before do
        allow(controller).to receive(:session).and_return(
          {omniauth_login_locale: :de})
        subject
      end
      
      it "sets I18n.locale equal to session[:omniauth_login_locale]" do
        expect(I18n.locale).to eq controller.session[:omniauth_login_locale]
      end

      it_behaves_like 'setting omniauth locale'
    end

    context "when both params[:locale] "\
            "and session[:omniauth_login_locale] are nil" do

      before do
        allow(I18n).to receive(:default_locale).and_return :de
        subject
      end
      
      it "sets I18n.locale equal to I18n.default_locale" do
        expect(I18n.locale).to eq I18n.default_locale
      end

      it_behaves_like 'setting omniauth locale'
    end
  end

  describe "#default_url_options" do
    it "returns {locale: I18n.locale} hash merged with hash passed in" do
      expect(controller.default_url_options({key: 'value'})).to eq(
        {locale: I18n.locale, key: 'value'})
    end
  end

  describe "#create_addresses_obj" do
    subject { controller.create_addresses_obj }
    before { allow(controller).to receive(:current_user).and_return user }

    [:billing_address, :shipping_address].each do |addr|
      it "assigns #{addr}" do
        subject
        expect(assigns(addr)).not_to be_nil
      end
    end
  end
end