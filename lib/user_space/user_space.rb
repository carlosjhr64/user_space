module USER_SPACE
  class UserSpace

    OPTIONS    = {:config  => 'config',
                  :parser  =>  JSON,
                  :ext     =>  nil,
                  :version => 'VERSION'}

    PARAMETERS = {:appname  => File.basename($PROGRAM_NAME),
                  :appdir   => nil, # Can't guess at this point yet?
                  :xdgbases => ['CACHE', 'CONFIG', 'DATA']}

    attr_accessor :trace, :verbose
    attr_reader :appname, :appdir, :xdgbases, :options
    def initialize(parameters=PARAMETERS)

      @appname  = parameters[:appname]  || PARAMETERS[:appname]
      @appdir   = parameters[:appdir]   || PARAMETERS[:appdir]
      @xdgbases = parameters[:xdgbases] || PARAMETERS[:xdgbases]
      @options  = OPTIONS

      unless @appdir
        appdir = File.dirname File.dirname caller.first.split(/:/,2).first
        @appdir = File.expand_path appdir
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
          return unless overwrite
        else
          Dir.mkdir(userdir, 0700)
        end
        FileUtils.cp_r(Dir.glob("#{basedir}/*"), userdir) if File.directory? basedir
        FileUtils.chmod_R 'og-rwx', userdir
        FileUtils.chmod_R 'u+rwX',  userdir
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
    def config_file_name(options=@options)
      parser   = options[:parser]
      ext      = options[:ext] || parser.to_s.downcase
      basename = "#{options[:config]}.#{ext}"
      File.join XDG['CONFIG'].to_s, @appname, basename
    end

    # Not really for public use.
    def version_file_name
      File.join XDG['DATA'].to_s, @appname, @options[:version]
    end

    def config?(options=@options)
      File.exist?(config_file_name(options))
    end

    # Reads config
    def config(options=@options)
      options[:parser].parse File.read(config_file_name(options))
    rescue
      trace.puts $!.message    if trace
      vebose.puts $!.backtrace if verbose
      nil
    end

    # Saves config
    def config=(obj, options=@options)
      File.open(config_file_name, 'w', 0600){|fh| fh.puts options[:parser].pretty_generate obj}
    end

    def configures(hash, trace=nil)
      if config? # file exists
        config.each{|opt, value| hash[opt.to_sym] = value}
      else
        trace.puts config_file_name if trace
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
      trace.puts $!.message    if trace
      vebose.puts $!.backtrace if verbose
      nil
    end

    def version=(v)
      File.open(version_file_name, 'w', 0600){|fh| fh.puts v}
    end
  end
end
