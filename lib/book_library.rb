require_relative 'models.rb'

class BookLibrary
  attr_reader :books

  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end

  def print_available_books
    @books.each do |book|
      if !book.reserved
        puts book.to_s
      end
    end
  end

  def borrow_book(book_id, username)
    book=@books.find{|b| b.id==book_id && !b.reserved}
    raise BookNotAvailableError.new(book_id) unless book
    
    book.reserved = true
    save_borrowed_book(book, username)
    "You have successfully borrowed #{book.name}."
    
    rescue BookNotAvailableError => e
      puts e.message

  end

  def return_book(book_id, username)
    book=@books.find{|b| b.id==book_id && b.reserved}
    return 'Book not found or not borrowed' unless book

    book.reserved = false
    remove_borrowed_book(book, username)
    "You have successfully returned #{book.name}"
  end

  def save_borrowed_book(book, username)
    File.open(BORROWED_DB_PATH, 'a') do |file|
      file.puts("#{book.id}, #{username}")
    end
  end

  def remove_borrowed_book(book, username)
    current_borrowed = []
    File.open(BORROWED_DB_PATH, 'r') do |file|
      current_borrowed = file.readlines.reject do |line|
         id, user = line.chomp.split(',').map { |element| element.strip }
         id.to_i == book.id && user == username
      end
    end
    File.open('data/borrowed_books.db', 'w') do |file|
      current_borrowed.each {|line| file.puts(line)}
    end
  end

  def load_borrowed_books
    File.open(BORROWED_DB_PATH, 'r') do |file|
      file.each_line do |line|
        id, name = line.chomp.split(',').map { |element| element.strip }
        book = @books.find{|b| b.id == id.to_i}
        book.reserved = true if book
      end
    end
  end
end