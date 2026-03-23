require "optparse"
require "json"
require "fileutils"

module MeroIdeas
  class CLI
    def initialize
      @options = {
        count: 1,
        format: nil,
        type: nil,
        save: nil,
        interactive: false,
        json: false,
        help: false
      }
    end

    def run(args)
      parse_options!(args)
      
      if @options[:help]
        show_help
        return
      end

      if @options[:interactive]
        interactive_mode
        return
      end

      generate_ideas
    end

    private

    def parse_options!(args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: mero-ideas [options]"
        
        opts.on("-c", "--count NUM", Integer, "Количество идей (по умолчанию: 1)") do |count|
          @options[:count] = count
        end

        opts.on("-t", "--type TYPE", [:business, :social, :educational, :team_building], 
                "Тип мероприятия (business, social, educational, team_building)") do |type|
          @options[:type] = type.to_s
        end

        opts.on("-f", "--format FORMAT", "Фильтр по формату") do |format|
          @options[:format] = format
        end

        opts.on("-s", "--save FILE", "Сохранить результат в файл") do |file|
          @options[:save] = file
        end

        opts.on("-j", "--json", "Вывод в JSON формате") do
          @options[:json] = true
        end

        opts.on("-i", "--interactive", "Интерактивный режим") do
          @options[:interactive] = true
        end

        opts.on("-h", "--help", "Показать справку") do
          @options[:help] = true
        end

        opts.on("-v", "--version", "Показать версию") do
          puts "mero-ideas version #{MeroIdeas::VERSION}"
          exit
        end
      end

      parser.parse!(args)
    end

    def generate_ideas
      generator = MeroIdeas::Generator.new
      
      if @options[:type]
        ideas = generator.generate_by_type(@options[:type], @options[:count])
      else
        filter = {}
        filter[:format] = [@options[:format]] if @options[:format]
        ideas = generator.generate(count: @options[:count], filter: filter)
      end

      output_ideas(ideas)
      save_to_file(ideas) if @options[:save]
    end

    def output_ideas(ideas)
      if @options[:json]
        puts JSON.pretty_generate(ideas)
      else
        ideas.each_with_index do |idea, index|
          puts format_idea(idea, index + 1)
        end
      end
    end

    def format_idea(idea, number)
      output = []
      output << "=" * 60
      output << "Идея мероприятия ##{number}"
      output << "=" * 60
      output << "📌 Название: #{idea[:title]}"
      output << "📋 Формат: #{idea[:format]}"
      output << "🎯 Тема: #{idea[:theme]}"
      output << "⚡ Активность: #{idea[:activity]}"
      output << "👥 Аудитория: #{idea[:audience]}"
      output << "📍 Локация: #{idea[:location]}"
      output << "📝 Описание: #{idea[:description]}"
      output << "🏷️  Теги: #{idea[:tags].join(', ')}"
      output << ""
      output.join("\n")
    end

    def interactive_mode
      puts "=" * 60
      puts "Генератор идей для мероприятий"
      puts "=" * 60
      puts "Введите параметры (оставьте пустым для случайного выбора)"
      puts ""

      generator = MeroIdeas::Generator.new
      
      loop do
        puts "\n" + "-" * 60
        puts "1. Сгенерировать новую идею"
        puts "2. Сгенерировать по типу мероприятия"
        puts "3. Показать доступные категории"
        puts "4. Выйти"
        print "\nВыберите действие (1-4): "
        
        choice = gets.chomp
        
        case choice
        when "1"
          generate_interactive_idea(generator)
        when "2"
          generate_by_type_interactive(generator)
        when "3"
          show_categories(generator)
        when "4"
          puts "До свидания!"
          break
        else
          puts "Неверный выбор. Попробуйте снова."
        end
      end
    end

    def generate_interactive_idea(generator)
      puts "\n--- Создание новой идеи ---"
      
      print "Формат (Enter - случайный): "
      format_input = gets.chomp
      
      print "Тема (Enter - случайный): "
      theme_input = gets.chomp
      
      print "Активность (Enter - случайный): "
      activity_input = gets.chomp
      
      print "Аудитория (Enter - случайный): "
      audience_input = gets.chomp
      
      print "Локация (Enter - случайный): "
      location_input = gets.chomp
      
      filter = {}
      filter[:format] = [format_input] unless format_input.empty?
      filter[:theme] = [theme_input] unless theme_input.empty?
      filter[:activity] = [activity_input] unless activity_input.empty?
      filter[:audience] = [audience_input] unless audience_input.empty?
      filter[:location] = [location_input] unless location_input.empty?
      
      idea = generator.generate(count: 1, filter: filter).first
      
      puts "\n" + format_idea(idea, 1)
      
      print "\nСохранить в файл? (y/n): "
      if gets.chomp.downcase == 'y'
        print "Имя файла (по умолчанию idea.txt): "
        filename = gets.chomp
        filename = "idea.txt" if filename.empty?
        save_to_file([idea], filename)
      end
    end

    def generate_by_type_interactive(generator)
      puts "\n--- Генерация по типу мероприятия ---"
      puts "Доступные типы:"
      puts "1. business (бизнес)"
      puts "2. social (социальные)"
      puts "3. educational (образовательные)"
      puts "4. team_building (тимбилдинг)"
      print "Выберите тип (1-4): "
      
      type_map = {
        "1" => "business",
        "2" => "social",
        "3" => "educational",
        "4" => "team_building"
      }
      
      type = type_map[gets.chomp]
      
      if type
        print "Количество идей (1-10): "
        count = gets.chomp.to_i
        count = 1 if count < 1
        count = 10 if count > 10
        
        ideas = generator.generate_by_type(type, count)
        
        ideas.each_with_index do |idea, index|
          puts "\n" + format_idea(idea, index + 1)
        end
        
        print "\nСохранить все идеи в файл? (y/n): "
        if gets.chomp.downcase == 'y'
          print "Имя файла (по умолчанию ideas.txt): "
          filename = gets.chomp
          filename = "ideas.txt" if filename.empty?
          save_to_file(ideas, filename)
        end
      else
        puts "Неверный выбор"
      end
    end

    def show_categories(generator)
      puts "\n--- Доступные категории ---"
      puts "Форматы: #{generator.formats.all.join(', ')}"
      puts "\nТемы: #{generator.themes.all.join(', ')}"
      puts "\nАктивности: #{generator.activities.all.join(', ')}"
      puts "\nАудитории: #{generator.audiences.all.join(', ')}"
      puts "\nЛокации: #{generator.locations.all.join(', ')}"
      
      print "\nНажмите Enter для продолжения..."
      gets
    end

    def save_to_file(ideas, filename = nil)
      filename ||= @options[:save]
      
      if filename.nil?
        timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
        filename = "mero_ideas_#{timestamp}.txt"
      end
      
      content = if @options[:json] || filename.end_with?('.json')
                  JSON.pretty_generate(ideas)
                else
                  ideas.each_with_index.map do |idea, index|
                    format_idea(idea, index + 1)
                  end.join("\n\n")
                end
      
      File.write(filename, content)
      puts "\n💾 Идеи сохранены в файл: #{filename}"
    end

    def show_help
      puts <<~HELP
        #{OptionParser.new.help}
        
        Примеры:
          mero-ideas                              # Одна случайная идея
          mero-ideas -c 5                         # 5 случайных идей
          mero-ideas -t business                  # Бизнес-мероприятие
          mero-ideas -t educational -c 3          # 3 образовательные идеи
          mero-ideas -f "Мастер-класс"            # Идеи с форматом "Мастер-класс"
          mero-ideas -i                           # Интерактивный режим
          mero-ideas -j -s ideas.json             # Сохранить в JSON
          mero-ideas --save my_ideas.txt          # Сохранить в файл
        
        Доступные типы:
          business      - бизнес мероприятия
          social        - социальные мероприятия
          educational   - образовательные мероприятия
          team_building - командообразование
        
      HELP
    end
  end
end