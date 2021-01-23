def appdir3(lib='/lib')
  (_ = caller(1..2)[-1]&.split(':',2)&.fetch(0)) and File.dirname(File.dirname(File.expand_path(_)))&.chomp(lib)
end
def appdir4(lib='/lib')
  appdir3(lib)
end
def appdir5(lib='/lib')
  appdir4(lib)
end
