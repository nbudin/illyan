class PersonSession < Authlogic::Session::Base
  attr_accessor :email, :password, :return_to, :have_password
end
