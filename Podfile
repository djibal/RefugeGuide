platform :ios, '16.0'
ENV['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'

target 'RefugeGuide' do
  use_frameworks!

  # 🔥 Firebase (Modern Modular SDK)
  pod 'FirebaseCore', '>= 10.0.0'
  pod 'FirebaseAuth', '>= 10.0.0'
  pod 'FirebaseFirestore', '>= 10.0.0'
  pod 'FirebaseFirestoreSwift', '>= 10.0.0'
  pod 'FirebaseStorage', '>= 10.0.0'
  pod 'FirebaseFunctions', '>= 10.0.0'
  pod 'FirebaseAnalytics', '>= 10.0.0'
  pod 'FirebaseMessaging', '>= 10.0.0'

  # 🔑 Auth providers
  pod 'GoogleSignIn'

  # 📄 Document AI / OCR
  pod 'GoogleMLKit/TextRecognition'


  # 📹 Video Consultation
  pod 'AgoraRtcEngine_iOS', '~> 4.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'

      # Optional: prevent signing issues for bundles (e.g. frameworks or resources)
      if target.respond_to?(:product_type) && target.product_type == "com.apple.product-type.bundle"
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end

    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-G' || flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
          puts "✅ Cleaned flags in #{file.file_ref.display_name}"
        end
      end
    end
  end
end
