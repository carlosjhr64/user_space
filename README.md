# UserSpace

* [VERSION 5.2.230101](https://github.com/carlosjhr64/user_space/releases)
* [github](https://www.github.com/carlosjhr64/user_space)
* [rubygems](https://rubygems.org/gems/user_space)

## DESCRIPTION:

Maintains the user's cache, config, and data directories
with the gem-apps cache, config, and data files.

## SYNOPSIS:

```ruby
require 'rbon' # Using RBON(is not JSON!) parser for the config file.
require 'user_space'

module App
  # ::App::CONFIG is your app's configuration.
  CONFIG  = {:tts=>'espeak', }
  VERSION = '1.2.3'
end

USERSPACE = UserSpace.new(parser:RBON, appname:'myapp') #~> ^#<UserSpace:
# Will maintain these directories:
['~/.cache/myapp',
 '~/.config/myapp',
 '~/.local/share/myapp'
].all?{File.directory? File.expand_path _1} #=> true

if USERSPACE.config?
  # Update APP::CONFIG with user's preferences.
  App::CONFIG.merge! USERSPACE.config
else
  # Write initial configuration with App::CONFIG
  STDERR.puts "Writting '#{USERSPACE.config_file_name}'"
  USERSPACE.config = App::CONFIG
end
# To do the same thing, you can also say:
# USERSPACE.configures(App::CONFIG)
# We have a config file:
File.exist? File.expand_path '~/.config/myapp/config.rbon' #=> true
```

## INSTALL:

```shell
$ gem install user_space
```

## LICENSE:

(The MIT License)

Copyright (c) 2023 CarlosJHR64

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
