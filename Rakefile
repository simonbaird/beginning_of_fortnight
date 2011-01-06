gemspec = eval(File.read('beginning_of_fortnight.gemspec'))

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Build gem locally"
task :build => :gemspec do
  system "gem build #{gemspec.name}.gemspec"
  FileUtils.mkdir_p "pkg"
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", "pkg"
end

desc "Install gem locally"
task :install => :build do
  system "sudo gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc "Create rdoc"
task :rdoc => :build do
  system "rm -rf doc"
  system "rdoc lib"
end

desc "Run tests"
task :spec do
  system "spec -c -fp spec/*"
end

desc "Run tests"
task :rspec do
  system "rspec -c -fp spec/*"
end

desc "Install then run tests"
task :install_test => [:gemspec, :install, :spec] do
end

desc "Install then run tests then build docs"
task :all => [:gemspec, :install, :spec, :rdoc] do
end

