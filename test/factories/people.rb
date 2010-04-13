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
end

Factory.define :legacy_person, :parent => :person do |p|
  p.legacy_password_md5 Digest::MD5.hexdigest("password")
end

Factory.define :openid_person, :parent => :person do |p|
  p.after_build do |person|
    person.open_id_identities << Factory.build(:open_id_identity, :person => person)
  end
end

Factory.define :administrator, :parent => :person do |p|
  p.after_build do |person|
    person.has_role!("admin")
  end
end

Factory.define :staffer, :parent => :person do |p|
  p.after_create do |person|
    person.groups << Factory.create(:staff_group)
  end
end