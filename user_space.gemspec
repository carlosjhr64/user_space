Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '2.0.0'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2014-11-18'
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
README.rdoc
lib/user_space.rb
lib/user_space/user_space.rb
lib/user_space/version.rb
  )

  s.add_runtime_dependency 'xdg', '~> 2.2', '>= 2.2.3'
  s.requirements << 'ruby: ruby 2.1.3p242 (2014-09-19 revision 47630) [x86_64-linux]'

end
