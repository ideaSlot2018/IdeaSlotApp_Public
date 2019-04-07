# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IdeaSlotApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  #pod 'RealmSwift'
  #pod 'DropDown'
  #pod 'SlideMenuControllerSwift'

  # Pods for IdeaSlotApp

  target 'IdeaSlotAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IdeaSlotAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

swift4_names = [
  'DropDown'
]

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if swift4_names.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
      else
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
    end
  end
end

