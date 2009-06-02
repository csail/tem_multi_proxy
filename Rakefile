require 'rubygems'
gem 'echoe'
require 'echoe'

Echoe.new('tem_multi_proxy') do |p|
  p.project = 'tem' # rubyforge project
  p.docs_host = "costan@rubyforge.org:/var/www/gforge-projects/tem/rdoc/"
  
  p.author = 'Victor Costan'
  p.email = 'victor@costan.us'
  p.summary = 'Maintains TEM proxies for all the physically attached TEMs.'
  p.url = 'http://tem.rubyforge.org'
  p.dependencies = ['rbtree >=0.2.1',
                    'smartcard >=0.3.1',
                    'tem_ruby >=0.11',
                    'zerg_support >=0.0.9']
  
  p.need_tar_gz = !Platform.windows?
  p.need_zip = !Platform.windows?
  p.rdoc_pattern = /^(lib|bin|tasks|ext)|^BUILD|^README|^CHANGELOG|^TODO|^LICENSE|^COPYING$/  
end

if $0 == __FILE__
  Rake.application = Rake::Application.new
  Rake.application.run
end
