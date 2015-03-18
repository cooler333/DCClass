include FileUtils::Verbose

namespace :test do
  task :prepare_ios do
    mkdir_p "Tests/DCClass Tests.xcodeproj/xcshareddata/xcschemes"
    cp Dir.glob('Tests/Schemes/*.xcscheme'), "Tests/DCClass Tests.xcodeproj/xcshareddata/xcschemes/"
  end
  
  def run(command, min_exit_status = 0)
    puts "Executing: `#{command}`"
    system(command)
    return $?.exitstatus
  end
  
  task :ios => 'prepare_ios' do
    run_build('iOS UI Tests', 'iphonesimulator')
    tests_failed('iOS UI Tests') unless $?.success?
  end

  desc "Run the DCClass Tests for iOS"
  task :ios_sim => 'prepare_ios' do
    run_tests('iOS Tests', 'iphonesimulator')
    tests_failed('iOS Tests') unless $?.success?
  end
end

desc "Run the DCClass Tests for iOS"
task :test do
  Rake::Task['test:ios'].invoke
  Rake::Task['test:ios_sim'].invoke
end

task :default => 'test'


private

def run_build(scheme, sdk)
  sh("xctool -workspace DCClass.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' -configuration Debug clean build") rescue nil
end

def run_tests(scheme, sdk)
  sh("xctool -workspace DCClass.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' -configuration Release clean test") rescue nil
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end