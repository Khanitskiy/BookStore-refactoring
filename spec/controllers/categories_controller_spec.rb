require 'rails_helper'
require 'shared/controllers'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { FactoryGirl.create :category }
  let(:user) { FactoryGirl.create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    allow(controller).to receive(:load_in_progress_order)
  end

  describe "GET #show" do
    subject { get :show, {id: category.to_param} }

    it_behaves_like "authorize resource", :category
    it_behaves_like 'check abilities', :read, Category
    it_behaves_like "add breadcrumb", 'Home', :root_path
    it_behaves_like "add breadcrumb", 'Shop', :books_path
    it_behaves_like 'assigning', :categories
    it_behaves_like 'assigning', :books

    it "adds breadcrumb for category passed" do
      allow(controller).to receive(:add_breadcrumb)
      expect(controller).to receive(:add_breadcrumb).with(
        category.title, category)
      subject
    end
  end
end
