shared_examples 'address form errors' do |sym|
  it "adds errors to #{sym} address form" do
    address = "#{sym}_address".to_sym
    form = "#{sym}_form".to_sym
    expect{subject}.to change{assigns(address).errors.messages[form]}.to true
  end
end

shared_examples 'update address with user_address_id' do |bool, sym|
  it "updates #{bool ? 'billing' : 'shipping'} address with user_#{sym}_address_id" do 
    allow(controller).to receive(:address_params).
      with(bool).and_return attributes
    subject
    expect(assigns("#{sym}_address".to_sym)).to be_same_as_address(
      Address.new(attributes))
  end
end