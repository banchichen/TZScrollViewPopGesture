Pod::Spec.new do |s|
  s.name         = "TZScrollViewPopGesture"
  s.version      = "1.0.4"
  s.summary      = "一句代码，让UIScrollView的滑动和系统侧滑手势并存，例如：在查看地图界面同时支持地图的滑动和侧滑返回。注：和FDFullscreenPopGesture库不冲突"
  s.homepage     = "https://github.com/banchichen/TZScrollViewPopGesture"
  s.license      = "MIT"
  s.author       = { "banchichen" => "tanzhenios@foxmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/banchichen/TZScrollViewPopGesture.git", :tag => "1.0.4" }
  s.requires_arc = true
  s.source_files = "TZScrollViewPopGesture/TZScrollViewPopGesture/*.{h,m}"
end