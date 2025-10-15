require_relative 'book_library.rb'
require_relative 'user_manager.rb'
require_relative 'config'
require 'csv'

def ensure_file_path(file_path)
  File.new(file_path, 'w').close unless File.file?(file_path)
end

ensure_file_path(USER_DB_PATH)
ensure_file_path(BORROWED_DB_PATH)

puts 'Please enter your username:'
username=gets.chomp
user_manager=UserManager.new(USER_DB_PATH)

unless user_manager.user_exists?(username)
  user_manager.add_user(username)
end

puts "Welcome #{username}"



library = BookLibrary.new
CSV.foreach('data/books.csv', headers: true) do |row|
  library.add_book(Book.new(row['Book ID'].to_i, row['Book Name'], row['Author'], row['Release Year']))
end
library.load_borrowed_books


def main_menu(library, username)
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
end

main_menu(library, username)