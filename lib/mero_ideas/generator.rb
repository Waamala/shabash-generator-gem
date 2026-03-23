require_relative "categories/formats"
require_relative "categories/themes"
require_relative "categories/activities"
require_relative "categories/audiences"
require_relative "categories/locations"

module MeroIdeas
  class Generator
    attr_reader :formats, :themes, :activities, :audiences, :locations

    def initialize
      @formats = Categories::Formats.new
      @themes = Categories::Themes.new
      @activities = Categories::Activities.new
      @audiences = Categories::Audiences.new
      @locations = Categories::Locations.new
    end

    def generate(options = {})
      count = options[:count] || 1
      filter = options[:filter] || {}

      ideas = []
      count.times do
        ideas << generate_single_idea(filter)
      end

      ideas
    end

    def generate_single_idea(filter = {})
      format = select_item(@formats.all, filter[:format])
      theme = select_item(@themes.all, filter[:theme])
      activity = select_item(@activities.all, filter[:activity])
      audience = select_item(@audiences.all, filter[:audience])
      location = select_item(@locations.all, filter[:location])

      {
        format: format,
        theme: theme,
        activity: activity,
        audience: audience,
        location: location,
        title: generate_title(format, theme, activity, audience),
        description: generate_description(format, theme, activity, audience, location),
        tags: generate_tags(format, theme, activity)
      }
    end

    def generate_by_type(type, count = 1)
      case type
      when "business"
        generate(count: count, filter: { format: ["конференция", "воркшоп", "хакатон"] })
      when "social"
        generate(count: count, filter: { format: ["вечеринка", "пикник", "квест"] })
      when "educational"
        generate(count: count, filter: { format: ["лекция", "тренинг", "мастер-класс"] })
      when "team_building"
        generate(count: count, filter: { activity: ["тимбилдинг", "спортивное соревнование", "ролевая игра"] })
      else
        generate(count: count)
      end
    end

    private

    def select_item(items, filter_value)
      return items.sample if filter_value.nil?
      
      if filter_value.is_a?(Array)
        filtered = items.select do |item|
          filter_value.any? { |fv| fv.downcase == item.downcase }
        end
        return filtered.sample unless filtered.empty?
        return items.sample
      else
        return filter_value if items.include?(filter_value)
        items.sample
      end
    end

    def generate_title(format, theme, activity, audience)
      templates = [
        "#{audience} #{format}: #{theme} через #{activity}",
        "#{format} по #{theme} для #{audience}",
        "Как #{activity} помогает #{audience} раскрыть #{theme}",
        "#{theme} #{format}: #{activity} для #{audience}",
        "#{audience} #{format} с элементами #{activity} на тему #{theme}"
      ]
      
      templates.sample
    end

    def generate_description(format, theme, activity, audience, location)
      "Мероприятие в формате #{format.downcase} на тему «#{theme.downcase}» "\
      "для #{audience.downcase}. Основная активность: #{activity.downcase}. "\
      "Локация: #{location.downcase}. "\
      "Участники смогут погрузиться в атмосферу #{theme.downcase} через #{activity.downcase} "\
      "и получить незабываемый опыт взаимодействия с единомышленниками."
    end

    def generate_tags(format, theme, activity)
      [format, theme, activity].map(&:downcase).uniq
    end
  end
end