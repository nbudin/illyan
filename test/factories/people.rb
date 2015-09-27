FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :person do
    email { FactoryGirl.generate :email }
    password "password"
    
    factory :legacy_person do
      after(:build) do |person|
        person.legacy_password_md5 = Digest::MD5.hexdigest("password")
      end
    end
    
    factory :joe_user do
      email "joe@user.com"
      password "password"
      firstname "Joe"
      lastname "User"
  
      after(:create) do |joe|
        joe.confirm
      end
    end

    factory :group_administered_person do
      firstname "Group-administered"
      lastname "Person"
      after(:create) do |person|
        group = FactoryGirl.create(:group, :name => "Red Team")
        group.has_role!("admin", person)
      end
    end

    factory :administrator do
      after(:build) do |person|
        person.has_role!("admin")
      end
    end

    factory :staffer do
      after(:create) do |person|
        person.groups << FactoryGirl.create(:group, :name => "Staff")
      end
    end
  end
end