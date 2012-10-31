class Client < Resting

  def self.all
    puts "test"
    find(:all)
  end
  def self.full_hash
    clienthash = {}
    Client.all.each{|c| clienthash[c.name] = { :address => c.address, :environment => c.environment}}
    clienthash
  end
end
