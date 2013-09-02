path = Pathname.new(File.expand_path(File.dirname(__FILE__)))
data_bag_path(path + "../data_bags")
encrypted_data_bag_secret "#{path}/encrypted_data_bag_secret"
