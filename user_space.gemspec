Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '3.0.1'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2020-08-27'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Maintains the app's XDG features: app's cache, config, and data directories.
DESCRIPTION

  s.summary = <<SUMMARY
Maintains the app's XDG features: app's cache, config, and data directories.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
data/VERSION
lib/user_space.rb
  )

  s.add_runtime_dependency 'xdg', '= 2.2.3'
  s.requirements << 'ruby: ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]'

end
