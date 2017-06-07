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
  Dir.glob(root+'/**/*.*').each do |filepath|
    puts project_filepath = filepath.sub(root, cwd)

    # copy the skeleton file into the project tree
    run "cp #{filepath} #{project_filepath}"
  end
end


def prompt_for_rspec
  if yes?('install rspec?')
    generate('rspec:install')
  end
end


def prompt_for_user_scaffold
  if yes?('generate user scaffold? (y/n)')
    generate(:scaffold,
             'user',
             'first_name:string',
             'last_name:string',
             'email:string',
             'username:string',
             'password_digest:string',
             '--no-api',
             '--no-assets',
             '--no-stylesheets',
             '--no-javascripts')
  end
end


def prompt_for_additional_scaffolds
  until (scaffold_name = ask('enter any additional scaffold name (enter to continue):')).blank?
    columns = ask('enter space-separated columns (e.g. "foo:string bar:integer")')
    args = columns.split(' ')
    # default args, unless user has explicitly contradicts the defaults
    args << '--no-api' unless args.include? '--api'
    args << '--no-assets' unless args.include? '--assets'
    args << '--no-stylesheets' unless args.include? '--stylesheets'
    args << '--no-javascripts' unless args.include? '--javascripts'
    send(:generate, :scaffold, scaffold_name, *columns.split(' '))
  end
end


