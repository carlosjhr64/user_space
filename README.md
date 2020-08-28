# UserSpace

* [VERSION 3.0.2](https://github.com/carlosjhr64/user_space/releases)
* [github](https://www.github.com/carlosjhr64/user_space)
* [rubygems](https://rubygems.org/gems/user_space)

## DESCRIPTION:

Maintains the app's XDG features: app's cache, config, and data directories.

## SYNOPSIS:

    require 'json' # Using JSON parser for the config file.
    require 'user_space'
    # APP::CONFIG is your app's configuration.
    # Perhaps like...
    APP::CONFIG = {:tts=>'espeak', }
    USERSPACE = UserSpace.new(JSON)
    # Unless this version has been installed,
    # we copy over our data and cache directories.
    USERSPACE.install unless USERSPACE.version == APP::VERSION
    if USERSPACE.config?
      # Because JSON hashes by String, converting to Symbol.
      # We pad up APP::CONFIG with user's preferences:
      USERSPACE.config.each{|opt, value| APP::CONFIG[opt.to_sym] = value}
    else
      # We initialize user preferences with our initial APP::CONFIG
      STDERR.puts "Writting '#{USERSPACE.config_file_name}'"
      USERSPACE.config = APP::CONFIG
    end
    # To do the same thing, you can also say:
    # USERSPACE.configures(APP::CONFIG)

## INSTALL:

    sudo gem install user_space

## LICENSE:

(The MIT License)

Copyright (c) 2020 CarlosJHR64

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
