Pod::Spec.new do |s|
  # 框架的名称
  s.name         = "BRPickerView"
  # 框架的版本号
  s.version      = "2.9.2"
  # 框架的简单介绍
  s.summary      = "A custom picker view for iOS."
  # 框架的详细描述(详细介绍，要比简介长)
  s.description  = <<-DESC
                    A custom picker view for iOS, Include "日期选择器，时间选择器，地址选择器，自定义字符串选择器，支持自定义样式，适配深色模式", Support the Objective - C language.
                DESC
  # 框架的主页
  s.homepage     = "https://github.com/agiapp/BRPickerView"
  # 证书类型
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # 作者
  s.author             = { "任波" => "developer@irenb.com" }
  # 社交网址
  s.social_media_url = 'https://www.irenb.com'
  
  # 框架支持的平台和版本
  s.platform     = :ios, "9.0"

  # GitHub下载地址和版本
  s.source       = { :git => "https://github.com/agiapp/BRPickerView.git", :tag => s.version.to_s }


  s.public_header_files = 'BRPickerView/BRPickerView.h'
    
  # 本地框架源文件的位置（包含所有文件）
  #s.source_files  = "BRPickerView/**/*.{h,m}"
  # 一级目录（pod库中根目录所含文件）
  s.source_files  = "BRPickerView/BRPickerView.h"
  # 隐私清单
  s.resource_bundles = { 'BRPickerView.Privacy' => 'BRPickerView/PrivacyInfo.xcprivacy' }
  
  s.default_subspec = 'All'
  
  # 二级目录（根目录是s，使用s.subspec设置子目录，这里设置子目录为ss）
  s.subspec 'Default' do |ss|
    ss.dependency 'BRPickerView/DatePicker'
    ss.dependency 'BRPickerView/TextPicker'
  end
  
  # 全部组件（包含废弃的）
  s.subspec 'All' do |ss|
    ss.dependency 'BRPickerView/Default'
    ss.dependency 'BRPickerView/Deprecated'
  end
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'BRPickerView/Core/*.{h,m}'
    # 框架包含的资源包
    ss.resources  = 'BRPickerView/Core/BRPickerView.bundle'
  end
  
  s.subspec 'DatePicker' do |ss|
    ss.dependency 'BRPickerView/Core'
    ss.source_files = 'BRPickerView/DatePicker/*.{h,m}'
  end
  
  s.subspec 'TextPicker' do |ss|
    ss.dependency 'BRPickerView/Core'
    ss.source_files = 'BRPickerView/TextPicker/*.{h,m}'
  end
  
  # 废弃组件
  s.subspec 'Deprecated' do |ss|
    ss.dependency 'BRPickerView/Core'
    # 三级目录
    ss.subspec 'Base' do |sss|
      sss.source_files = 'BRPickerView/Deprecated/Base/*.{h,m}'
    end
    ss.subspec 'AddressPickerView' do |sss|
      sss.dependency 'BRPickerView/Deprecated/Base'
      sss.source_files = 'BRPickerView/Deprecated/AddressPickerView/*.{h,m}'
      # 地址选择器包含的资源包
      sss.resources  = 'BRPickerView/Deprecated/AddressPickerView/BRAddressPickerView.bundle'
    end
    ss.subspec 'StringPickerView' do |sss|
      sss.dependency 'BRPickerView/Deprecated/Base'
      sss.source_files = 'BRPickerView/Deprecated/StringPickerView/*.{h,m}'
    end
  end
  
  # 兼容老版本pod方式
  s.subspec 'AddressPickerView' do |ss|
    ss.dependency 'BRPickerView/Deprecated/AddressPickerView'
  end

  s.subspec 'StringPickerView' do |ss|
    ss.dependency 'BRPickerView/Deprecated/StringPickerView'
  end
  
  
  # 框架要求ARC环境下使用
  s.requires_arc = true

end
