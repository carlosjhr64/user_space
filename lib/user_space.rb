require 'fileutils'
require 'xdg'
# Requires:
#`ruby`

class UserSpace
  VERSION = '3.0.1'

  def self.appdir
    appdir = File.dirname File.dirname caller_locations(1,1)[0].path
    appdir = File.dirname appdir if File.basename(appdir)=='lib'
    File.expand_path appdir
  end

  attr_reader :parser,:ext,:appname,:xdgbases,:appdir,:config
  def initialize(
    parser,
    ext: parser.to_s.downcase,
    appname: File.basename($0),
    xdgbases: ['CACHE', 'CONFIG', 'DATA'],
    appdir: UserSpace.appdir,
    config: 'config'
  )
    @parser,@ext,@appname,@xdgbases,@appdir,@config = parser,ext,appname,xdgbases,appdir,config
    install(false) # install with no overwrite
  end

  def xdg_pairs
    @xdgbases.each do |base|
      xdg = XDG[base].to_s
      userdir = File.join(xdg, @appname)
      basedir = File.join @appdir, base.downcase
      yield basedir, userdir
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
        glob = Dir.glob("#{basedir}/*")
        FileUtils.cp_r(glob, userdir)
        FileUtils.chmod_R('u+rwX,go-rwx', glob)
      end
    end
  end

  def cachedir
    File.join XDG['CACHE'].to_s, @appname
  end

  def configdir
    File.join XDG['CONFIG'].to_s, @appname
  end

  def datadir
    File.join XDG['DATA'].to_s, @appname
  end

  # Not really for public use.
  def config_file_name
    File.join XDG['CONFIG'].to_s, @appname, "#{@config}.#{@ext}"
  end

  # Not really for public use.
  def version_file_name
    File.join XDG['DATA'].to_s, @appname, 'VERSION'
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
    if self.config? # file exists
      self.config.each{|opt, value| hash[opt.to_sym] = value}
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
