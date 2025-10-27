#
# Generated file, do not edit.
#

Pod::Spec.new do |s|
  s.name             = 'FlutterPluginRegistrant'
  s.version          = '0.0.1'
  s.summary          = 'Registers plugins with your Flutter app'
  s.description      = <<-DESC
Depends on all your plugins, and provides a function to register them.
                       DESC
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.ios.deployment_target = '13.0'
  s.source_files =  "Classes", "Classes/**/*.{h,m}"
  s.source           = { :path => '.' }
  s.public_header_files = './Classes/**/*.h'
  s.static_framework    = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.dependency 'Flutter'
  s.dependency 'camera_avfoundation'
  s.dependency 'connectivity_plus'
  s.dependency 'firebase_auth'
  s.dependency 'firebase_core'
  s.dependency 'firebase_crashlytics'
  s.dependency 'firebase_database'
  s.dependency 'firebase_messaging'
  s.dependency 'flutter_contacts'
  s.dependency 'flutter_facebook_auth'
  s.dependency 'flutter_local_notifications'
  s.dependency 'flutter_phone_direct_caller'
  s.dependency 'flutter_secure_storage'
  s.dependency 'fluttertoast'
  s.dependency 'geocoding_ios'
  s.dependency 'geolocator_apple'
  s.dependency 'google_maps_flutter_ios'
  s.dependency 'google_sign_in_ios'
  s.dependency 'image_picker_ios'
  s.dependency 'location'
  s.dependency 'path_provider_foundation'
  s.dependency 'permission_handler_apple'
  s.dependency 'razorpay_flutter'
  s.dependency 'shared_preferences_foundation'
  s.dependency 'sqflite_darwin'
  s.dependency 'url_launcher_ios'
end
