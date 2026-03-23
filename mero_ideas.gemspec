require_relative "lib/mero_ideas/version"

Gem::Specification.new do |spec|
  spec.name = "shabash-generator"
  spec.version = MeroIdeas::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your@email.com"]

  spec.summary = "Генератор идей для мероприятий"
  spec.description = "Простой генератор идей для мероприятий с CLI интерфейсом"
  spec.homepage = "https://github.com/yourusername/shabash-generator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["mero-ideas"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end