include FileUtils::Verbose

namespace :test do
  task :prepare_ios do
    mkdir_p "Tests/DCClass Tests.xcodeproj/xcshareddata/xcschemes"
    cp Dir.glob('Tests/Schemes/iOS Tests.xcscheme'), "Tests/DCClass Tests.xcodeproj/xcshareddata/xcschemes/"
  end
  
  def run(command, min_exit_status = 0)
    puts "Executing: `#{command}`"
    system(command)
    return $?.exitstatus
  end

  desc "Cleaning environment"
  task :clean do
    run('rm -rf Build && rm -rf DerivedData && rm -rf Tests/Pods && rm -rf Tests/Podfile.lock')
  end
  
  desc "Run the DCClass Tests for iOS"
  task :ios => ['clean', 'prepare_ios'] do
    run_tests('iOS Tests', 'iphonesimulator')
    tests_failed('iOS Tests') unless $?.success?
  end
end

desc "Run the DCClass Tests for iOS"
task :test do
  Rake::Task['test:ios'].invoke
end

task :default => 'test'


private

def run_tests(scheme, sdk)
  sh("set -o pipefail && xcodebuild -workspace DCClass.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' -destination platform='iOS Simulator,OS=7.0,name=iPhone 4s' -configuration Release clean test | xcpretty -c ; exit ${PIPESTATUS[0]}") rescue nil
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end