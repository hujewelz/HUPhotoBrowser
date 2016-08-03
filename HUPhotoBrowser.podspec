#
#  Be sure to run `pod spec lint HUPhotoBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "HUPhotoBrowser"
  s.version      = "1.1.4"
  s.summary      = "photo browser for ios, which can browse Photo library and web image"
  s.homepage     = "https://github.com/hujewelz/HUPhotoBrowser"
  s.license      = "MIT"
  s.author             = { "Jewelz Hu" => "https://github.com/hujewelz/HUPhotoBrowser" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/hujewelz/HUPhotoBrowser.git", :tag => "1.1.4" }
  s.source_files  = "HUPhotoBrowser/**/*.{h,m}"
  s.resources = "HUPhotoBrowser/HUPhotoPicker/*.png", "HUPhotoBrowser/HUPhotoPicker/*.xib"
  s.requires_arc = true
  s.frameworks = "UIKit", "Photos", "AssetsLibrary"




  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  




  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
