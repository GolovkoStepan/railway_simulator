# frozen_string_literal: true

require_relative 'lib/railway_simulator/version'

Gem::Specification.new do |spec|
  spec.name          = 'railway_simulator'
  spec.version       = RailwaySimulator::VERSION
  spec.authors       = ['s.golovko']
  spec.email         = ['stepagolovko1993@gmail.com']

  spec.summary       = 'Gem Railway Simulator'
  spec.description   = 'Train and railroad simulator'
  spec.homepage      = 'https://github.com/GolovkoStepan'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.82.0'
  spec.add_development_dependency 'tty-prompt', '~> 0.21.0'
end
