require "yaml"
require "fileutils"

module MeroIdeas
  class Config
    CONFIG_DIR = File.join(Dir.home, ".mero-ideas")
    CONFIG_FILE = File.join(CONFIG_DIR, "config.yml")
    
    DEFAULTS = {
      "default_count" => 1,
      "default_format" => nil,
      "output_format" => "text",
      "auto_save" => false,
      "save_directory" => Dir.pwd,
      "color_output" => true
    }

    def self.load
      return DEFAULTS unless File.exist?(CONFIG_FILE)
      
      config = YAML.load_file(CONFIG_FILE)
      DEFAULTS.merge(config || {})
    end

    def self.save(config)
      FileUtils.mkdir_p(CONFIG_DIR)
      File.write(CONFIG_FILE, config.to_yaml)
      puts "✅ Конфигурация сохранена в #{CONFIG_FILE}"
    end

    def self.init_config
      return if File.exist?(CONFIG_FILE)
      
      puts "🔧 Создание конфигурационного файла..."
      save(DEFAULTS)
    end

    def self.configure_interactive
      puts "=" * 60
      puts "Настройка конфигурации"
      puts "=" * 60
      
      config = load
      
      print "Количество идей по умолчанию [#{config['default_count']}]: "
      input = gets.chomp
      config['default_count'] = input.to_i if input.to_i > 0
      
      print "Формат вывода (text/json/csv/markdown) [#{config['output_format']}]: "
      input = gets.chomp
      config['output_format'] = input if ["text", "json", "csv", "markdown"].include?(input)
      
      print "Автосохранение (true/false) [#{config['auto_save']}]: "
      input = gets.chomp
      config['auto_save'] = input == "true" if ["true", "false"].include?(input)
      
      print "Цветной вывод (true/false) [#{config['color_output']}]: "
      input = gets.chomp
      config['color_output'] = input == "true" if ["true", "false"].include?(input)
      
      save(config)
    end
  end
end