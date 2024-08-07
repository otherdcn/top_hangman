class DictionaryList
  attr_accessor :guess
  attr_reader :word

  def initialize
    @word = random_word
    @guess = ""
  end

  def to_s
    word
  end

  def size
    word.size
  end

  def split(delimiter = "")
    word.split(delimiter)
  end

  private

  def random_word
    filename = "./words/10000-english-words.txt"

    file = File.open(filename, "r")
    words = file.readlines
    file.close

    dictionary_list_size = words.size

    words[(rand * dictionary_list_size).floor].chomp
  end
end

# w = DictionaryList.new
# puts w.word
