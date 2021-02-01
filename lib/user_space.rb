require 'fileutils'
# Requires:
#`ruby`

class UserSpace
  VERSION = '5.1.210201'
  XDG = {
    'cache'  => ENV['XDG_CACHE_HOME']  || File.expand_path('~/.cache'),
    'config' => ENV['XDG_CONFIG_HOME'] || File.expand_path('~/.config'),
    'data'   => ENV['XDG_DATA_HOME']   || File.expand_path('~/.local/share'),
  }

  def self.appdir(lib='/lib')
    (_ = caller(1..2)[-1]&.split(':',2)&.fetch(0)) and File.dirname(File.dirname(File.expand_path(_)))&.chomp(lib)
  end

  attr_reader :parser,:ext,:appname,:xdgbases,:appdir,:cfg
  def initialize( parser:,
                  appdir:   UserSpace.appdir,
                  ext:      parser.to_s.downcase,
                  appname:  File.basename($0),
                  xdgbases: ['cache', 'config', 'data'],
                  config:   'config')
    @parser,@ext,@appname,@xdgbases,@appdir,@cfg = parser,ext,appname,xdgbases,appdir,config
    install
  end

  def xdg_pairs
    @xdgbases.each do |base|
      # yield basedir, userdir
      yield File.join(@appdir, base), File.join(XDG[base], @appname)
    end
  end

  # Will not overwrite anything.
  # Only copies over missing directories and files.
  # Verifies directory expectations.
  def install
    xdg_pairs do |basedir, userdir|
      if File.exist?(userdir)
        # Sanity check
        assert_directory(userdir)
      else
        Dir.mkdir(userdir, 0700)
      end
      if File.directory? basedir
        Dir.glob("#{basedir}/**/*").each do |src|
          dest = src.sub(basedir, userdir)
          if File.exist? dest
            # Sanity checks
            assert_directory(dest) if File.directory? src
          else
            if File.directory? src
              Dir.mkdir dest
            else
              FileUtils.cp src, dest
            end
            FileUtils.chmod('u+rwX,go-rwx', dest)
          end
        end
      end
    end
  end

  def cachedir
    File.join XDG['cache'], @appname
  end

  def configdir
    File.join XDG['config'], @appname
  end

  def datadir
    File.join XDG['data'], @appname
  end

  def config_file_name
    File.join XDG['config'], @appname, "#{@cfg}.#{@ext}"
  end

  def config?
    File.exist?(config_file_name)
  end

  # Reads config
  def config
    @parser.load File.read(config_file_name)
  rescue
    $stderr.puts $!.message   if $VERBOSE
    $stderr.puts $!.backtrace if $DEBUG
    nil
  end

  # Saves config
  def config=(obj)
    dump = (@parser.respond_to?(:pretty_generate))? @parser.pretty_generate(obj) : @parser.dump(obj)
    File.open(config_file_name, 'w', 0600){|fh|fh.puts dump}
  end

  def configures(hash)
    if config? # file exists
      hash.merge! config
    else
      $stderr.puts config_file_name if $VERBOSE
      self.config = hash
    end
  end

  private

  def assert_directory(dir)
    raise "Not a directory: #{dir}" unless File.directory?(dir)
  end
end
