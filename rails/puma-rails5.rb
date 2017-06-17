require_relative 'util/app_template_helper.rb'


replace_readme do
  project_name = ask('hey what\'s this project actually called?')
  project_blurb = ask('terse blurb:')

  readme_markdown = <<-MARKDOWN
  # #{project_name}

  #{project_blurb}

  ## Tests

  TODO

  ## Dev environment

  TODO

  MARKDOWN
  readme_markdown
end


install_rspec = prompt_for_rspec
generate_user_scaffold = prompt_for_user_scaffold
generate_scaffolds = prompt_for_additional_scaffolds
setup_rails_admin_routes = prompt_for_rails_admin


# Prompt to overwrite arbitrary files with those present in a skeleton directory
#unless (skeleton = ask('use skeleton files? (enter to skip)')).blank?
  SKELETON_ROOT = File.expand_path(File.dirname(__FILE__))+'/app-skeletons'
#  overwrite_with_skeleton!(SKELETON_ROOT+'/'+skeleton)
#end
overwrite_with_skeleton!(SKELETON_ROOT+'/test-rm')

replace_gemfile do
  add_source 'https://rubygems.org'

  gem 'rails', '~> 5.1'
  gem 'sqlite3', '~> 1.3'
  gem 'puma', '~> 3.7'
  gem 'bcrypt', '~> 3.1'
  gem 'slim', '~> 3.0'
  gem 'slim-rails', '~> 3.1'
  gem 'dotenv', '~> 2.2'
  gem 'rails_admin', '~> 1.2'
  gem 'listen', '~> 3.1'

  gem_group :development, :test do
    gem 'byebug', '~> 9.0'
    gem 'rspec-rails', '~> 3.6'
    gem 'webmock', '~> 3.0'
    gem 'vcr', '~> 3.0'
    # TODO y
    #gem 'capybara-webkit', '~> 1.14'
  end
end


after_bundle do
  install_rspec.call unless install_rspec.nil?
  generate_user_scaffold.call unless generate_user_scaffold.nil?
  generate_scaffolds.call unless generate_scaffolds.nil?
  setup_rails_admin_routes.call unless setup_rails_admin_routes.nil?
  rails_command 'db:migrate'
  rails_command 'db:test:prepare'
end

# TODO prompt for initializers?
