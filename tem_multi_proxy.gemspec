# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tem_multi_proxy}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Costan"]
  s.date = %q{2009-08-19}
  s.description = %q{Maintains TEM proxies for all the physically attached TEMs.}
  s.email = %q{victor@costan.us}
  s.executables = ["tem_multi_proxy", "tem_multi_proxy_query"]
  s.extra_rdoc_files = ["bin/tem_multi_proxy", "bin/tem_multi_proxy_query", "CHANGELOG", "lib/tem_multi_proxy/client.rb", "lib/tem_multi_proxy/manager.rb", "lib/tem_multi_proxy/server.rb", "lib/tem_multi_proxy.rb", "LICENSE", "README"]
  s.files = ["bin/tem_multi_proxy", "bin/tem_multi_proxy_query", "CHANGELOG", "lib/tem_multi_proxy/client.rb", "lib/tem_multi_proxy/manager.rb", "lib/tem_multi_proxy/server.rb", "lib/tem_multi_proxy.rb", "LICENSE", "Manifest", "Rakefile", "README", "tem_multi_proxy.gemspec"]
  s.homepage = %q{http://tem.rubyforge.org}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Tem_multi_proxy", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tem}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Maintains TEM proxies for all the physically attached TEMs.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rbtree>, [">= 0.2.1"])
      s.add_runtime_dependency(%q<smartcard>, [">= 0.4.1"])
      s.add_runtime_dependency(%q<zerg_support>, [">= 0.0.9"])
    else
      s.add_dependency(%q<rbtree>, [">= 0.2.1"])
      s.add_dependency(%q<smartcard>, [">= 0.4.1"])
      s.add_dependency(%q<zerg_support>, [">= 0.0.9"])
    end
  else
    s.add_dependency(%q<rbtree>, [">= 0.2.1"])
    s.add_dependency(%q<smartcard>, [">= 0.4.1"])
    s.add_dependency(%q<zerg_support>, [">= 0.0.9"])
  end
end
