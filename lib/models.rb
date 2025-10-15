class Book
  attr_reader :id, :name, :author, :year
  attr_accessor :reserved

  def initialize(id, name, author, year)
    @id = id.to_i
    @name = name
    @author = author
    @year = year
    @reserved = false
  end

  def to_s
    "#{@id} #{@name} by #{@author} (#{@year})"
  end
end

class BookLibrary
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

  def get_book(id)
    @books.find {|book| book.id == id}
  end

  def borrow_book(book_id, username)
    book=@books.find{|b| b.id==book_id && !b.reserved}
    return 'Book is unavailable for reserving' unless book
    
    book.reserved = true
    save_borrowed_book(book, username)
    "You have successfully borrowed #{book.name}."
  end

  def return_book(book_id, username)
    book=@books.find{|b| b.id==book_id && b.reserved}
    return 'Book not found or not borrowed' unless book

    book.reserved = false
    remove_borrowed_book(book, username)
    "You have successfully returned #{book.name}"
  end

  def save_borrowed_book(book, username)
    File.open('data/borrowed_books.db', 'a') do |file|
      file.puts("#{book.id}, #{username}")
    end
  end

  def remove_borrowed_book(book, username)
    current_borrowed = []
    File.open('data/borrowed_books.db', 'r') do |file|
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
    File.open('data/borrowed_books.db', 'r') do |file|
      file.each_line do |line|
        id, name = line.chomp.split(',').map { |element| element.strip }
        book = @books.find{|b| b.id == id.to_i}
        book.reserved = true if book
      end
    end
  end
end