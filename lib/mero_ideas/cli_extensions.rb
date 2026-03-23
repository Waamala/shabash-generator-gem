module MeroIdeas
  module CLIUtils
    def self.colorize(text, color)
      colors = {
        red: 31,
        green: 32,
        yellow: 33,
        blue: 34,
        magenta: 35,
        cyan: 36,
        white: 37
      }
      
      code = colors[color]
      code ? "\e[#{code}m#{text}\e[0m" : text
    end

    def self.progress_bar(current, total, width = 50)
      percent = current.to_f / total
      filled = (percent * width).to_i
      bar = "[" + "=" * filled + " " * (width - filled) + "]"
      "#{bar} #{(percent * 100).to_i}%"
    end

    def self.confirm_prompt(message)
      print "#{colorize(message, :yellow)} (y/n): "
      gets.chomp.downcase == 'y'
    end

    def self.select_from_list(items, prompt = "Выберите:")
      return nil if items.empty?
      
      puts prompt
      items.each_with_index do |item, index|
        puts "#{index + 1}. #{item}"
      end
      
      print "Ваш выбор (1-#{items.length}): "
      choice = gets.chomp.to_i
      
      choice.between?(1, items.length) ? items[choice - 1] : nil
    end
  end
end