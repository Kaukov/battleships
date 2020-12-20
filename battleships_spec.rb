require 'rspec'
require 'pry'
require_relative 'battleships'

# Valid when we have the following vessels not touching:
# 1 Battleship (4 cells)
# 2 Cruisers (3 cells)
# 3 Destroyers (2 cells)
# 4 Submarines (1 cell)

describe "Battleships" do
  it 'is valid with all ships present and not touching' do
    Battleships.new(<<~EOF).should be_valid
      *----**---
      *-*-----*-
      *-*-***-*-
      *---------
      --------*-
      ----***---
      --------*-
      ---*------
      -------*--
      ----------
    EOF
  end

  it 'is not valid 2 battleships' do
    Battleships.new(<<~EOF).should_not be_valid
      *----**---
      *-*-----*-
      *-*-***-*-
      *---------
      --------*-
      ---****---
      --------*-
      ---*------
      -------*--
      ----------
    EOF
  end

  it 'is not valid with a ship missing' do
    Battleships.new(<<~EOF).should_not be_valid
      *----**---
      *-*-----*-
      *-*-***-*-
      *---------
      --------*-
      ----------
      --------*-
      ---*------
      -------*--
      ----------
    EOF
  end

  it 'is not valid with an extra ship' do
    Battleships.new(<<~EOF).should_not be_valid
      *----**---
      *-*-----*-
      *-*-***-*-
      *---------
      --------*-
      ----***---
      --------*-
      ---*------
      -------*--
      ---***----
    EOF
  end

  it 'is not valid with unidentified figure' do
    Battleships.new(<<~EOF).should_not be_valid
      -----**---
      --*-----*-
      --*-***-*-
      ----------
      --------*-
      *---***---
      **------*-
      *--*------
      -------*--
      ---***----
    EOF
  end

  it 'is not valid when two ships are touching' do
    Battleships.new(<<~EOF).should_not be_valid
      *----**---
      *-*-----*-
      *-*-***-*-
      *---------
      -----*----
      ----***---
      --------*-
      ---*------
      -------*--
      ---***----
    EOF
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |rspec|
    rspec.syntax = :should
  end
end
