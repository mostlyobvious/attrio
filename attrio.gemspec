# frozen_string_literal: true

require_relative "lib/attrio/version"

Gem::Specification.new do |gem|
  gem.name = "attrio"
  gem.version = Attrio::Version::STRING
  gem.authors = ["Igor Alexandrov", "Julia Egorova"]
  gem.email = "hello@jetrockets.ru"
  gem.summary =
    "Attributes for plain old Ruby objects. No dependencies, only simplicity and clearness."
  gem.homepage = "https://github.com/jetrockets/attrio"
  gem.licenses = ["MIT"]

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
