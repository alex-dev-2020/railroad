line_num = 0
input = ""

loop do
  print "#{line_num += 1}?: "
  # убираем символ перевода строки
  line = gets
  # убираем пробелы методом .strip
  break if line.strip == "exit"
  # условие для вычисления - пустая строка
  if line.strip == ""
    # обозначаем, чтовычисление производится
    puts "Evaluating..."
    # результат вычислений
    puts eval(input)
  else
    #накопление кода
    input += line
  end
end
