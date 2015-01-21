def get_opr
    puts "Calculator\nEnter operation or \"Q\" for quit"
    puts "operation is +, -, *, /"
    opr = gets.chomp
    case opr
    when "*"
      puts "Multiply selected"
      when "/"
      puts "Divide selected"
    when "+"
      puts "Addition selected"
    when "-"
      puts "Subtraction selected"
    when "q", "Q"
    puts "Quiting"
    exit
    else
      return nil
    end
    opr
  end

  def get_num(seq)
    begin
        print "Enter the #{seq} number: "
        x = gets.chomp
        Float(x)
        rescue
          puts "You entered a string.  Please enter a number"
          nil
    end
end

while true do
   while (opr = get_opr) == nil do
    end
    error = false
    while (x = get_num("1st")) == nil do
    end
    while (y = get_num("2st")) == nil do
    end
    case opr
       when "+"
            z = x+y
       when "-"
            z = x-y
      when "*"
            z = x*y
      when "/"
          z = x/y
      end
   puts "\n#{x} #{opr} #{y} = #{z}\n\n\n"
end
