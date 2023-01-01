require_relative 'appdir/appdir.rb'

def appdir1
  UserSpace.appdir
end

def appdir2
  appdir1
end

def appdir3
  appdir2
end

DIR1 = appdir1
DIR2 = appdir2
DIR3 = appdir3
DIR4 = appdir4
DIR5 = appdir5
DIR6 = appdir6
