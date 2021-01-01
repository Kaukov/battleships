require 'pry'

class Battleships
  # Battleship and empty space characters used in the input string
  CHAR_SHIP = '*'
  CHAR_EMPTYSPACE = '-'

  # Define how many ships of type in total are allowed on the board
  COUNT_BATTLESHIPS = 1
  COUNT_CRUISERS = 2
  COUNT_DESTROYERS = 3
  COUNT_SUBMARINES = 4

  # Define the size of all allowed ships
  SIZE_BATTLESHIP = 4
  SIZE_CRUISER = 3
  SIZE_DESTROYER = 2
  SIZE_SUBMARINE = 1

  # The max ship size from all allowed ships
  SIZE_MAX = SIZE_BATTLESHIP

  def initialize(input)
  end

  def valid?
    true
  end
end
