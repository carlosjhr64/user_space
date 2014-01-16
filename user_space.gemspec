Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '0.3.1'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2014-01-16'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Automates certain XDG features.
DESCRIPTION

  s.summary = <<SUMMARY
Automates certain XDG features.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ["--main", "README.rdoc"]

  s.require_paths = ["lib"]
  s.files = %w(
History.txt
README.rdoc
TODO.txt
data/VERSION
features/main.feature
features/step_definitions/main_steps.rb
lib/user_space.rb
lib/user_space/user_space.rb
lib/user_space/version.rb
test/user_space.rb
user_space.gemspec
  )

  s.add_runtime_dependency 'xdg', '~> 2.2', '>= 2.2.3'
  s.add_development_dependency 'rainbow', '~> 1.99', '>= 1.99.1'
  s.add_development_dependency 'test-unit', '~> 2.5', '>= 2.5.5'
  s.requirements << 'ruby: ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]'

end
