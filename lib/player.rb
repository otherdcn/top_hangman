class Player
  attr_reader :name
  attr_accessor :score

  def initialize(name, score = 0)
    @name = name
    @score = score
  end
end

class Human < Player
  def initialize(name = "Human Joe", score = 0)
    super
  end
end

class Computer < Player
  attr_reader :name, :code

  def initialize(name = "Computer Carl", score = 0)
    super
  end
end

# player = Player.new("Ready Player One")
# dcn = Human.new("DCN")
# al = Computer.new("Al")

# [player, dcn, al].each do |element|
#   puts "Hi, I'm the #{element.class}, my name is #{element.name}. My score is #{element.score}"
#   puts ""
# end
