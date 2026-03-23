require_relative "mero_ideas/version"
require_relative "mero_ideas/generator"
require_relative "mero_ideas/cli"
require_relative "mero_ideas/exporter"
require_relative "mero_ideas/config"
require_relative "mero_ideas/cli_extensions"

module MeroIdeas
  class Error < StandardError; end
  
  def self.generate(options = {})
    generator = Generator.new
    generator.generate(options)
  end
  
  def self.generate_by_type(type, count = 1)
    generator = Generator.new
    generator.generate_by_type(type, count)
  end
  
  def self.export(ideas, format, filename)
    exporter = Exporter.new(ideas)
    
    case format
    when "text"
      exporter.export_to_text(filename)
    when "json"
      exporter.export_to_json(filename)
    when "csv"
      exporter.export_to_csv(filename)
    when "markdown"
      exporter.export_to_markdown(filename)
    else
      raise Error, "Неподдерживаемый формат: #{format}"
    end
  end
end