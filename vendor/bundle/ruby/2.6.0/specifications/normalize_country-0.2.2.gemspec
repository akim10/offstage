# -*- encoding: utf-8 -*-
# stub: normalize_country 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "normalize_country".freeze
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Skye Shaw".freeze]
  s.date = "2017-07-21"
  s.description = "    Converts country names and codes from standardized and non-standardized names and abbreviations to one of the following:\n    ISO 3166-1 (code/name/number), FIFA, IOC, a country's official name or shortened name, and Emoji.\n\n    Includes a small script to convert names/codes in a DB, XML or CSV file.\n".freeze
  s.email = "skye.shaw@gmail.com".freeze
  s.executables = ["normalize_country".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze, "bin/normalize_country".freeze]
  s.homepage = "http://github.com/sshaw/normalize_country".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Convert country names and codes to a standard".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 0.9"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 0.9"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
  end
end
