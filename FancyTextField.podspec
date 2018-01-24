Pod::Spec.new do |s|
  s.name             = 'FancyTextField'
  s.version          = '0.1.3'
  s.summary          = 'Its the UITextField but prettier'
 
  s.description      = <<-DESC
This TextField is really fancy! It will make your app look slick!
                       DESC
 
  s.homepage         = 'https://github.com/gtdrag/FancyTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'George T. Drag' => 'gdrag@redfoundry.com' }
  s.source           = { :git => 'https://github.com/gtdrag/FancyTextField.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'CustomTextInput/*.{swift,xib}'
 
end