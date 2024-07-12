class DictionaryList
  attr_accessor :guess
  attr_reader :word

  def initialize
    @word = random_word
    @guess = ""
  end

  private
  def random_word
    filename = "./words/10000-english-words.txt"
    random_word = ""

    file = File.open(filename, "r")
    words = file.readlines
    file.close

    dictionary_list_size = words.size

    random_word = words[(rand*dictionary_list_size).floor]
  end
end

w = DictionaryList.new
puts w.word
