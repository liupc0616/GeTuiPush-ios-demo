/********************************************************************************************************/


=============		简介				=============

个推推送是一个端到端的推送服务，通过集成个推SDK，开发者能够及时有效地将服务端消息推送到客户端上，并针对用户画像进行精细化
运营，从而积极地保持与用户的连接，并提高用户活跃度和留存率。

本 iOS SDK 方便开发者基于个推来快捷地为 iOS 应用增加推送功能，减少开发者集成 APNs(Apple Push Notification Service) 需要的工作量，降低开发复杂度。同时最新SDK还支持独有的 APNs 展示和点击统计，有助于开发者掌握更精准的推送数据，优化运营效果。



=============		资料包结构		=============

GETUI_IOS_SDK/
  |- readme.txt （SDK说明）
  |- Lib/
  |    |- GtSdkLib/ （标准版个推SDK.xcframework文件）
  |    |   |- GTExtensionSDK.xcframework
  |    |   |- GTSDK.xcframework
  |    |- GtSdkLib-noidfa/ （无IDFA版个推SDK.xcframework文件）
  |- Demo/w
  |    |- GtSdkDemo/ （XCode标准集成演示Demo工程）
  |    |- GtSdkDemo-objc/ （Object-C标准集成框架代码工程，示范CocoaPods集成）
  |    |- GtSdkDemo-swift/ （Swift标准集成框架代码工程）
  |    |- GtSdkLib/ （个推SDK库文件，供上述Demo工程引用）



=============		文档中心			=============

* 个推文档中心: http://docs.getui.com
* iOS SDK 概述: http://docs.getui.com/getui/mobile/ios/overview
* iOS SDK 3分钟演示: http://docs.getui.com/getui/mobile/ios/demo
* iOS SDK 集成指南: http://docs.getui.com/getui/mobile/ios/xcode
* iOS SDK APPLink接入: http://docs.getui.com/getui/mobile/ios/applink
* iOS SDK API接口文档: http://docs.getui.com/getui/mobile/ios/api
* iOS 证书配置指南: http://docs.getui.com/getui/mobile/ios/apns



=============		联系方式			=============

个推官网：www.getui.com
个推开放平台：dev.getui.com
客服QQ：2880983152



/********************************************************************************************************/