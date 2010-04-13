Factory.define :post do |p|
  p.name "A post"
end

Factory.define :group_post, :parent => :post do |p|
  p.name "Red Team Group Post"
  p.after_create do |post|
    group = Factory.create(:group, :name => "Red Team")
    group.has_role!("editor", post)
  end
end