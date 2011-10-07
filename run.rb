require 'csv'

def system!(*args)
  system(*args) or raise "#{args.inspect} failed"
end

args = ARGV.join(' ')
system! "mysqldump -d #{args} >schema.sql"
system! "mysql #{args} -e'SHOW TABLE STATUS' >status.txt"

pv = `which pv`.chomp

CSV.foreach("status.txt", :headers => true, :col_sep => "\t") do |table|
  pv_command = "| #{pv} -N #{table["Name"]} -s #{table["Data_length"]}" if !pv.empty?
  system! "mysql #{args} -N -e'SELECT * FROM #{table["Name"]}' #{pv_command} >#{table["Name"]}.txt"
end