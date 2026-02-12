# WidgetsDemo

English | [简体中文](README.md)

A feature-rich iOS Widget demo project showcasing various widget types and data communication methods.

## Features

### 📱 Widget Types

1. **Communication Example Widget**
   - Demonstrates data communication between App and Widget
   - Supports message passing and counter functionality
   - Shows three refresh methods: auto-refresh, manual refresh, and Timeline refresh

2. **Clock Widget**
   - Real-time display of current time (HH:MM:SS)
   - Shows Gregorian calendar date and day of week
   - Displays Chinese lunar calendar (with Heavenly Stems and Earthly Branches)
   - Black theme design, clean and elegant

3. **Stock Line Chart Widget**
   - Real-time stock price trend chart
   - Supports multiple stock symbols (AAPL, GOOGL, MSFT, etc.)
   - Dynamic gradient background (green for gains, red for losses)
   - Shows current price, change amount and percentage
   - Uses Swift Charts framework (iOS 16+)

4. **Circular Progress Widget**
   - Visualizes goal completion progress
   - Gradient circular ring design
   - Supports custom title, target value, and unit
   - Suitable for steps, calories, and other scenarios

5. **Bar Chart Widget**
   - Colorful bar chart data display
   - Supports weekly data comparison
   - Uses Swift Charts framework (iOS 16+)
   - iOS 15 compatibility fallback

### 🔄 Data Communication

- **App Groups**: Uses App Groups to share data between main App and Widget
- **UserDefaults**: Stores and reads data through shared UserDefaults
- **Timeline Provider**: Intelligent timeline management with auto-refresh support

### 🎨 Design Highlights

- Modern SwiftUI interface
- Dark mode support
- Smooth animations
- Responsive layout design
- iOS 15+ compatibility handling

## Tech Stack

- **Language**: Swift
- **Frameworks**: SwiftUI, WidgetKit
- **Charts**: Swift Charts (iOS 16+)
- **Minimum Support**: iOS 15.0+
- **Development Tools**: Xcode 14.0+

## Project Structure

```
WidgetsDemo/
├── WidgetsDemo/                    # Main App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ViewController.swift
│   └── AdvancedWidgetController.swift
│
└── WidgetsExample/                 # Widget Extension
    ├── WidgetsExample.swift        # Communication example widget
    ├── ClockWidget.swift           # Clock widget
    ├── ChartWidgets.swift          # Chart widgets
    └── WidgetsExampleBundle.swift  # Widget Bundle
```

## Installation and Running

1. Clone the project
```bash
git clone https://github.com/dbbdsz/WidgetsDemo.git
cd WidgetsDemo
```

2. Open Xcode project
```bash
open WidgetsDemo.xcodeproj
```

3. Configure App Groups
   - Select Target in Xcode
   - Go to "Signing & Capabilities"
   - Add "App Groups" capability
   - Use ID: `group.com.example.widgetsdemo`

4. Run the project
   - Select target device or simulator
   - Click the Run button (⌘R)

5. Add widgets
   - Long press on home screen
   - Tap the "+" button in the top left
   - Search for "WidgetsDemo"
   - Select the widget type you want

## Usage Guide

### Communication Example Widget

In the main App you can:
- Send messages to the widget
- Increment the counter
- Trigger widget refresh

### Stock Widget

Supported stock symbols:
- AAPL - Apple Inc.
- GOOGL - Alphabet Inc.
- MSFT - Microsoft Corp.
- AMZN - Amazon.com Inc.
- TSLA - Tesla Inc.
- META - Meta Platforms
- NVDA - NVIDIA Corp.
- NFLX - Netflix Inc.

### Progress Widget

Customizable:
- Title (e.g., "Daily Steps")
- Current value and target value
- Unit (e.g., "steps", "calories")

## Core Code Examples

### Data Sharing

```swift
class SharedDataManager {
    static let shared = SharedDataManager()
    private let appGroupID = "group.com.example.widgetsdemo"
    
    func saveMessage(_ message: String) {
        userDefaults?.set(message, forKey: messageKey)
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    func getMessage() -> String {
        return userDefaults?.string(forKey: messageKey) ?? "No message"
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

## Compatibility

- iOS 15.0+ - Basic features
- iOS 16.0+ - Swift Charts support
- iOS 17.0+ - Container background API

The project includes complete fallback handling to ensure proper operation on older iOS versions.

## License

MIT License

## Author

dbbdsz

## Contributing

Issues and Pull Requests are welcome!

## Related Resources

- [Apple WidgetKit Documentation](https://developer.apple.com/documentation/widgetkit)
- [Swift Charts Documentation](https://developer.apple.com/documentation/charts)
- [App Groups Guide](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)
