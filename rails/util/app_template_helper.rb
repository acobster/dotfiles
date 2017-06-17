# Helper functions for app templates
#
def replace_readme(&block)
  remove_file 'README.doc'
  remove_file 'README.md'

  create_file 'README.md'
  append_file 'README.md', yield
end


def replace_gemfile(&block)
  remove_file 'Gemfile'
  create_file 'Gemfile'
  yield

  # obsess over whitespace
  after_bundle do
    gsub_file 'Gemfile', /^group\b/, "\ngroup"
  end
end


def overwrite_with_skeleton!(root)
  cwd = Dir.getwd
  puts "overwriting w/ #{root}"

  # Get the list of removals to process
  removals = []
  removals_filepath = root+'/.remove'
  if File.file?(removals_filepath)
    removals = File.readlines(removals_filepath)
  end

  # Recurse normally through the project tree
  # exclude the removals file
  Dir.glob(root+'/**/*.*').reject do |filepath|
    filepath == removals_filepath
  end.each do |filepath|
    project_filepath = filepath.sub(root, cwd)
    puts "        placing #{project_filepath}"

    # copy the skeleton file into the project tree
    run "cp #{filepath} #{project_filepath}"
  end

  after_bundle do
    # Process removals
    removals.each do |pattern|
      puts cwd+pattern
      puts Dir.glob(cwd+pattern).join("\n")
      puts Dir.glob(pattern).join("\n")
      Dir.glob(cwd+pattern).each do |filepath|
        puts "        removing #{filepath}"
        remove_file(filepath)
      end
    end
  end
end


def prompt_for_rspec
  if yes?('install rspec? (y/n)')
    Proc.new { generate('rspec:install') }
  end
end


def prompt_for_user_scaffold
  if yes?('generate user scaffold? (y/n)')
   # return a callback for generating the user scaffold later
    Proc.new do
      puts 'generating user scaffold...'
      generate(:scaffold,
               'user',
               'first_name:string',
               'last_name:string',
               'email:string',
               'username:string',
               '--no-api',
               '--no-assets',
               '--no-stylesheets',
               '--no-javascripts',
               '--no-helper',
               '--no-routing-specs')
    end
  end
end


def prompt_for_additional_scaffolds
  generate_calls = []
  until (scaffold_name = ask('enter any additional scaffold name (enter to continue):')).blank?
    columns = ask('enter space-separated columns (e.g. "foo:string bar:integer")')
    args = columns.split(' ')
    # default args, unless user has explicitly contradicts the defaults
    args << '--no-api' unless args.include? '--api'
    args << '--no-assets' unless args.include? '--assets'
    args << '--no-stylesheets' unless args.include? '--stylesheets'
    args << '--no-scaffold-stylesheets' unless args.include? '--scaffold-stylesheets'
    args << '--no-javascripts' unless args.include? '--javascripts'
    args << '--no-helper' unless args.include? '--helper'
    args << '--no-routing-specs' unless args.include? '--routing-specs'
    args << '--no-helper-specs' unless args.include? '--helper-specs'

    # build a generate args list
    # RUBY IS FUCKING AWESOME
    generate_calls << [scaffold_name, *columns.split(' ')]
  end

  # return a callback for generating scaffolds later
  Proc.new do
    puts "generating additional scaffolds..." unless generate_calls.empty?
    generate_calls.each do |gen_args|
      generate :scaffold, *gen_args
    end
  end
end


def prompt_for_rails_admin
  if yes?('setup rails_admin routes? (y/n)')
    Proc.new do
      puts "setting up rails_admin routes..."
      gsub_file 'config/routes.rb',
        /^Rails\.application\.routes\.draw do$/,
        "Rails.application.routes.draw do\nmount RailsAdmin::Engine => '/admin', as: 'rails_admin'"
    end
  end
end
