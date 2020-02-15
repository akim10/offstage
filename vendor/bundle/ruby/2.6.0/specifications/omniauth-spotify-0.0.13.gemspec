# -*- encoding: utf-8 -*-
# stub: omniauth-spotify 0.0.13 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-spotify".freeze
  s.version = "0.0.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Claudio Poli".freeze]
  s.date = "2017-03-28"
  s.description = "OmniAuth strategy for Spotify".freeze
  s.email = ["claudio@icorete.ch\n".freeze]
  s.homepage = "https://github.com/icoretech/omniauth-spotify".freeze
  s.rubygems_version = "3.1.2".freeze
  s.summary = "OmniAuth strategy for Spotify".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<omniauth-oauth2>.freeze, ["~> 1.1"])
  else
    s.add_dependency(%q<omniauth-oauth2>.freeze, ["~> 1.1"])
  end
end
