//
//  WidgetsExample.swift
//  WidgetsExample
//
//  Created by admin on 2026/2/11.
//

import WidgetKit
import SwiftUI

// MARK: - 数据模型
struct StockDataPoint: Identifiable, Codable {
    let id = UUID()
    let time: String
    let price: Double
}

struct BarChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

// MARK: - 共享数据管理器
/// 使用 App Groups 在主 App 和 Widget 之间共享数据
class SharedDataManager {
    static let shared = SharedDataManager()
    
    // App Group 标识符（需要在 Xcode 中配置）
    private let appGroupID = "group.com.example.widgetsdemo"
    
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    // 数据键
    private let messageKey = "sharedMessage"
    private let counterKey = "sharedCounter"
    private let lastUpdateKey = "lastUpdateTime"
    
    // 保存消息
    func saveMessage(_ message: String) {
        userDefaults?.set(message, forKey: messageKey)
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    // 读取消息
    func getMessage() -> String {
        return userDefaults?.string(forKey: messageKey) ?? "暂无消息"
    }
    
    // 增加计数器
    func incrementCounter() {
        let current = getCounter()
        userDefaults?.set(current + 1, forKey: counterKey)
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    // 获取计数器
    func getCounter() -> Int {
        return userDefaults?.integer(forKey: counterKey) ?? 0
    }
    
    // 获取最后更新时间
    func getLastUpdateTime() -> Date? {
        return userDefaults?.object(forKey: lastUpdateKey) as? Date
    }
    
    // MARK: - 股票数据
    func saveStockData(name: String, price: Double, change: Double, data: [[String: Any]]) {
        userDefaults?.set(name, forKey: "stockName")
        userDefaults?.set(price, forKey: "stockPrice")
        userDefaults?.set(change, forKey: "stockChange")
        if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
            userDefaults?.set(jsonData, forKey: "stockData")
        }
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    func getStockName() -> String {
        return userDefaults?.string(forKey: "stockName") ?? "AAPL"
    }
    
    func getStockPrice() -> Double {
        return userDefaults?.double(forKey: "stockPrice") ?? 178.50
    }
    
    func getStockChange() -> Double {
        return userDefaults?.double(forKey: "stockChange") ?? 2.35
    }
    
    func getStockData() -> [StockDataPoint] {
        guard let jsonData = userDefaults?.data(forKey: "stockData"),
              let array = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return generateDefaultStockData()
        }
        
        return array.compactMap { dict in
            guard let time = dict["time"] as? String,
                  let price = dict["price"] as? Double else { return nil }
            return StockDataPoint(time: time, price: price)
        }
    }
    
    private func generateDefaultStockData() -> [StockDataPoint] {
        let times = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00"]
        let basePrice = 175.0
        
        // 生成超级波折的价格数据
        var prices: [Double] = []
        var currentPrice = basePrice
        
        for index in 0..<times.count {
            // 1. 整体趋势（更大幅度）
            let trendDirection = sin(Double(index) * 0.5)
            let trend = trendDirection * 3.0
            
            // 2. 超大幅随机波动
            let volatility = Double.random(in: -8.0...8.0)
            
            // 3. 多重周期叠加（更大幅度）
            let shortCycle = sin(Double(index) * 1.5) * 4.0
            let longCycle = cos(Double(index) * 0.4) * 5.0
            
            // 4. 更多突发事件（更大幅度）
            var spike: Double = 0
            if index == 2 {
                spike = Double.random(in: -8.0...10.0)
            } else if index == 5 {
                spike = Double.random(in: -10.0...12.0)
            } else if index == 8 {
                spike = Double.random(in: -9.0...11.0)
            } else if index == 12 {
                spike = Double.random(in: -7.0...9.0)
            }
            
            // 5. 动量效应（更强）
            let momentum = index > 0 ? (prices[index - 1] - basePrice) * 0.25 : 0
            
            // 6. 随机跳跃（更频繁、更大）
            let jump = Double.random(in: 0...1) > 0.5 ? Double.random(in: -6.0...6.0) : 0
            
            currentPrice = basePrice + trend + volatility + shortCycle + longCycle + spike + momentum + jump
            currentPrice = max(basePrice - 25, min(basePrice + 25, currentPrice))
            
            prices.append(currentPrice)
        }
        
        // 轻度平滑处理（保留更多波动）
        var smoothedPrices: [Double] = []
        for i in 0..<prices.count {
            if i == 0 || i == prices.count - 1 {
                smoothedPrices.append(prices[i])
            } else {
                let smoothed = prices[i] * 0.7 + prices[i-1] * 0.15 + prices[i+1] * 0.15
                smoothedPrices.append(smoothed)
            }
        }
        
        return times.enumerated().map { index, time in
            StockDataPoint(time: time, price: smoothedPrices[index])
        }
    }
    
    // MARK: - 进度数据
    func saveProgressData(title: String, progress: Double, current: Int, target: Int, unit: String) {
        userDefaults?.set(title, forKey: "progressTitle")
        userDefaults?.set(progress, forKey: "progress")
        userDefaults?.set(current, forKey: "currentValue")
        userDefaults?.set(target, forKey: "targetValue")
        userDefaults?.set(unit, forKey: "progressUnit")
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    func getProgressTitle() -> String {
        return userDefaults?.string(forKey: "progressTitle") ?? "今日步数"
    }
    
    func getProgress() -> Double {
        return userDefaults?.double(forKey: "progress") ?? 0.65
    }
    
    func getCurrentValue() -> Int {
        return userDefaults?.integer(forKey: "currentValue") ?? 6500
    }
    
    func getTargetValue() -> Int {
        return userDefaults?.integer(forKey: "targetValue") ?? 10000
    }
    
    func getProgressUnit() -> String {
        return userDefaults?.string(forKey: "progressUnit") ?? "步"
    }
    
    // MARK: - 柱状图数据
    func saveBarChartData(title: String, data: [[String: Any]], maxValue: Double) {
        userDefaults?.set(title, forKey: "barChartTitle")
        if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
            userDefaults?.set(jsonData, forKey: "barChartData")
        }
        userDefaults?.set(maxValue, forKey: "barChartMaxValue")
        userDefaults?.set(Date(), forKey: lastUpdateKey)
    }
    
    func getBarChartTitle() -> String {
        return userDefaults?.string(forKey: "barChartTitle") ?? "本周活动"
    }
    
    func getBarChartData() -> [BarChartDataPoint] {
        guard let jsonData = userDefaults?.data(forKey: "barChartData"),
              let array = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return generateDefaultBarData()
        }
        
        return array.compactMap { dict in
            guard let label = dict["label"] as? String,
                  let value = dict["value"] as? Double,
                  let colorName = dict["color"] as? String else { return nil }
            return BarChartDataPoint(label: label, value: value, color: colorFromString(colorName))
        }
    }
    
    func getBarChartMaxValue() -> Double {
        return userDefaults?.double(forKey: "barChartMaxValue") ?? 100.0
    }
    
    private func generateDefaultBarData() -> [BarChartDataPoint] {
        let days = ["一", "二", "三", "四", "五", "六", "日"]
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .cyan]
        return days.enumerated().map { index, day in
            BarChartDataPoint(label: day, value: Double(50 + index * 5), color: colors[index])
        }
    }
    
    private func colorFromString(_ name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "red": return .red
        case "cyan": return .cyan
        default: return .blue
        }
    }
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            message: "加载中...",
            counter: 0,
            refreshType: "占位符"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            message: SharedDataManager.shared.getMessage(),
            counter: SharedDataManager.shared.getCounter(),
            refreshType: "快照"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // 从共享存储读取数据
        let message = SharedDataManager.shared.getMessage()
        let counter = SharedDataManager.shared.getCounter()
        let currentDate = Date()
        
        // 生成未来 5 个时间点的条目（每 15 分钟一个）
        // 这是【自动刷新】方式：系统会按照 timeline 自动更新
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 15, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                message: message,
                counter: counter,
                refreshType: "自动刷新 (\(minuteOffset * 15)分钟)"
            )
            entries.append(entry)
        }
        
        // Timeline 刷新策略：
        // .atEnd - 在最后一个条目后刷新（约 1 小时后）
        // .after(date) - 在指定时间后刷新
        // .never - 永不自动刷新，只能手动刷新
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
    let counter: Int
    let refreshType: String
}

// MARK: - Widget View
struct WidgetsExampleEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 标题
            Text("小组件示例")
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            // 消息内容
            HStack {
                Image(systemName: "message.fill")
                    .foregroundColor(.blue)
                Text(entry.message)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            // 计数器
            HStack {
                Image(systemName: "number.circle.fill")
                    .foregroundColor(.green)
                Text("计数: \(entry.counter)")
                    .font(.subheadline)
            }
            
            Spacer()
            
            // 更新信息
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.refreshType)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - Widget Configuration
struct WidgetsExample: Widget {
    let kind: String = "WidgetsExample"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetsExampleEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetsExampleEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("通信示例小组件")
        .description("演示 App 与 Widget 之间的三种刷新方式")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    WidgetsExample()
} timeline: {
    SimpleEntry(date: .now, message: "你好，Widget！", counter: 5, refreshType: "预览")
    SimpleEntry(date: .now, message: "数据已更新", counter: 10, refreshType: "预览")
}
