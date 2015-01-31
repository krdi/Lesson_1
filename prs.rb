def get_human
    puts "Choose one (P/R/S): "
    x = gets.chomp.upcase
    case x
    when "P"
      print "You Picked Paper."
      return x
    when "R"
      print "You Picked Rock."
      return x
    when "S"
      print "You Picked Scissors."
    return x
  else
    return nil
  end
end

def get_computer
  x = rand(3)
  case x
  when 0
    puts " Computer Picked Paper."
    return "P"
  when 1
    puts " Computer Picked Rock"
    return "R"
  when 2
    puts " Computer PIcked Scissors"
    return "S"
  else
    return nil
  end
end

puts "Play Rock, Paper, Scissors?"
while true
  while (h = get_human) == nil
  end
  c = get_computer
  uc = h + c

  case uc
    when "PR", "RP"
      puts "Paper Wraps Rock"
    when "RS", "SR"
      puts "Rock Breaks Scissors"
    when "SP", "PS"
      puts "Scissors Cuts Paper"
  end

  case uc
    when "PR", "RS", "SP"
      puts "You Won!"
    when "RP", "SR", "PS"
      puts "Computer Won!"
    else
      puts "It's A Tie!"
  end

  puts "Play Again? (Y/N)"
  while true
    ans = gets.chomp.upcase
    case ans
    when "Y"
      break
    when "N"
      puts "\nBye\n"
      exit
    else
      puts "Please enter \"Y\" or \"N\""
    end
  end

end
