RSpec::Matchers.define :be_same_as_address do |address|
  match do |subject|
    [:firstname, 
     :lastname, 
     :address, 
     :zipcode, 
     :city, 
     :phone, 
     :country].each do |attr|
      if subject.public_send(attr) != address.public_send(attr)
        return false
      end
    end
  end

  failure_message do |text|
    "expected #{address} to be the same as #{subject} but it wasn't"
  end

  failure_message_when_negated do |text|
    "expected #{address} not to be the same as #{subject} but it was"
  end
end