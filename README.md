# Shabash Generator
Простой генератор идей для мероприятий на Ruby


# Одна случайная идея
ruby -Ilib bin/mero-ideas

# 5 идей для бизнес-мероприятия
ruby -Ilib bin/mero-ideas -t business -c 5

# Интерактивный режим
ruby -Ilib bin/mero-ideas -i

# Сохранить в файл
ruby -Ilib bin/mero-ideas -c 3 -s ideas.txt

# Команды
-c, --count NUM	Количество идей (по умолчанию: 1)

-t, --type TYPE	Тип: business, social, educational, team_building

-f, --format FORMAT	Фильтр по формату мероприятия

-s, --save FILE	Сохранить результат в файл

-j, --json	Вывод в JSON формате

-i, --interactive	Интерактивный режим

-h, --help	Показать справку

-v, --version	Показать версию


# Запуск тестов
bundle exec rspec spec/
