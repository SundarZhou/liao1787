namespace :default do
  desc "Test"
  task :test => :environment do
    p Rails.env
  end
  desc "Setup system data"
  task :system_user => :environment do
    puts "Create system user"
    # create User.
    if User.count == 0
      password = [*'a'..'z',*'0'..'9'].sample(8).join
      user = User.create(email: "admin_#{password}@gmail.com", password: password)

      puts "account is #{user.email} #{user.password}"
      # UserMailer.welcome(user, password).deliver
    end

    if Setting.count == 0
      setting = Setting.create(title: '后台', description: '', domain_name: '')
    end
  end

end