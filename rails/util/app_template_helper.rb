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


def prompt_for_skeleton()
  unless (skeleton = ask('use skeleton files? (enter to skip)')).blank?
    skeleton_root = File.expand_path(File.dirname(__FILE__)+'/..')+'/app-skeletons/'+
      skeleton

    cwd = Dir.getwd

    # Get the list of removals to process
    removals = []
    removals_filepath = skeleton_root+'/.remove'
    if File.file?(removals_filepath)
      removals = File.readlines(removals_filepath).
        map(&:strip).
        reject(&:empty?)
    end

    Proc.new do
      puts 'placing files from '+skeleton_root
      # Recurse normally through the project tree
      # exclude the removals file
      Dir.glob(skeleton_root+'/**/*.*').reject do |filepath|
        filepath == removals_filepath
      end.each do |filepath|
        project_filepath = filepath.sub(skeleton_root, cwd)

        # copy the skeleton file into the project tree
        run "cp #{filepath} #{project_filepath}"
      end

      # Process removals
      removals.each do |pattern|
        Dir.glob(cwd+'/'+pattern).each do |filepath|
          remove_file(filepath)
        end
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
    if yes?('use devise? (y/n)')
      Proc.new do
        puts 'generating devise scaffold...'
        generate('devise:install')
        generate('devise', 'user')
        # TODO add customized views to skeleton
        generate('devise:views')
      end
    else
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
    puts "      generating additional scaffolds..." unless generate_calls.empty?
    generate_calls.each do |gen_args|
      generate :scaffold, *gen_args
    end
  end
end


def prompt_for_root_route
  if root_route = ask('route root to: (enter to skip)')
    Proc.new do
      puts "      configuring root route..."
      route "root to: '#{root_route}'"
    end
  end
end


def prompt_for_rails_admin
  if yes?('setup rails_admin routes? (y/n)')
    Proc.new do
      puts "      setting up rails_admin routes..."
      gsub_file 'config/routes.rb',
        /^Rails\.application\.routes\.draw do$/,
        "Rails.application.routes.draw do\nmount RailsAdmin::Engine => '/admin', as: 'rails_admin'"
    end
  end
end
