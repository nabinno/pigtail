$:.push File.expand_path("../lib", __FILE__)

require "pigtail/version"

Gem::Specification.new do |s|
  s.name          = "pigtail"
  s.version       = Pigtail::VERSION
  s.authors       = ["Nab Inno"]
  s.email         = ["nab@blahfe.com"]
  s.homepage      = "https://github.com/nabinno/pigtail"
  s.summary       = %q{Configs in ruby.}
  s.description   = %q{Pigtail is a Ruby gem that provides a clear syntax for writing configurations.}
  s.license       = "MIT"

  s.files         = Dir["{bin,lib,test}/**/*",
                        "Gemfile", "MIT-LICENSE", "README.md", "Rakefile", "pigtail.gemspec"]
  s.test_files    = Dir["test/{functional,unit}/*"]
  s.executables   = Dir["bin/*"].map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", ">= 2.2.10"
  s.add_development_dependency 'mocha', '~> 0.9', '>= 0.9.5'
  s.add_development_dependency "rake", ">= 12.3.3"
end
