platform :ios, '16.0'
ENV['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'

target 'RefugeGuide' do
  use_frameworks!

  # 🔥 Firebase core + auth
  pod 'FirebaseCore'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'GoogleSignIn'
  pod 'FirebaseStorage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Functions'


  # 📄 Document AI / OCR
  pod 'GoogleMLKit/TextRecognition'

  # 🧭 AR Navigation
  pod 'ARKit'

  # 📹 Video Consultation
  pod 'AgoraRtcEngine_iOS', '~> 4.0'

  # 🔒 Blockchain / eVisa verification (optional)
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end
