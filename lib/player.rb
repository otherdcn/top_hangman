class Player
  attr_reader :name
  attr_accessor :score

  def initialize(name)
    @name = name
    @score = 0
  end
end

class Human < Player
  def initialize(name = "Human Joe")
    super
  end
end

class Computer < Player
  attr_reader :name, :code

  def initialize(name = "Computer Carl")
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
