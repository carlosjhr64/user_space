Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '4.0.210113'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2021-01-13'
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
lib/user_space.rb
  )

  s.requirements << 'ruby: ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]'

end
