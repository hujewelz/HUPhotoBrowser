#
#  Be sure to run `pod spec lint HUPhotoBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "HUPhotoBrowser"
  s.version      = "1.4.3"
  s.summary      = "photo browser for ios, which can browse Photo library and web image"
  s.homepage     = "https://github.com/hujewelz/HUPhotoBrowser"
  s.license      = "MIT"
  s.author             = { "Jewelz Hu" => "https://github.com/hujewelz/HUPhotoBrowser" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/hujewelz/HUPhotoBrowser.git", :tag => s.version.to_s }
  s.source_files  = "HUPhotoBrowser/**/*.{h,m}"
  s.requires_arc = true
  s.frameworks = "UIKit", "Photos", "AssetsLibrary"

  s.public_header_files = "HUPhotoBrowser/HUPhotoBrowser.h", "HUPhotoBrowser/HUPhotoPicker/HUImagePickerViewController.h", "HUPhotoBrowser/HUWebImageDownloader/{UIImageView+HUWebImage,HUWebImageDownloader}.h"
  s.dependency "SVProgressHUD"


end
