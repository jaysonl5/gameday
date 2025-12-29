# frozen_string_literal: true

namespace :assets do
  desc "Build frontend assets with esbuild"
  task :build do
    sh "yarn build"
  end

  desc "Copy images from app/assets to public/assets"
  task :copy_images do
    source = Rails.root.join("app", "assets", "images")
    dest = Rails.root.join("public", "assets", "images")

    FileUtils.mkdir_p(dest)
    FileUtils.cp_r("#{source}/.", dest) if File.directory?(source)
    puts "✓ Copied images to public/assets/images"
  end
end

# Hook into the standard Rails asset precompilation
Rake::Task["assets:precompile"].enhance do
  Rake::Task["assets:build"].invoke
  Rake::Task["assets:copy_images"].invoke
end
