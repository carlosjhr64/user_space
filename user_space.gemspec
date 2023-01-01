Gem::Specification.new do |s|

  s.name     = 'user_space'
  s.version  = '5.2.230101'

  s.homepage = 'https://github.com/carlosjhr64/user_space'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2023-01-01'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Maintains the user's cache, config, and data directories
with the gem-apps cache, config, and data files.
DESCRIPTION

  s.summary = <<SUMMARY
Maintains the user's cache, config, and data directories
with the gem-apps cache, config, and data files.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
lib/user_space.rb
  )

  s.requirements << 'ruby: ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]'

end
