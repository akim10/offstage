# -*- encoding: utf-8 -*-
# stub: pg 1.2.1 ruby lib
# stub: ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "pg".freeze
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/ged/ruby-pg" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze, "Lars Kanis".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIENDCCApygAwIBAgIBATANBgkqhkiG9w0BAQsFADAiMSAwHgYDVQQDDBdnZWQv\nREM9RmFlcmllTVVEL0RDPW9yZzAeFw0xOTEwMDkwMDM2NTdaFw0yMDEwMDgwMDM2\nNTdaMCIxIDAeBgNVBAMMF2dlZC9EQz1GYWVyaWVNVUQvREM9b3JnMIIBojANBgkq\nhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAvyVhkRzvlEs0fe7145BYLfN6njX9ih5H\nL60U0p0euIurpv84op9CNKF9tx+1WKwyQvQP7qFGuZxkSUuWcP/sFhDXL1lWUuIl\nM4uHbGCRmOshDrF4dgnBeOvkHr1fIhPlJm5FO+Vew8tSQmlDsosxLUx+VB7DrVFO\n5PU2AEbf04GGSrmqADGWXeaslaoRdb1fu/0M5qfPTRn5V39sWD9umuDAF9qqil/x\nSl6phTvgBrG8GExHbNZpLARd3xrBYLEFsX7RvBn2UPfgsrtvpdXjsHGfpT3IPN+B\nvQ66lts4alKC69TE5cuKasWBm+16A4aEe3XdZBRNmtOu/g81gvwA7fkJHKllJuaI\ndXzdHqq+zbGZVSQ7pRYHYomD0IiDe1DbIouFnPWmagaBnGHwXkDT2bKKP+s2v21m\nozilJg4aar2okb/RA6VS87o+d7g6LpDDMMQjH4G9OPnJENLdhu8KnPw/ivSVvQw7\nN2I4L/ZOIe2DIVuYH7aLHfjZDQv/mNgpAgMBAAGjdTBzMAkGA1UdEwQCMAAwCwYD\nVR0PBAQDAgSwMB0GA1UdDgQWBBRyjf55EbrHagiRLqt5YAd3yb8k4DAcBgNVHREE\nFTATgRFnZWRARmFlcmllTVVELm9yZzAcBgNVHRIEFTATgRFnZWRARmFlcmllTVVE\nLm9yZzANBgkqhkiG9w0BAQsFAAOCAYEAFqsr6o0SvQRgjQVmhbQvExRnCMCoW1yb\nFJiN7A5RA2Iy2E61OG1Ul5nGmaDmx/PNB/6JIbIV3B9Uq8aTZx4uOjK7r8vMl1/t\nZfY7r6HejJfXlcO2m6JDMbpdyEVv916LncBkzZRz6vnnNCx+31f15FKddxujpAFd\nqpn3JRQY+oj7ZkoccL/IUiDpxQWeS3oOoz9qr2kVTp8R50InZimt79FqCl/1m66W\nkdOuf+wM3DDx7Rt4IVNHrhGlyfMr7xjKW1Q3gll+pMN1DT6Ajx/t3JDSEg7BnnEW\nr7AciSO6J4ApUdqyG+coLFlGdtgFTgRHv7ihbQtDI7Z/LV7A4Spn1j2PK3j0Omri\nkSl1hPVigRytfgdVGiLXzvkkrkgj9EknCaj5UHbac7XvVBrljXj9hsnnqTANaKsg\njBZSA+N+xUTgUWpXjjwsLZjzJkhWATJWq+krNXcqpwXo6HsjmdUxoFMt63RBb+sI\nXrxOxp8o0uOkU7FdLSGsyqJ2LzsR4obN\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2020-01-02"
  s.description = "Pg is the Ruby interface to the {PostgreSQL RDBMS}[http://www.postgresql.org/].\n\nIt works with {PostgreSQL 9.2 and later}[http://www.postgresql.org/support/versioning/].\n\nA small example usage:\n\n  #!/usr/bin/env ruby\n\n  require 'pg'\n\n  # Output a table of current connections to the DB\n  conn = PG.connect( dbname: 'sales' )\n  conn.exec( \"SELECT * FROM pg_stat_activity\" ) do |result|\n    puts \"     PID | User             | Query\"\n    result.each do |row|\n      puts \" %7d | %-16s | %s \" %\n        row.values_at('procpid', 'usename', 'current_query')\n    end\n  end".freeze
  s.email = ["ged@FaerieMUD.org".freeze, "lars@greiz-reinsdorf.de".freeze]
  s.extensions = ["ext/extconf.rb".freeze]
  s.extra_rdoc_files = ["Contributors.rdoc".freeze, "History.rdoc".freeze, "Manifest.txt".freeze, "README-OS_X.rdoc".freeze, "README-Windows.rdoc".freeze, "README.ja.rdoc".freeze, "README.rdoc".freeze, "ext/errorcodes.txt".freeze, "POSTGRES".freeze, "LICENSE".freeze, "ext/gvl_wrappers.c".freeze, "ext/pg.c".freeze, "ext/pg_binary_decoder.c".freeze, "ext/pg_binary_encoder.c".freeze, "ext/pg_coder.c".freeze, "ext/pg_connection.c".freeze, "ext/pg_copy_coder.c".freeze, "ext/pg_errors.c".freeze, "ext/pg_record_coder.c".freeze, "ext/pg_result.c".freeze, "ext/pg_text_decoder.c".freeze, "ext/pg_text_encoder.c".freeze, "ext/pg_tuple.c".freeze, "ext/pg_type_map.c".freeze, "ext/pg_type_map_all_strings.c".freeze, "ext/pg_type_map_by_class.c".freeze, "ext/pg_type_map_by_column.c".freeze, "ext/pg_type_map_by_mri_type.c".freeze, "ext/pg_type_map_by_oid.c".freeze, "ext/pg_type_map_in_ruby.c".freeze, "ext/pg_util.c".freeze]
  s.files = ["Contributors.rdoc".freeze, "History.rdoc".freeze, "LICENSE".freeze, "Manifest.txt".freeze, "POSTGRES".freeze, "README-OS_X.rdoc".freeze, "README-Windows.rdoc".freeze, "README.ja.rdoc".freeze, "README.rdoc".freeze, "ext/errorcodes.txt".freeze, "ext/extconf.rb".freeze, "ext/gvl_wrappers.c".freeze, "ext/pg.c".freeze, "ext/pg_binary_decoder.c".freeze, "ext/pg_binary_encoder.c".freeze, "ext/pg_coder.c".freeze, "ext/pg_connection.c".freeze, "ext/pg_copy_coder.c".freeze, "ext/pg_errors.c".freeze, "ext/pg_record_coder.c".freeze, "ext/pg_result.c".freeze, "ext/pg_text_decoder.c".freeze, "ext/pg_text_encoder.c".freeze, "ext/pg_tuple.c".freeze, "ext/pg_type_map.c".freeze, "ext/pg_type_map_all_strings.c".freeze, "ext/pg_type_map_by_class.c".freeze, "ext/pg_type_map_by_column.c".freeze, "ext/pg_type_map_by_mri_type.c".freeze, "ext/pg_type_map_by_oid.c".freeze, "ext/pg_type_map_in_ruby.c".freeze, "ext/pg_util.c".freeze]
  s.homepage = "https://github.com/ged/ruby-pg".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Pg is the Ruby interface to the {PostgreSQL RDBMS}[http://www.postgresql.org/]".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
    s.add_development_dependency(%q<hoe-deveiate>.freeze, ["~> 0.10"])
    s.add_development_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rake-compiler-dock>.freeze, ["~> 0.7.0"])
    s.add_development_dependency(%q<hoe-bundler>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 5.1"])
    s.add_development_dependency(%q<hoe>.freeze, ["~> 3.20"])
  else
    s.add_dependency(%q<hoe-mercurial>.freeze, ["~> 1.4"])
    s.add_dependency(%q<hoe-deveiate>.freeze, ["~> 0.10"])
    s.add_dependency(%q<hoe-highline>.freeze, ["~> 0.2"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake-compiler-dock>.freeze, ["~> 0.7.0"])
    s.add_dependency(%q<hoe-bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 5.1"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.20"])
  end
end
