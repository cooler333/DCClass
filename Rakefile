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

  desc "Run the DCClass UI Tests for iOS last"
  task :ios_ui_test_simulator => 'prepare_ios' do
    run('iOS UI Tests', 'iphonesimulator', '-configuration Debug clean build')
    tests_failed('iOS UI Tests') unless $?.success?
  end

  desc "Run the DCClass Tests for iOS last"
  task :ios_test_simulator => 'prepare_ios' do
    run('iOS Tests', 'iphonesimulator', '- -configuration Release clean test')
    tests_failed('iOS Tests') unless $?.success?
  end

  desc "Run the DCClass UI Tests for iOS last"
  task :ios_ui_test_simulator_last => 'prepare_ios' do
    run('iOS UI Tests', 'iphoneos', '-configuration Debug clean build')
    tests_failed('iOS UI Tests') unless $?.success?
  end

  desc "Run the DCClass Tests for iOS last"
  task :ios_test_simulator_last => 'prepare_ios' do
    run('iOS Tests', 'iphonesimulator', '-configuration Release clean test')
    tests_failed('iOS Tests') unless $?.success?
  end
end

desc "Run the DCClass Tests for iOS"
task :test do
  #Rake::Task['test:ios_ui_test_simulator'].invoke
  #Rake::Task['test:ios_test_simulator'].invoke

  Rake::Task['test:ios_ui_test_simulator_last'].invoke
  Rake::Task['test:ios_test_simulator_last'].invoke
end

task :default => 'test'


private

def run(scheme, sdk, args)
  sh("xcodebuild -showsdks; xctool -workspace DCClass.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' #{args} ONLY_ACTIVE_ARCH=NO") rescue nil
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end