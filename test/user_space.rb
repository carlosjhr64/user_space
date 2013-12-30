require 'test/unit'
require 'tmpdir'
TMPDIR      = Dir.mktmpdir
Dir.mkdir File.join TMPDIR, '.cache'
Dir.mkdir File.join TMPDIR, '.config'
Dir.mkdir File.join TMPDIR, '.local'
Dir.mkdir File.join TMPDIR, '.local', 'share'
APPNAME     = 'ima2awesome'

ENV['HOME'] = TMPDIR
$0          = APPNAME

# Needed to setup the enviroment first, now...
require 'user_space'

class TestUserSpace < Test::Unit::TestCase

  include USER_SPACE

  def test_user_space_version
    assert_equal('0.1.0', VERSION)
  end

  def test_user_space_constants
    assert_equal 'config',  UserSpace::OPTIONS[:config]
    assert_equal JSON,      UserSpace::OPTIONS[:parser]
    assert_equal 'VERSION', UserSpace::OPTIONS[:version]
    assert_nil   UserSpace::OPTIONS[:ext]

    assert_equal 'ima2awesome', UserSpace::PARAMETERS[:appname]

    xdgbases = UserSpace::PARAMETERS[:xdgbases]
    assert xdgbases.include? 'CACHE'
    assert xdgbases.include? 'CONFIG'
    assert xdgbases.include? 'DATA'
  end

  def test_user_space_new
    userspace = nil
    assert_nothing_raised(Exception){userspace = UserSpace.new}

    assert_equal(APPNAME, userspace.appname)

    dirname = File.dirname File.dirname File.expand_path __FILE__
    assert_equal(dirname, userspace.appdir)

    xdgbases = userspace.xdgbases
    assert(userspace.xdgbases.include?('CACHE'))
    assert(userspace.xdgbases.include?('CONFIG'))
    assert(userspace.xdgbases.include?('DATA'))

    count = 0
    userspace.xdg_pairs do |basedir, userdir|
      count += 1
      assert(File.directory?(userdir))
      refute_nil(userdir=~/\/ima2awesome$/)
      refute_nil(basedir=~/user_space\/((data)|(config)|(cache))$/)
    end
    assert_equal(3, count)

    options = userspace.options
    assert_equal('config',  options[:config])
    assert_equal('VERSION', options[:version])
    assert_equal(JSON,      options[:parser])
    assert_nil(options[:ext])

    cachedir, configdir, datadir = userspace.cachedir, userspace.configdir, userspace.datadir
    assert File.exist? cachedir
    assert File.exist? configdir
    assert File.exist? datadir

    version = File.read('data/VERSION').strip
    assert_equal version, userspace.version

    config_file_name = userspace.config_file_name
    refute File.exist? config_file_name
    config1 = {'a'=>"A", 'b'=>"B"}
    userspace.config = config1
    assert File.exist? config_file_name
    config2 = JSON.parse File.read config_file_name
    assert_equal config1, config2

    # Overwrite version file...
    version_file_name = userspace.version_file_name
    File.open(version_file_name, 'w'){|fh|fh.puts 'A.B.C'}
    # Now we get the version given to the file:
    assert_equal 'A.B.C', userspace.version
    # Which is different from the initial version
    refute version == 'A.B.C'

    # But we can re-fresh our install
    assert_nothing_raised(Exception){userspace.install}
    # Now we have our initial version back
    assert_equal version, userspace.version

    [config_file_name, version_file_name].each do |fn|
      stat = File.stat(fn)
      assert_equal stat.mode.to_s(8), '100600'
    end

    [cachedir, configdir, datadir].each do |dn|
      stat = File.stat(dn)
      assert_equal stat.mode.to_s(8), '40700'
    end

  end
end
