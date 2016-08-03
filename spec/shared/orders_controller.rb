shared_examples "getting books" do
  [:obj, :books, :subtotal].each do |item|
    it_behaves_like 'assigning', item
  end
end