require 'csv'

def system!(*args)
  system(*args) or raise "#{args.inspect} failed"
end

args = ARGV.join(' ')

puts "Dumping schema..."
system! "mysqldump -d #{args} >schema.sql"

puts "Listing tables..."
system! "mysql #{args} -e'SHOW TABLE STATUS' >status.txt"

pv_path = `which pv`.chomp

CSV.foreach("status.txt", :headers => true, :col_sep => "\t") do |table|
  puts "Dumping #{table["Name"]}"
  pv_command = "| #{pv_path} -l -s #{table["Rows"]}" if !pv_path.empty?
  system! "mysql #{args} -N -e'SELECT * FROM #{table["Name"]}' #{pv_command} >#{table["Name"]}.txt"
end