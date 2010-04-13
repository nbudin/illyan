Factory.define :group do |g|

end

Factory.define :staff_group, :parent => :group do |g|
  g.name 'staff'
  g.after_create do |group|
    group.has_role!("staff")
  end
end