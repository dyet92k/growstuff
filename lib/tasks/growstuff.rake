namespace :growstuff do

  desc "Add an admin user, by name"
  # usage: rake growstuff:admin_user name=skud

  task :admin_user => :environment do

    member = Member.find_by_login_name(ENV['name']) or raise "Usage: rake growstuff:admin_user name=whoever (login name is case-sensitive)"
    admin  = Role.find_or_create_by_name!('admin')
    member.roles << admin
  end


  namespace :oneoff do
    desc "One-off tasks needed at various times and kept for posterity"

    task :empty_subjects => :environment do
      desc "May 2013: replace any empty notification subjects with (no subject)"

      # this is inefficient as it checks every Notification, but the
      # site is small and there aren't many of them, so it shouldn't matter
      # for this one-off script.
      Notification.all.each do |n|
        n.replace_blank_subject
        n.save
      end
    end

    task :empty_garden_names => :environment do
      desc "May 2013: replace any empty garden names with Garden"

      # this is inefficient as it checks every Garden, but the
      # site is small and there aren't many of them, so it shouldn't matter
      # for this one-off script.
      Garden.all.each do |g|
        if g.name.nil? or g.name =~ /^\s*$/
          g.name = "Garden"
          g.save
        end
      end
    end

    task :account_details => :environment do
      desc "Give each member an account_detail record"

      Member.all.each do |m|
        unless m.account_detail
          AccountDetail.create(:member_id => m.id)
        end
      end
    end

  end

end
