require 'rails_helper'
require 'shared/controllers'

RSpec.describe BooksController, type: :controller do
  let(:book) { FactoryGirl.create :book }
  let(:user) { FactoryGirl.create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    allow(controller).to receive(:load_in_progress_order)
  end

  describe "GET #home" do
    subject { get :home, {locale: 'en'} }

    it_behaves_like 'load resource'
    it_behaves_like 'assigning', :bestsellers
  end

  describe "GET #index" do  
    subject { get :index }

    before do
      books = Kaminari.paginate_array(FactoryGirl.create_list :book, 3).page(1)
      controller.instance_variable_set(:@books, books)
    end

    it_behaves_like "load and authorize resource", :book
    it_behaves_like 'check abilities', :read, Book
    it_behaves_like 'assigning', :categories
    it_behaves_like 'assigning', :books
  end

  describe "GET #show" do
    subject { get :show, {id: book.to_param} }
    
    it_behaves_like "load and authorize resource", :book
    it_behaves_like 'check abilities', :read, Book
  end

  describe "GET search" do
    subject { get :search, {value: 'abc', locale: 'en'} }
    
    it_behaves_like 'load resource'
    it_behaves_like 'assigning', :categories
    it_behaves_like 'assigning', :books
  end
end