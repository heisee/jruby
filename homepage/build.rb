#!/usr/local/bin/jruby
require "java"

module Xalan
  include_package "org.apache.xalan.xslt"
end

XalanProcess = Xalan::Process

puts "Transform pages:"

Dir.new('pages').grep(/\.xml$/).each {|i|
  j = "build/" + i.gsub(/\.xml$/, '.html')
  puts "#{i} => #{j}"
  XalanProcess.main(["-in", 'pages/' + i, "-xsl", "xsl/main.xsl", "-out", j])
}

puts "Generate News:"

`rm -r tmp`

XalanProcess.main(['-in', 'data/news.xml', '-xsl', 'xsl/news.xsl'])

Dir.new('tmp').grep(/^news.*\.xml$/).each {|name|
  html_name = name.gsub(/\.xml$/, '.html')
  puts "#{name} => build/#{html_name}"

  XalanProcess.main(['-in', 'tmp/' + name, '-xsl', 'xsl/main.xsl', '-out', 'build/' + html_name, '-HTML'])
}

puts "Copying images and other static data:"

Dir.new('images').each {|name|
  if name == '.' || name == '..'
    next
  end
  puts name
  `cp images/#{name} build/`
}
