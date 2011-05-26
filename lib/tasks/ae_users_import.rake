namespace :ae_users do
  task :import => :environment do
    require 'ae_users_migrator/import'
    
    dumpfile = AeUsersMigrator::Import::Dumpfile.load(File.new('ae_users.json'))
    dumpfile.people.each do |person_id, ae_person|
      email = ae_person.primary_email_address.try(:address)
      unless email
        puts "Not importing person #{ae_person} - no email address"
        next
      end
      
      Person.transaction do
        illyan_person = Person.where(:email => email).includes([:open_id_identities, :groups]).first
        illyan_person ||= Person.new(:email => email)
      
        if illyan_person.last_sign_in_at
          puts "Skipping already imported person #{email}"
        else
          if ae_person.account.nil?
            puts "Skipping person #{email} because they have no account info"
            next
          end
          
          # we should overwrite this person since they've never signed into Illyan
          %w{firstname lastname gender birthdate}.each do |f|
            illyan_person.send("#{f}=", ae_person.send(f))
          end
        
          ae_person.roles.each do |role|
            next if illyan_person.groups.any? { |g| g.name == role.name }
            group = Group.find_or_create_by_name(role.name)
            illyan_person.groups << group
          end
        
          if illyan_person.encrypted_password.blank? and illyan_person.legacy_password_md5.blank?
            puts "Setting legacy password for #{email}"
            illyan_person.legacy_password_md5 = ae_person.account.password
          end
        
          if illyan_person.save
            puts "Imported person #{email}"
            if ae_person.account.try(:active) && !illyan_person.confirmed?
              illyan_person.confirm!
              puts "Confirmed person #{email}"
            end
          else
            puts "Couldn't import person #{email}: #{illyan_person.errors.full_messages.join(", ")}"
          end
        end
      end
    end
  end
end