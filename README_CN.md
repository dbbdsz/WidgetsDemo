# WidgetsDemo

[English](README_EN.md) | 简体中文

一个功能丰富的 iOS Widget 示例项目，展示了多种小组件类型和数据通信方式。

## 功能特性

### 📱 小组件类型

1. **通信示例小组件**
   - 演示 App 与 Widget 之间的数据通信
   - 支持消息传递和计数器功能
   - 展示三种刷新方式：自动刷新、手动刷新、Timeline 刷新

2. **时钟小组件**
   - 实时显示当前时间（时:分:秒）
   - 显示公历日期和星期
   - 显示农历日期（天干地支年份）
   - 黑色主题设计，简洁优雅

3. **股票折线图小组件**
   - 实时股票价格走势图
   - 支持多种股票代码（AAPL、GOOGL、MSFT 等）
   - 动态渐变背景（涨绿跌红）
   - 显示当前价格、涨跌幅度和百分比
   - 使用 Swift Charts 框架（iOS 16+）

4. **圆形进度小组件**
   - 可视化目标完成进度
   - 渐变色圆环设计
   - 支持自定义标题、目标值和单位
   - 适用于步数、卡路里等场景

5. **柱状图小组件**
   - 多彩柱状图数据展示
   - 支持周数据对比
   - 使用 Swift Charts 框架（iOS 16+）
   - iOS 15 兼容降级方案

### 🔄 数据通信

- **App Groups**：使用 App Groups 在主 App 和 Widget 之间共享数据
- **UserDefaults**：通过共享的 UserDefaults 存储和读取数据
- **Timeline Provider**：智能的时间轴管理，支持自动刷新

### 🎨 设计亮点

- 现代化的 SwiftUI 界面
- 支持深色模式
- 流畅的动画效果
- 响应式布局设计
- iOS 15+ 兼容性处理

## 技术栈

- **语言**：Swift
- **框架**：SwiftUI, WidgetKit
- **图表**：Swift Charts (iOS 16+)
- **最低支持**：iOS 15.0+
- **开发工具**：Xcode 14.0+

## 项目结构

```
WidgetsDemo/
├── WidgetsDemo/                    # 主应用
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
│   └── AdvancedWidgetController.swift
│
└── WidgetsExample/                 # Widget Extension
    ├── WidgetsExample.swift        # 通信示例小组件
    ├── ClockWidget.swift           # 时钟小组件
    ├── ChartWidgets.swift          # 图表类小组件
    └── WidgetsExampleBundle.swift  # Widget Bundle
```

## 安装和运行

1. 克隆项目
```bash
git clone https://github.com/dbbdsz/WidgetsDemo.git
cd WidgetsDemo
```

2. 打开 Xcode 项目
```bash
open WidgetsDemo.xcodeproj
```

3. 配置 App Groups
   - 在 Xcode 中选择 Target
   - 进入 "Signing & Capabilities"
   - 添加 "App Groups" capability
   - 使用 ID：`group.com.example.widgetsdemo`

4. 运行项目
   - 选择目标设备或模拟器
   - 点击运行按钮（⌘R）

5. 添加小组件
   - 长按主屏幕
   - 点击左上角的 "+" 按钮
   - 搜索 "WidgetsDemo"
   - 选择想要的小组件类型

## 使用说明

### 通信示例小组件

在主 App 中可以：
- 发送消息到小组件
- 增加计数器
- 触发小组件刷新

### 股票小组件

支持的股票代码：
- AAPL - Apple Inc.
- GOOGL - Alphabet Inc.
- MSFT - Microsoft Corp.
- AMZN - Amazon.com Inc.
- TSLA - Tesla Inc.
- META - Meta Platforms
- NVDA - NVIDIA Corp.
- NFLX - Netflix Inc.

### 进度小组件

可自定义：
- 标题（如"今日步数"）
- 当前值和目标值
- 单位（如"步"、"卡路里"）

## 核心代码示例

### 数据共享

```swift
class SharedDataManager {
    static let shared = SharedDataManager()
    private let appGroupID = "group.com.example.widgetsdemo"
    
    func saveMessage(_ message: String) {
        userDefaults?.set(message, forKey: messageKey)
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    func getMessage() -> String {
        return userDefaults?.string(forKey: messageKey) ?? "暂无消息"
    }
}
```

### Timeline Provider

```swift
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    let currentDate = Date()
    
    for minuteOffset in 0 ..< 5 {
        let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 15, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, ...)
        entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
}
```

## 兼容性

- iOS 15.0+ - 基础功能
- iOS 16.0+ - Swift Charts 支持
- iOS 17.0+ - 容器背景 API

项目包含完整的降级处理，确保在旧版本 iOS 上也能正常运行。

## 许可证

MIT License

## 作者

dbbdsz

## 贡献

欢迎提交 Issue 和 Pull Request！

## 相关资源

- [Apple WidgetKit 文档](https://developer.apple.com/documentation/widgetkit)
- [Swift Charts 文档](https://developer.apple.com/documentation/charts)
- [App Groups 指南](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)
