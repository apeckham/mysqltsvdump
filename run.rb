def system!(*args)
  system(*args) or raise "#{args.inspect} failed"
end

args = ARGV.join(' ')
system! "mysqldump -d #{args} >schema.sql"

tables = `mysql #{args} -N -e'show tables'`.split
tables.each do |table|
  puts table
  system! "mysql #{args} -N -e'SELECT * FROM #{table}' >#{table}.txt"
end