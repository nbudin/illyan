Factory.sequence :email do |n|
  "test#{n}@example.com"
end

Factory.sequence :identity_url do |n|
  "http://openid.example.com/#{n}"
end

Factory.define :open_id_identity do |id|
  id.identity_url { Factory.next :identity_url }
end

Factory.define :person do |p|
  p.email { Factory.next :email }
  p.password "password"
end

Factory.define :legacy_person, :parent => :person do |p|
  p.after_build do |person|
    person.legacy_password_md5 = Digest::MD5.hexdigest("password")
  end
end

Factory.define :openid_person, :parent => :person do |p|
  p.after_build do |person|
    person.open_id_identities << Factory.build(:open_id_identity, :person => person)
  end
end

Factory.define :joe_user, :parent => :person do |p|
  p.email "joe@user.com"
  p.password "password"
  p.firstname "Joe"
  p.lastname "User"
  
  p.after_create do |joe|
    joe.confirm!
  end
end

Factory.define :group_administered_person, :parent => :person do |p|
  p.firstname "Group-administered"
  p.lastname "Person"
  p.after_create do |person|
    group = Factory.create(:group, :name => "Red Team")
    group.has_role!("admin", person)
  end
end

Factory.define :administrator, :parent => :person do |p|
  p.after_build do |person|
    person.has_role!("admin")
  end
end

Factory.define :staffer, :parent => :person do |p|
  p.after_create do |person|
    person.groups << Factory.create(:group, :name => "Staff")
  end
end
