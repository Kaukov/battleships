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

    find_ships
    find_ships transpose: true
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

  def find_ships(transpose: false)
    board_to_check = transpose ? @game_board.transpose : @game_board

    board_to_check.each_with_index do |row, row_idx|
      break unless @valid_board

      current_ship = 0

      row.each_with_index do |c, idx|
        break unless @valid_board

        current_ship += 1 if c == 1

        @valid_board = false if c == 1 && check_touching_ships?(idx, row_idx, board_to_check) || current_ship > SIZE_MAX

        if check_vertical_ship? c, idx, row_idx, board_to_check
          current_ship = 0
          next
        end

        next unless c.zero? || idx == row.length - 1

        next unless current_ship.positive?

        if current_ship == 1 && transpose
          current_ship = 0
          next
        end

        @ships[:"#{current_ship}"] += 1

        current_ship = 0
      end
    end
  end

  def check_vertical_ship?(current, idx, row_idx, board)
    ship_part_above = row_idx < board.length - 1 && board[row_idx + 1][idx] == 1
    ship_part_below = row_idx.positive? && board[row_idx - 1][idx] == 1

    current == 1 && (ship_part_above || ship_part_below)
  end

  def check_touching_ships?(idx, row_idx, board)
    top_left = row_idx.positive? && idx.positive? && board[row_idx - 1][idx - 1] == 1
    top_right = row_idx.positive? && idx < board[row_idx].length - 1 && board[row_idx - 1][idx + 1] == 1
    bottom_left = row_idx < board.length - 1 && idx.positive? && board[row_idx + 1][idx - 1] == 1
    bottom_right = row_idx < board.length - 1 && idx < board[row_idx].length - 1 && board[row_idx + 1][idx + 1] == 1

    top_left || top_right || bottom_left || bottom_right
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
