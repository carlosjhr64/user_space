require 'fileutils'
# Requires:
#`ruby`

class UserSpace
  VERSION = '4.0.210113'
  XDG = {
    CACHE:  ENV['XDG_CACHE_HOME']  || File.expand_path('~/.cache'),
    CONFIG: ENV['XDG_CONFIG_HOME'] || File.expand_path('~/.config'),
    DATA:   ENV['XDG_DATA_HOME']   || File.expand_path('~/.local/share'),
  }

  attr_reader :parser,:ext,:appname,:xdgbases,:appdir,:config
  def initialize( parser:,
                  ext:      parser.to_s.downcase,
                  appname:  File.basename($0),
                  xdgbases: [:CACHE, :CONFIG, :DATA],
                  appdir:   File.dirname(__dir__),
                  config:   'config')
    @parser,@ext,@appname,@xdgbases,@appdir,@config = parser,ext,appname,xdgbases,appdir,config
    install(false) # install with no overwrite
  end

  def xdg_pairs
    @xdgbases.each do |base|
      # yield basedir, userdir
      yield File.join(@appdir, base.to_s.downcase), File.join(XDG[base], @appname)
    end
  end

  # Note that initialize will not overwrite anything.
  # This overwrites the user's data directory with a fresh install.
  # App should consider being nice about this,
  # like warn the user or something.
  def install(overwrite=true)
    xdg_pairs do |basedir, userdir|
      if File.exist?(userdir)
        # Sanity check
        raise "Not a directory: #{userdir}" unless File.directory?(userdir)
        # Pre-existing directory.
        # Return unless user wants to overwrite.
        next unless overwrite
      else
        Dir.mkdir(userdir, 0700)
      end
      if File.directory? basedir
        Dir.glob("#{basedir}/**/*").each do |src|
          dest = src.sub(basedir, userdir)
          if File.directory? src
            Dir.mkdir dest unless File.exist? dest
          else
            FileUtils.cp src, dest
          end
          FileUtils.chmod('u+rwX,go-rwx', dest)
        end
      end
    end
  end

  def cachedir
    File.join XDG[:CACHE], @appname
  end

  def configdir
    File.join XDG[:CONFIG], @appname
  end

  def datadir
    File.join XDG[:DATA], @appname
  end

  # Not really for public use.
  def config_file_name
    File.join XDG[:CONFIG], @appname, "#{@config}.#{@ext}"
  end

  # Not really for public use.
  def version_file_name
    File.join XDG[:DATA], @appname, 'VERSION'
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
      config.each{|opt, value| hash[opt.to_sym] = value}
    else
      $stderr.puts config_file_name if $VERBOSE
      self.config = hash
    end
  end

  def version?
    File.exist?(version_file_name)
  end

  # This reads the data directory's version file
  def version
    File.read(version_file_name).strip
  rescue
    $stderr.puts $!.message   if $VERBOSE
    $stderr.puts $!.backtrace if $DEBUG
    nil
  end

  def version=(v)
    File.open(version_file_name, 'w', 0600){|fh| fh.puts v}
  end
end
