Pod::Spec.new do |s|
  s.name         = "AQSWhatsAppActivity"
  s.version      = "0.1.0"
  s.summary      = "[iOS] UIActivity Class for WhatsApp"
  s.homepage     = "https://github.com/AquaSupport/AQSWhatsAppActivity"
  s.license      = "MIT"
  s.author       = { "kaiinui" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AquaSupport/AQSWhatsAppActivity.git", :tag => "v0.1.0" }
  s.source_files  = "AQSWhatsAppActivity/Classes/**/*.{h,m}"
  s.resources = ["AQSWhatsAppActivity/Classes/**/*.png"]
  s.requires_arc = true
  s.platform = "ios", '7.0'
end
