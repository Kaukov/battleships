# frozen_string_literal: true

require 'pry'

# Battleships game board validator
class Battleships
  # Battleship and empty space characters used in the input string
  CHAR_SHIP = '*'
  CHAR_EMPTYSPACE = '-'

  # Ship types and properties:
  # Each ship should have its name in singular, and be a hash
  # with properties :size and :count, each representing the spaces a ship
  # takes on the board, and how many of the ship type are allowed on the board
  SHIP_DEFINITIONS = {
    BATTLESHIP: { size: 4, count: 1 },
    CRUISER: { size: 3, count: 2 },
    DESTROYER: { size: 2, count: 3 },
    SUBMARINE: { size: 1, count: 4 }
  }.freeze

  def initialize(input)
    # Valid board flag
    @valid_board = true

    # Array to be filled with 0s and 1s depending
    # on the board placement of the battleships
    @game_board = []

    # Count all ship types on the board
    @ships = SHIP_DEFINITIONS.each_with_object({}) { |(_k, v), memo| memo[v[:size].to_s] = 0 }

    # The max ship size from all allowed ships
    @max_ship_size = SHIP_DEFINITIONS[:BATTLESHIP][:size]
    # @max_ship_size = SHIP_DEFINITIONS.map { |_s, v| v[:size] }.max

    # Fill the game board with 0s and 1s by reading each line of the input string
    input.lines.each_with_index { |str| @game_board << ships_from_string(str) }

    # Do some magic and check if the input board is valid
    # First check the board as normal, then transpose the array and check again
    # This avoids the need to implement logic for checking for vertical ships
    # but traverses the whole board twice
    find_ships
    find_ships transpose: true
  end

  # Returns an array of 0s and 1s, indicating battleship placements
  # from a string of battleship placement characters
  # @param [String] str - A single line string containing CHAR_SHIP and CHAR_EMPTYSPACE, ending with a new line
  # @return [Enumerable]
  def ships_from_string(str)
    arr = []

    str.chars.each do |ch|
      arr << 1 if ch == CHAR_SHIP
      arr << 0 if ch == CHAR_EMPTYSPACE
    end

    arr
  end

  # Traverses the whole board, be it normal or transposed,
  # and checks for valid ship positions, sizes, and count
  # @param [Boolean] transpose - Whether to transpose the @game_board or not
  # @return [void]
  def find_ships(transpose: false)
    # Define which board we'll be checking - the normal one, or the transposed one
    board_to_check = transpose ? @game_board.transpose : @game_board

    # Go over each board row, find ships and check if ships are touching
    board_to_check.each_with_index do |row, row_idx|
      break unless @valid_board

      # Counter for a single ship's size
      current_ship = 0

      # Go over each row entry and check for ship parts, or if ships are touching
      row.each_with_index do |c, idx|
        break unless @valid_board

        # Add to the counter if a ship part is found
        current_ship += 1 if c == 1

        # If the current ship part is touching another ship part,
        # or if the current ship size is larger than the @max_ship_size,
        # set the @valid_board flag to false
        @valid_board = false if check_touching_ships?(c, idx, row_idx, board_to_check) || current_ship > @max_ship_size

        # Checks if the current ship being checked is vertical,
        # if so - reset the counter and continue looking for other ships
        if check_vertical_ship? c, idx, row_idx, board_to_check
          current_ship = 0
          next
        end

        # Skips to the next iteration unless the current element is not a ship part,
        # or it's the last element of the row, or if the counter is 0
        next unless (c.zero? || idx == row.length - 1) && current_ship.positive?

        # If it's a submarine (size 1) and a transposed board is being checked,
        # reset the counter and skip to the next iteration
        # since submarines are already counted when the normal board
        # is being checked
        if current_ship == 1 && transpose
          current_ship = 0
          next
        end

        # Increases the count of a ship with size current_ship
        # in the @ships hash
        @ships[current_ship.to_s] += 1

        # Reset the ship size counter
        current_ship = 0
      end
    end
  end

  # Checks if a given ship is vertically positioned
  # @param [Numeric] current - The current character is either a ship part or not
  # @param [Numeric] idx - The index of the current character being checked
  # @param [Numeric] row_idx - The index of the row being checked from the board array
  # @param [Enumerable] board - The current board being checked - either normal or transposed
  # @return [Boolean]
  def check_vertical_ship?(current, idx, row_idx, board)
    # Flag if a ship part is present above the current ship part being checked
    ship_part_above = row_idx < board.length - 1 && board[row_idx + 1][idx] == 1

    # Flag if a ship part is present below the current ship part being checked
    ship_part_below = row_idx.positive? && board[row_idx - 1][idx] == 1

    # Returns true if the current character is a ship part
    # and a ship part is present either above or below the current character
    current == 1 && (ship_part_above || ship_part_below)
  end

  # Checks if a current ship part is touching another ship part either
  # above on the left and/or on the right,
  # or below on the left and/or on the right
  # @param [Numeric] current - The current character is either a ship part or not
  # @param [Numeric] idx - The index of the current character being checked
  # @param [Numeric] row_idx - The index of the row being checked from the board array
  # @param [Enumerable] board - The current board being checked - either normal or transposed
  # @return [Boolean]
  def check_touching_ships?(current, idx, row_idx, board)
    # Flag describing if a ship part is touching another ship part on either
    # the top left and/or the top right
    top_touching = check_top_touching_part? idx, row_idx, board

    # Flag describing if a ship part is touching another ship part on either
    # the bottom left and/or the bottom right
    bottom_touching = check_bottom_touching_part? idx, row_idx, board

    # Returns true if either top and/or bottom touching conditions are true
    current == 1 && (top_touching || bottom_touching)
  end

  # Checks if a current ship part is touching another ship part on either
  # the top left and/or the top right
  # @param [Numeric] idx - The index of the current character being checked
  # @param [Numeric] row_idx - The index of the row being checked from the board array
  # @param [Enumerable] board - The current board being checked - either normal or transposed
  # @return [Boolean]
  def check_top_touching_part?(idx, row_idx, board)
    # If the current row index is bigger than 1, check the previous (top) row for ship parts
    if row_idx.positive?
      # Returns true if there's a ship part on the top left
      return true if idx.positive? && board[row_idx - 1][idx - 1] == 1

      # Returns true if there's a ship part on the top right
      return true if idx < board[row_idx].length - 1 && board[row_idx - 1][idx + 1] == 1
    end

    # The current row is the first (0) row and can't be checked
    false
  end

  # Checks if a current ship part is touching another ship part on either
  # the bottom left and/or the bottom right
  # @param [Numeric] idx - The index of the current character being checked
  # @param [Numeric] row_idx - The index of the row being checked from the board array
  # @param [Enumerable] board - The current board being checked - either normal or transposed
  # @return [Boolean]
  def check_bottom_touching_part?(idx, row_idx, board)
    # If the current row index is less than the board length, check the next (bottom) row for ship parts
    if row_idx < board.length - 1
      # Returns true if there's a ship part on the bottom left
      return true if idx.positive? && board[row_idx + 1][idx - 1] == 1

      # Returns true if there's a ship part on the bottom right
      return true if idx < board[row_idx].length - 1 && board[row_idx + 1][idx + 1] == 1
    end

    # The current row is the last row and can't be checked
    false
  end

  # Goes over the @ships hash and checks if found ships on the board
  # are the correct amount as defined in the SHIP_DEFINITIONS hash
  # @return [Boolean]
  def valid_ship_counts?
    # Go over each ship defined in SHIP_DEFINITIONS
    # and check if the @ships hash for a given :size has the correct count value
    # Returns false if a ship doesn't have the correct count on the board
    SHIP_DEFINITIONS.each { |_k, v| return false if (@ships[v[:size].to_s] <=> v[:count]) != 0 }

    true
  end

  # Is the given input board valid or not
  # @return [Boolean]
  def valid?
    # Returns false if valid_ship_counts? returns false
    return false unless valid_ship_counts?

    # Returns the value of the @valid_board flag
    @valid_board
  end
end
