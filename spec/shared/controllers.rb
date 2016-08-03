shared_examples "authorize resource" do
  it "receives :authorize!" do
    expect(controller).to receive(:authorize!)
    subject
  end
end

shared_examples "add breadcrumb" do |str, path|
  before { allow(controller).to receive(:add_breadcrumb) }
  it "receives :add_breadcrumb with '#{str}' and #{path}" do
    expect(controller).to receive(:add_breadcrumb).with(str, path, {})
    subject
  end
end

shared_examples "load resource" do
  it "receives :load_resource" do
    expect_any_instance_of(
      CanCan::ControllerResource).to receive(:load_resource)
    subject
  end
end

shared_examples 'load and authorize resource' do |resource|
  it_behaves_like "load resource", resource do 
    before do
      controller.instance_variable_set(
        "@#{resource}".to_sym, FactoryGirl.build(resource))
    end
  end

  it_behaves_like "authorize resource"
end

shared_examples 'check abilities' do |method, resource|
  before do 
    setup_ability
    @ability.cannot method, resource
  end

  it "redirects if unauthorized" do
    expect(subject).to redirect_to '/'
  end

  it_behaves_like('flash setting', 
    :alert, "You are not authorized to access this page.")
end

shared_examples "flash setting" do |key, message|
  it "sets :#{key}" do
    subject
    expect(flash[key]).to eq message
  end
end

shared_examples 'assigning' do |var|
  it "assigns @#{var}" do
    subject
    expect(assigns var).not_to be_nil
  end
end

shared_examples 'rendering nothing' do
  it "renders nothing" do
    subject
    expect(response.body).to be_blank
  end
end

shared_examples "user authentication" do
  it "receives :authenticate_user!" do
    expect(controller).to receive(:authenticate_user!)
    subject
  end
end

shared_examples '#cookies_delete' do
  it "deletes cookies" do
    subject
    [:books, :book_count, :user_products_count].each do |item|
      expect(response.cookies[item]).to be_nil
    end
  end
end

shared_examples '#set_session' do |val|
  it "sets session with #{val}" do
    subject
    expect(controller.session[:user_products_count]).to eq val
  end
end

shared_examples 'redirecting to books' do
  it "redirects to books_path" do
    expect(subject).to redirect_to books_path
  end
end


shared_examples 'rendering text' do |txt|
  it "renders text" do
    subject
    expect(response.body).to eq txt
  end
end