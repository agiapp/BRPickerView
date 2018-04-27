Pod::Spec.new do |s|
  # 框架的名称
  s.name         = "BRPickerView"
  # 框架的版本号
  s.version      = "2.2.1"
  # 框架的简单介绍
  s.summary      = "A custom picker view for iOS."
  # 框架的详细描述(详细介绍，要比简介长)
  s.description  = <<-DESC
                    A custom picker view for iOS, Include "日期选择器，时间选择器，地址选择器，自定义字符串选择器", Support the Objective - C language.
                DESC
  # 框架的主页
  s.homepage     = "https://github.com/91renb/BRPickerView"
  # 证书类型
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者
  s.author             = { "任波" => "91renb@gmail.com" }
  # 社交网址
  s.social_media_url = 'https://blog.91renb.com'
  
  # 框架支持的平台和版本
  s.platform     = :ios, "8.0"

  # GitHib下载地址和版本
  s.source       = { :git => "https://github.com/91renb/BRPickerView.git", :tag => s.version.to_s }

  # 本地框架源文件的位置
  s.source_files  = "BRPickerView/**/*.{h,m}"
  
  # 框架包含的资源包
  s.resources  = "BRPickerView/AddressPickerView/BRPickerView.bundle"

  # 框架要求ARC环境下使用
  s.requires_arc = true

 
end
