# frozen_string_literal: true

namespace :admin do
  desc "Create first admin user"
  task create_first_admin: :environment do
    email = ENV['ADMIN_EMAIL'] || 'admin@gameday.com'
    password = ENV['ADMIN_PASSWORD'] || SecureRandom.hex(16)

    user = User.find_or_initialize_by(email: email)

    if user.new_record?
      user.password = password
      user.password_confirmation = password
      user.approved = true

      if user.save
        user.add_role(:admin)
        puts "✅ Admin user created successfully!"
        puts "📧 Email: #{email}"
        puts "🔑 Password: #{password}" if ENV['ADMIN_PASSWORD'].blank?
        puts "\n⚠️  Please save these credentials securely!"
      else
        puts "❌ Failed to create admin user:"
        puts user.errors.full_messages.join("\n")
      end
    else
      user.add_role(:admin) unless user.has_role?(:admin)
      puts "✅ Admin role added to existing user: #{email}"
    end
  end

  desc "List all admin users"
  task list_admins: :environment do
    admins = User.with_role(:admin)

    if admins.any?
      puts "\n📋 Admin Users:"
      admins.each do |admin|
        puts "  - #{admin.email} (ID: #{admin.id})"
      end
    else
      puts "❌ No admin users found"
    end
  end
end
