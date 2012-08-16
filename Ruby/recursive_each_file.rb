#! /usr/bin/env ruby

##### some comment
def do_it(path,file,level,more='')
  res=path+'/'+file
  #p more+res #if res.index 'user'
  
  if res[-3..-1] == 'erb'
    command = "html2haml #{res} > #{res[0..-4] + 'haml'}"
    p command
    `#{command}`
  end
end

def rec_each_file( path,level=0)
  Dir.new(path).each do |file|
    #p ">>>>>>  #{path}   #{file}  >>>>>>>>"
    if File.directory? path+'/'+file
      rec_each_file(path+'/'+file,level+1)  unless file=='..' or file=='.'
    else
      do_it path, file, level   unless file=='..' or file=='.'
    end
  end
end

#####################################

path=$*[0]
raise ArgumentError,'You need to provide the path' if path==nil

rec_each_file path[0..-2]
