platform :ios, '13.0'
target 'NavCog' do
	pod 'DeepDiff'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end

