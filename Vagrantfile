# Set Vagrant auto port range to users. 
# This fix port collision problem. See more: https://github.com/mitchellh/vagrant/issues/272

port_range_by_user = {
  "jokor" => {
    :forward_port => 14000,
    :port_range => 14001..14049 },
  "epeli" => {
    :forward_port => 14050,
    :port_range => 14051..14099 },
  "tuomasjjrasanen" => {
    :forward_port => 14100,
    :port_range => 14101..14149 },
  "cjoohs" => {
    :forward_port => 14150,
    :port_range => 14151..14199 },
  "tuomasjjrasanen" => {
    :forward_port => 14200,
    :port_range => 14201..14249 },
  "vmlintu" => {
    :forward_port => 14250,
    :port_range => 14251..14299 },
  "juhaerk" => {
    :forward_port => 14300,
    :port_range => 14301..14349 },
  "mvuori" => {
    :forward_port => 14350 , 
    :port_range => 14351..14399 },
   "hannele" => {
     :forward_port => 14400,
     :port_range => 14401..14449 },
   "janne.saarela" => {
     :forward_port => 14450,
     :port_range => 14451..14499 },
}

Vagrant::Config.run do |config|
  user = ENV["USER"]

  unless port_range_by_user.has_key?(user)
    puts "User (#{user}) Vagrant port configuration not found! Edit '/virtual/vagrant-tools/Vagrantfile' file!"
    exit 1
  end

  puts "Set Vagrant port range: " + port_range_by_user[user].inspect
  config.vm.forward_port( 22,
                          port_range_by_user[user][:forward_port],
                          :name => "ssh",
                          :auto => true )
  config.vm.auto_port_range = (port_range_by_user[user][:port_range])
end
