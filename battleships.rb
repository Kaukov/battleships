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
    @valid_board = true

    # Array to be filled with 0s and 1s depending
    # on the board placement of the battleships
    @game_board = []

    # Count all ship types on the board
    @ships = {
      "#{SIZE_BATTLESHIP}": 0,
      "#{SIZE_CRUISER}": 0,
      "#{SIZE_DESTROYER}": 0,
      "#{SIZE_SUBMARINE}": 0
    }

    # Fill the game board with 0s and 1s by reading each line of the input string
    input.lines.each_with_index { |str| @game_board << ships_from_string(str) }
  end

  # Returns an array of 0s and 1s, indicating battleship placements
  # from a string of battleship placement characters
  def ships_from_string(str)
    arr = []

    str.chars.each do |ch|
      arr << 1 if ch == CHAR_SHIP
      arr << 0 if ch == CHAR_EMPTYSPACE
    end

    arr
  end

  def valid_ship_counts?
    return false if (@ships[:"#{SIZE_BATTLESHIP}"] <=> COUNT_BATTLESHIPS) != 0
    return false if (@ships[:"#{SIZE_CRUISER}"] <=> COUNT_CRUISERS) != 0
    return false if (@ships[:"#{SIZE_DESTROYER}"] <=> COUNT_DESTROYERS) != 0
    return false if (@ships[:"#{SIZE_SUBMARINE}"] <=> COUNT_SUBMARINES) != 0

    true
  end

  def valid?
    return false unless valid_ship_counts?

    @valid_board
  end
end
