require "json"
require "csv"
require "fileutils"

module MeroIdeas
  class Exporter
    def initialize(ideas)
      @ideas = ideas
    end

    def export_to_text(filename)
      content = @ideas.each_with_index.map do |idea, index|
        format_idea_text(idea, index + 1)
      end.join("\n\n" + "=" * 60 + "\n\n")
      
      File.write(filename, content)
      puts "✅ Экспортировано в текстовый файл: #{filename}"
    end

    def export_to_json(filename)
      File.write(filename, JSON.pretty_generate(@ideas))
      puts "✅ Экспортировано в JSON: #{filename}"
    end

    def export_to_csv(filename)
      CSV.open(filename, "w") do |csv|
        csv << ["Название", "Формат", "Тема", "Активность", "Аудитория", "Локация", "Теги"]
        
        @ideas.each do |idea|
          csv << [
            idea[:title],
            idea[:format],
            idea[:theme],
            idea[:activity],
            idea[:audience],
            idea[:location],
            idea[:tags].join("; ")
          ]
        end
      end
      
      puts "✅ Экспортировано в CSV: #{filename}"
    end

    def export_to_markdown(filename)
      content = "# Идеи для мероприятий\n\n"
      content += "Сгенерировано: #{Time.now}\n\n"
      
      @ideas.each_with_index do |idea, index|
        content += "## #{index + 1}. #{idea[:title]}\n\n"
        content += "### Основная информация\n"
        content += "- **Формат:** #{idea[:format]}\n"
        content += "- **Тема:** #{idea[:theme]}\n"
        content += "- **Активность:** #{idea[:activity]}\n"
        content += "- **Аудитория:** #{idea[:audience]}\n"
        content += "- **Локация:** #{idea[:location]}\n"
        content += "- **Теги:** #{idea[:tags].join(', ')}\n\n"
        content += "### Описание\n\n"
        content += "#{idea[:description]}\n\n"
        content += "---\n\n"
      end
      
      File.write(filename, content)
      puts "✅ Экспортировано в Markdown: #{filename}"
    end

    private

    def format_idea_text(idea, number)
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
      output.join("\n")
    end
  end
end