# UserSpace

* [VERSION 4.0.210113](https://github.com/carlosjhr64/user_space/releases)
* [github](https://www.github.com/carlosjhr64/user_space)
* [rubygems](https://rubygems.org/gems/user_space)

## DESCRIPTION:

Maintains the app's XDG features: app's cache, config, and data directories.

## SYNOPSIS:

```ruby
require 'json' # Using JSON parser for the config file.
require 'user_space'

module App
  # ::App::CONFIG is your app's configuration.
  CONFIG  = {:tts=>'espeak', }
  VERSION = '1.2.3'
end

USERSPACE = UserSpace.new(parser:JSON, appname:'myapp') #~> ^#<UserSpace:
# Will maintain these directories:
['~/.cache/myapp',
 '~/.config/myapp',
 '~/.local/share/myapp'
].all?{File.directory? File.expand_path _1} #=> true

# Unless this version has been installed,
# we copy over our data and cache directories.
USERSPACE.install unless USERSPACE.version == App::VERSION
# We have a version file:
File.exist? File.expand_path '~/.local/share/myapp/VERSION' #=> true

if USERSPACE.config?
  # Because JSON hashes by String, converting to Symbol.
  # We pad up App::CONFIG with user's preferences:
  USERSPACE.config.each{|opt, value| App::CONFIG[opt.to_sym] = value}
else
  # We initialize user preferences with our initial App::CONFIG
  STDERR.puts "Writting '#{USERSPACE.config_file_name}'"
  USERSPACE.config = App::CONFIG
end
# To do the same thing, you can also say:
# USERSPACE.configures(App::CONFIG)
# We have a config file:
File.exist? File.expand_path '~/.config/myapp/config.json' #=> true
```

## INSTALL:

```shell
$ gem install user_space
```

## LICENSE:

(The MIT License)

Copyright (c) 2021 CarlosJHR64

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
