#!/usr/bin/env ruby

=begin
Learning Tic-Tac-Toe Program

Created by Mark Lidd

license is GNU Type 2

ttt.rb  Copyright (C) 2015  Mark Lidd

This program comes with ABSOLUTELY NO WARRANTY
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end


require 'pry'
require "json"

def read_brain
  if File.file?("./The_Brain")
    File.open("./The_Brain.json","r") do |f|
      JSON.Load(f)
    end
  else
    Hash.new
  end
  end

def write_brain(the_brain)
  File.open("./The_Brain.json", "w") do |f|
    f.write(the_brain.to_json)
  end
  end

def print_board (bd)
  puts "\n\n\n"
  puts "1  |2  |3  "
  puts " " + bd[0][0] +" | " + bd[0][1] + " | " + bd[0][2]
  puts "---|---|---"
  puts "4  |5  |6  "
  puts " " + bd[1][0] +" | " + bd[1][1] + " | " + bd[1][2]
  puts "---|---|---"
  puts "7  |8  |9   "
  puts " " + bd[2][0] +" | " + bd[2][1] + " | " + bd[2][2]
  end

def init_board #intialize board
  new_board = Array.new(3){Array.new(3," ")}
  return new_board
  end

def mem_copy(a) #copy board array to new array
  x = a[0].dup
  y = a[1].dup
  z = a[2].dup
  return [x,y,z]
  end

def get_human_move(bd, human)
  print_board(bd)
  puts "\nEnter Move (1-9) "
  begin
    begin
      human_move = gets.chomp
    end while human_move != human_move.to_i.to_s
  end until check_human_move(bd, human_move.to_i)
  human_move = human_move.to_i
  bd[(human_move-1) / 3][(human_move-1) % 3] = human
  return human_move.to_i
  end

def check_human_move(bd, human_move)
  hx = (human_move-1 )/ 3
  hy = (human_move-1) % 3
  if bd[hx][hy] == " " then return true else puts "Illegal move. Try Again. \nEnter an unocupied space" end
  end

def possible_moves_for_computer(board, computer)
  possible_board_positions = Array.new
  ipm = 0
  for ix in 0..2
    for iy in 0..2
      if board[ix][iy] == " "
        #possible move
        new_board = mem_copy(board)
        new_board[ix][iy] = computer
        possible_board_positions[ipm] = [new_board, ix, iy]
        ipm += 1
      end
    end
  end
  return possible_board_positions
  end

def get_best_computer_move(board, the_brain, computer)
  possible_board_positions = possible_moves_for_computer(board, computer)
  #puts "number of possible board positions  " + possible_board_positions.length.to_s
  a_board, a_ix, a_iy = possible_board_positions.sample #initialize score variables
  if the_brain.has_key?(a_board)
  else
    the_brain[a_board] = 0
  end
  max_move = [a_board, a_ix, a_iy]
  max_score = the_brain[a_board]
  max_ix = a_ix
  max_iy = a_iy
  possible_board_positions.each do |the_board, ix, iy|
    if !the_brain.has_key?(the_board) then the_brain[the_board] = 0 end #create the entry
    if max_score < the_brain[the_board]
      max_score = the_brain[the_board]
      max_move = [the_board, ix, iy]
    end
  end
  max_board = max_move[0]
  #  the_brain[max_board] += 1 #reward for making this move
  return max_move
  end

def evaluate_horiz(board, player)
  3.times do |row|
    row_count = 0
    3.times do |column|
      if board[row-1][column-1] == player then row_count += 1 end
    end
    if row_count == 3 then return true end
  end
  return false
  end

def evaluate_vert(board, player)
  3.times do |column|
    column_count = 0
    3.times do |row|
      if board[row-1][column-1] == player then column_count += 1 end
    end
    if column_count == 3 then return true end
  end
  return false
  end

def evaluate_diag(board, player)
  diag_count = 0
  3.times do |index|
    if board[index][index] == player
      diag_count += 1
    end
  end
  if diag_count == 3 then return true end
  diag_count = 0
  3.times do |index|
    if board[2-index][index] == player
      diag_count += 1
    end
  end
  if diag_count == 3 then return true else return false end
  end

def evaluate_tie(board, player)
  total_count = 0
  x_count = 0
  y_count = 0
  3.times do |column|
    3.times do |row|
      if board[row-1][column-1] == "X" then x_count += 1 end
      if board[row-1][column-1] == "O" then y_count += 1 end
    end
  end
  total_count = x_count + y_count
  if total_count == 9 then return true end
  return false
  end

def evaluate_board(the_board, player) #look for three in a row
  if evaluate_vert(the_board, player) then return true end
  if evaluate_horiz(the_board, player) then return true end
  if evaluate_diag(the_board, player) then return true end
  return false
  end

def reward(the_brain, the_game, delta_reward)
  game_reward = delta_reward
  the_game.each do|x|
    if the_brain.has_key?(x)
      the_brain[x] += game_reward #reward/punish the brain more for later (good/bad) moves
      game_reward += delta_reward
    end
  end
  end

#Start Game
ttt_brain = read_brain
games_won = 0
games_lost = 0
games_tied = 0
ask= "Play a game of Tic-Tac-Toe?"
loop do
  loop do
    puts "#{ask}: (Y/N)"
    ask = "Play Again?"
    play_game = gets.chomp.upcase
    if play_game.chomp == "N"
      puts "\n\nI Won #{games_won} Games\nYou Won #{games_lost} Games\nWe Tied #{games_tied} Games\n"
      write_brain(ttt_brain)
      exit
    end
    break if play_game == "Y"
    puts "Please enter \"Y\" for yes and \"N\" for no"
  end
  puts "Tossing coin to see who goes first.  You have \"heads\"......"
  coin_toss = ["Heads", "Tails"].sample
  #coin_toss = "Heads" #temporary
  #coin_toss = "Tails" #temporary
  puts coin_toss + " is showing."
  if coin_toss == "Heads"
    human = "X"
    computer = "O"
    next_move = "Human"
    puts "you go first and play \"X\"; I play \"O\""
  else
    human = "O"
    computer = "X"
    next_move = "Computer"
    puts "I go first and play \"X\"; You play \"O\""
  end

  game_board = init_board()
    game = Array.new
    loop do #play game
      if next_move == "Human"
        get_human_move(game_board, human)
        if evaluate_board(game_board, human)
          print_board(game_board)
          puts "\n\n You Won!!!!!\n\n"
          games_lost += 1
          reward(ttt_brain, game, -1) #punish the brain
          break
        end
        if evaluate_tie(game_board, human)
          print_board(game_board)
          puts"\n\n We Tied!!\n\n"
          games_tied += 1
          reward(ttt_brain, game, 0) #reward the brain
          break
        end
        next_move = "Computer"
      end
      if next_move == "Computer"
        best_move = get_best_computer_move(game_board, ttt_brain, computer)
  #      game_board = best_move[0] #doesn't work because arrays/hashes are only referenced
        x = best_move[1]
        y = best_move[2]
        game_board[x][y] = computer
        game.push(mem_copy(game_board)) #create a new object before save
        if evaluate_board(game_board, computer)
          print_board(game_board)
          puts "\n\n I Won!!!!!\n\n"
          games_won += 1
          reward(ttt_brain, game, 3)#reward the brain
          break
        end
        if evaluate_tie(game_board, human)
          print_board(game_board)
          puts"\n\n We Tied!!\n\n"
          games_tied += 1
          reward(ttt_brain, game, 2) #reward the brain
          break
        end
        next_move = "Human"
      end
    end
  end
