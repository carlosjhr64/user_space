Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '3.0.0'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2017-11-27'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Maintains the app's XDG features: app's cache, config, and data directories.
DESCRIPTION

  s.summary = <<SUMMARY
Maintains the app's XDG features: app's cache, config, and data directories.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ['--main', 'README.rdoc']

  s.require_paths = ['lib']
  s.files = %w(
README.rdoc
lib/user_space.rb
  )

  s.add_runtime_dependency 'xdg', '= 2.2.3'
  s.requirements << 'ruby: ruby 2.4.2p198 (2017-09-14 revision 59899) [x86_64-linux]'

end
