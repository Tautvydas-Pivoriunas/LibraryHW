require_relative 'models.rb'
require 'csv'

unless File.file?('data/users.db')
  File.new('data/users.db', 'w').close
end

unless File.file?('data/borrowed_books.db')
  File.new('data/borrowed_books.db', 'w').close
end

puts 'Please enter your username:'
username=gets.chomp

user_found = false
File.open('data/users.db', 'r') do |file|
  file.each_line do |line|
    if line.chomp == username
      puts "Welcome #{username}"
      user_found = true
      break
    end
  end
end

unless user_found
  puts "User with the username: #{username} was not found creating a new user..."
  File.open('data/users.db', 'a') do |file|
    file.puts(username)
  end
  puts 'New user created succesfully'
end


library = BookLibrary.new
CSV.foreach('data/books.csv', headers: true) do |row|
  library.add_book(Book.new(row['Book ID'].to_i, row['Book Name'], row['Author'], row['Release Year']))
end
library.load_borrowed_books

puts 'You can now:'
puts '1. See available books'
puts '2. Reserve a book'
puts '3. Return a book'
puts '4. Exit'

while true
  puts 'Choose an action'
  choice = gets.chomp.to_i

  case choice
  when 1
    puts 'Available books:'
    library.print_available_books
  when 2
    puts "To reserve a book, enter it's id from the list"
    id = gets.chomp.to_i
    puts library.borrow_book(id, username)
  when 3
    puts "To return a book, enter it's id from the list"
    id = gets.chomp.to_i
    puts library.return_book(id, username)
  when 4
    puts 'Goodbye!'
    exit
  else
    puts 'Invalid option, try again'
  end
end