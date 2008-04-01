class Login
  attr_accessor :email, :password, :remember
  
  def initialize(args)
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
    end
  end
end