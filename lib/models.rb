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

class BookNotAvailableError < StandardError
  def initialize(book_id)
    super("Book ID##{book_id} is not available to be borrowed")
  end
end