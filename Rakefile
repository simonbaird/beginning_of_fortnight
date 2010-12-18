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

desc "Run tests"
task :test do
  system "rspec -c -fd spec"
end

