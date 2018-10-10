# Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'

target 'Politics' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Charts'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'PKHUD', '~> 5.0'
  pod 'SwiftDate', '~> 4.5.1'
  pod 'PageMenu'
  pod 'Eureka', '~> 4.1.1'
  pod 'WCLShineButton'
  pod 'Nuke'
  pod 'FirebaseUI/Storage'
  pod 'ViewRow', :git => 'https://github.com/EurekaCommunity/ViewRow'
  # Pods for Politics
post_install do |installer|

  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          if target.name == 'Charts'
              config.build_settings['SWIFT_VERSION'] = '4.2'
              else
              config.build_settings['SWIFT_VERSION'] = '4.1'
          end
      end
  end
end

end
