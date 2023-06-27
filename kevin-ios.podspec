Pod::Spec.new do |spec|
  spec.name         = "kevin-ios"
  spec.version      = "2.3.0"
  spec.summary      = "Simplified kevin. integration for the iOS clients."

  spec.homepage     = "https://github.com/getkevin/kevin-ios"
  spec.screenshots  = "https://github.com/getkevin/kevin-ios/raw/master/images/logo.png"


  spec.license      = { :type => 'MIT', :file => './LICENSE' }

  spec.author       = "kevin."

  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.swift_version = '5.0'
  
  spec.source       = { :git => "https://github.com/getkevin/kevin-ios.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/Kevin/**/*.{swift}"
  spec.resource_bundles = {
    'Kevin_Kevin' => [ 
       'Sources/Kevin/Resources/*.lproj',
       'Sources/Kevin/Resources/Assets.xcassets'
    ]
  }
end
