module FileUtils
  class << self
    def user_space_cpr(src, dest)
      fu_each_src_dest(src, dest) do |s, d|
        copy_entry(s, d)
        chmod('u+rwX,go-rwx', d)
      end
    end
  end
end

class UserSpace
  OPTIONS = {
    config:  'config',
    version: 'VERSION',
    ext:     nil,
    parser:  nil,
  }
  ['JSON','YAML','Marshal'].each do |parser|
    begin
      OPTIONS[:parser] = Object.const_get parser
      $stderr.puts "USER_SPACE will use #{parser} by default." if $VERBOSE
      break
    rescue NameError
      $stderr.puts "#{parser} was not available for USER_SPACE." if $DEBUG
    end
  end

  PARAMETERS = {
    appname:  File.basename($0),
    appdir:   nil, # Can't guess at this point yet?
    xdgbases: ['CACHE', 'CONFIG', 'DATA'],
  }

  attr_reader :appname, :appdir, :xdgbases, :options
  def initialize(parameters=PARAMETERS)

    @appname  = parameters[:appname]  || PARAMETERS[:appname]
    @appdir   = parameters[:appdir]   || PARAMETERS[:appdir]
    @xdgbases = parameters[:xdgbases] || PARAMETERS[:xdgbases]
    @options  = OPTIONS.dup

    unless @appdir
      appdir = File.dirname File.dirname caller_locations(1,1)[0].path
      appdir = File.dirname appdir if File.basename(appdir)=='lib'
      @appdir = File.expand_path appdir
      $stderr.puts "UserSpace#appdir=\"#{@appdir}\" # heuristics used" if $VERBOSE
    end

    # install with no overwrite
    install(false)
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
      FileUtils.user_space_cpr(Dir.glob("#{basedir}/*"), userdir) if File.directory? basedir
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
    parser   = @options[:parser]
    ext      = @options[:ext] || parser.to_s.downcase
    basename = "#{@options[:config]}.#{ext}"
    File.join XDG['CONFIG'].to_s, @appname, basename
  end

  # Not really for public use.
  def version_file_name
    File.join XDG['DATA'].to_s, @appname, @options[:version]
  end

  def config?
    File.exist?(config_file_name)
  end

  # Reads config
  def config
    p, d = @options[:parser], File.read(config_file_name)
    p.load(d)
  rescue
    $stderr.puts $!.message   if $VERBOSE
    $stderr.puts $!.backtrace if $DEBUG
    nil
  end

  # Saves config
  def config=(obj)
    p = @options[:parser]
    d = (p.respond_to?(:pretty_generate))? p.pretty_generate(obj) : p.dump(obj)
    File.open(config_file_name, 'w', 0600){|fh| fh.puts d}
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
