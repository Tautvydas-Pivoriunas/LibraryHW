class UserManager
  def initialize(file_path)
    @file_path=file_path
  end

  def user_exists?(username)
    File.foreach(@file_path).any?{|line| line.chomp == username}
  end

  def add_user(username)
    File.open(@file_path, 'a') {|file| file.puts(username) }
    puts "User with the username: #{username} was not found creating a new user..."
  end
end