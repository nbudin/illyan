class Login
  attr_accessor :email, :password, :remember, :return_to, :have_password
  
  def initialize(args=nil)
    if not args.nil?
      if args[:email]
        self.email = args[:email]
      end
      if args[:password]
        self.password = args[:password]
      end
      if args[:remember]
        self.remember = args[:remember]
      end
      if args[:return_to]
        self.return_to = args[:return_to]
      end
      if args[:have_password]
        self.have_password = args[:have_password] == "true"
      end
    end
  end
end