//
//  ChartWidgets.swift
//  WidgetsExample
//
//  Created by admin on 2026/2/11.
//

import WidgetKit
import SwiftUI
#if canImport(Charts)
import Charts
#endif

// MARK: - 股票折线图 Widget

struct StockChartEntry: TimelineEntry {
    let date: Date
    let stockName: String
    let currentPrice: Double
    let priceChange: Double
    let priceData: [StockDataPoint]
}

struct StockChartProvider: TimelineProvider {
    func placeholder(in context: Context) -> StockChartEntry {
        StockChartEntry(
            date: Date(),
            stockName: "AAPL",
            currentPrice: 178.50,
            priceChange: 2.35,
            priceData: Self.generateSampleStockData()
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StockChartEntry) -> ()) {
        let entry = StockChartEntry(
            date: Date(),
            stockName: SharedDataManager.shared.getStockName(),
            currentPrice: SharedDataManager.shared.getStockPrice(),
            priceChange: SharedDataManager.shared.getStockChange(),
            priceData: SharedDataManager.shared.getStockData()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StockChartEntry>) -> ()) {
        var entries: [StockChartEntry] = []
        let currentDate = Date()
        
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 15, to: currentDate)!
            let entry = StockChartEntry(
                date: entryDate,
                stockName: SharedDataManager.shared.getStockName(),
                currentPrice: SharedDataManager.shared.getStockPrice(),
                priceChange: SharedDataManager.shared.getStockChange(),
                priceData: SharedDataManager.shared.getStockData()
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private static func generateSampleStockData() -> [StockDataPoint] {
        let times = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00"]
        let basePrice = 175.0
        
        // 生成超级波折的价格数据
        var prices: [Double] = []
        var currentPrice = basePrice
        
        for index in 0..<times.count {
            // 1. 整体趋势（更大幅度）
            let trendDirection = sin(Double(index) * 0.5)
            let trend = trendDirection * 3.0  // 从 0.8 增加到 3.0
            
            // 2. 超大幅随机波动
            let volatility = Double.random(in: -8.0...8.0)  // 从 ±4.5 增加到 ±8.0
            
            // 3. 多重周期叠加（更大幅度）
            let shortCycle = sin(Double(index) * 1.5) * 4.0  // 从 2.0 增加到 4.0
            let longCycle = cos(Double(index) * 0.4) * 5.0   // 从 3.5 增加到 5.0
            
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
            let momentum = index > 0 ? (prices[index - 1] - basePrice) * 0.25 : 0  // 从 0.15 增加到 0.25
            
            // 6. 随机跳跃（更频繁、更大）
            let jump = Double.random(in: 0...1) > 0.5 ? Double.random(in: -6.0...6.0) : 0  // 概率从30%增加到50%，幅度从±3增加到±6
            
            // 综合计算价格
            currentPrice = basePrice + trend + volatility + shortCycle + longCycle + spike + momentum + jump
            
            // 限制价格范围，避免过度偏离
            currentPrice = max(basePrice - 25, min(basePrice + 25, currentPrice))  // 范围从±15增加到±25
            
            prices.append(currentPrice)
        }
        
        // 轻度平滑处理（保留更多波动）
        var smoothedPrices: [Double] = []
        for i in 0..<prices.count {
            if i == 0 || i == prices.count - 1 {
                smoothedPrices.append(prices[i])
            } else {
                // 使用加权平均，保留更多原始波动
                let smoothed = prices[i] * 0.7 + prices[i-1] * 0.15 + prices[i+1] * 0.15  // 从60%增加到70%
                smoothedPrices.append(smoothed)
            }
        }
        
        return times.enumerated().map { index, time in
            StockDataPoint(time: time, price: smoothedPrices[index])
        }
    }
}

struct StockChartWidgetView: View {
    var entry: StockChartEntry
    
    // 计算涨跌百分比
    private var changePercentage: Double {
        (entry.priceChange / entry.currentPrice) * 100
    }
    
    // 判断是否上涨
    private var isPositive: Bool {
        entry.priceChange >= 0
    }
    
    // 主题颜色
    private var themeColor: Color {
        isPositive ? Color.green : Color.red
    }
    
    var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                colors: [
                    themeColor.opacity(0.15),
                    themeColor.opacity(0.05),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // 顶部信息区域
                HStack(alignment: .top, spacing: 12) {
                    // 左侧：股票代码和公司名
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            // 趋势图标
                            Image(systemName: isPositive ? "triangle.fill" : "triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(themeColor)
                                .rotationEffect(.degrees(isPositive ? 0 : 180))
                            
                            Text(entry.stockName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Text(getCompanyName(for: entry.stockName))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 右侧：涨跌信息
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(isPositive ? "+" : "")
                            Text("\(entry.priceChange, specifier: "%.2f")")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(themeColor)
                        
                        HStack(spacing: 4) {
                            Text(isPositive ? "+" : "")
                            Text("\(changePercentage, specifier: "%.2f")%")
                        }
                        .font(.system(size: 11))
                        .foregroundColor(themeColor.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                Spacer().frame(height: 8)
                
                // 中间：折线图
                ZStack(alignment: .bottom) {
                    if #available(iOS 16.0, *) {
                        Chart(entry.priceData) { dataPoint in
                            // 渐变区域
                            AreaMark(
                                x: .value("时间", dataPoint.time),
                                y: .value("价格", dataPoint.price)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        themeColor.opacity(0.4),
                                        themeColor.opacity(0.2),
                                        themeColor.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                            
                            // 折线
                            LineMark(
                                x: .value("时间", dataPoint.time),
                                y: .value("价格", dataPoint.price)
                            )
                            .foregroundStyle(themeColor)
                            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.catmullRom)
                        }
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .chartLegend(.hidden)
                        .frame(height: 100)
                    } else {
                        // iOS 16 以下的简化版本
                        EnhancedLineChart(
                            data: entry.priceData.map { $0.price },
                            color: themeColor,
                            showGradient: true
                        )
                        .frame(height: 100)
                    }
                    
                    // 基准线（虚线）
                    if !entry.priceData.isEmpty {
                        GeometryReader { geometry in
                            Path { path in
                                let y = geometry.size.height * 0.5
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                            }
                            .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                            .foregroundColor(.secondary.opacity(0.3))
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                Spacer().frame(height: 8)
                
                // 底部：当前价格和时间
                HStack(alignment: .bottom) {
                    // 当前价格（大号显示）
                    Text("$\(entry.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // 更新时间
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("更新时间")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        Text(entry.date, style: .time)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
    }
    
    // 根据股票代码获取公司名称
    private func getCompanyName(for symbol: String) -> String {
        let companies: [String: String] = [
            "AAPL": "Apple Inc.",
            "GOOGL": "Alphabet Inc.",
            "MSFT": "Microsoft Corp.",
            "AMZN": "Amazon.com Inc.",
            "TSLA": "Tesla Inc.",
            "META": "Meta Platforms",
            "NVDA": "NVIDIA Corp.",
            "NFLX": "Netflix Inc."
        ]
        return companies[symbol] ?? "Company"
    }
}

// MARK: - 增强版折线图（iOS 15 兼容）
struct EnhancedLineChart: View {
    let data: [Double]
    let color: Color
    let showGradient: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            ZStack {
                // 渐变填充
                if showGradient {
                    Path { path in
                        for (index, value) in data.enumerated() {
                            let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
                            let y = geometry.size.height - (CGFloat((value - minValue) / range) * geometry.size.height)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        
                        // 闭合路径以填充
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(0.4),
                                color.opacity(0.2),
                                color.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
                // 折线
                Path { path in
                    for (index, value) in data.enumerated() {
                        let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
                        let y = geometry.size.height - (CGFloat((value - minValue) / range) * geometry.size.height)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

struct StockChartWidget: Widget {
    let kind: String = "StockChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StockChartProvider()) { entry in
            if #available(iOS 17.0, *) {
                StockChartWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                StockChartWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("股票折线图")
        .description("显示股票价格走势")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// MARK: - 圆形进度 Widget

struct CircularProgressEntry: TimelineEntry {
    let date: Date
    let title: String
    let progress: Double
    let currentValue: Int
    let targetValue: Int
    let unit: String
}

struct CircularProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> CircularProgressEntry {
        CircularProgressEntry(
            date: Date(),
            title: "今日步数",
            progress: 0.65,
            currentValue: 6500,
            targetValue: 10000,
            unit: "步"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CircularProgressEntry) -> ()) {
        let entry = CircularProgressEntry(
            date: Date(),
            title: SharedDataManager.shared.getProgressTitle(),
            progress: SharedDataManager.shared.getProgress(),
            currentValue: SharedDataManager.shared.getCurrentValue(),
            targetValue: SharedDataManager.shared.getTargetValue(),
            unit: SharedDataManager.shared.getProgressUnit()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CircularProgressEntry>) -> ()) {
        var entries: [CircularProgressEntry] = []
        let currentDate = Date()
        
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 15, to: currentDate)!
            let entry = CircularProgressEntry(
                date: entryDate,
                title: SharedDataManager.shared.getProgressTitle(),
                progress: SharedDataManager.shared.getProgress(),
                currentValue: SharedDataManager.shared.getCurrentValue(),
                targetValue: SharedDataManager.shared.getTargetValue(),
                unit: SharedDataManager.shared.getProgressUnit()
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CircularProgressWidgetView: View {
    var entry: CircularProgressEntry
    
    var body: some View {
        VStack(spacing: 12) {
            Text(entry.title)
                .font(.headline)
                .fontWeight(.semibold)
            
            ZStack {
                // 背景圆环
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                // 进度圆环
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: entry.progress)
                
                // 中心文字
                VStack(spacing: 4) {
                    Text("\(Int(entry.progress * 100))%")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(entry.currentValue)/\(entry.targetValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("\(entry.currentValue) \(entry.unit)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(entry.date, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct CircularProgressWidget: Widget {
    let kind: String = "CircularProgressWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CircularProgressProvider()) { entry in
            if #available(iOS 17.0, *) {
                CircularProgressWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CircularProgressWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("圆形进度")
        .description("显示目标完成进度")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - 柱状图 Widget

struct BarChartEntry: TimelineEntry {
    let date: Date
    let title: String
    let data: [BarChartDataPoint]
    let maxValue: Double
}

struct BarChartProvider: TimelineProvider {
    func placeholder(in context: Context) -> BarChartEntry {
        BarChartEntry(
            date: Date(),
            title: "本周活动",
            data: Self.generateSampleBarData(),
            maxValue: 100
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BarChartEntry) -> ()) {
        let entry = BarChartEntry(
            date: Date(),
            title: SharedDataManager.shared.getBarChartTitle(),
            data: SharedDataManager.shared.getBarChartData(),
            maxValue: SharedDataManager.shared.getBarChartMaxValue()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BarChartEntry>) -> ()) {
        var entries: [BarChartEntry] = []
        let currentDate = Date()
        
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 15, to: currentDate)!
            let entry = BarChartEntry(
                date: entryDate,
                title: SharedDataManager.shared.getBarChartTitle(),
                data: SharedDataManager.shared.getBarChartData(),
                maxValue: SharedDataManager.shared.getBarChartMaxValue()
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private static func generateSampleBarData() -> [BarChartDataPoint] {
        let days = ["一", "二", "三", "四", "五", "六", "日"]
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .cyan]
        return days.enumerated().map { index, day in
            BarChartDataPoint(
                label: day,
                value: Double.random(in: 30...100),
                color: colors[index]
            )
        }
    }
}

struct BarChartWidgetView: View {
    var entry: BarChartEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.title)
                .font(.headline)
                .fontWeight(.semibold)
            
            if #available(iOS 16.0, *) {
                Chart(entry.data) { dataPoint in
                    BarMark(
                        x: .value("日期", dataPoint.label),
                        y: .value("数值", dataPoint.value)
                    )
                    .foregroundStyle(dataPoint.color.gradient)
                    .cornerRadius(4)
                }
                .chartYScale(domain: 0...entry.maxValue)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel()
                            .font(.caption2)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                            .font(.caption2)
                    }
                }
            } else {
                // iOS 16 以下的简化版本
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(entry.data) { dataPoint in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(dataPoint.color)
                                .frame(width: 30, height: CGFloat(dataPoint.value / entry.maxValue * 80))
                            
                            Text(dataPoint.label)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 100)
            }
            
            Text(entry.date, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct BarChartWidget: Widget {
    let kind: String = "BarChartWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BarChartProvider()) { entry in
            if #available(iOS 17.0, *) {
                BarChartWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BarChartWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("柱状图")
        .description("显示数据对比")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// MARK: - 简化折线图（iOS 16 以下使用）

struct SimpleLineChart: View {
    let data: [Double]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            Path { path in
                for (index, value) in data.enumerated() {
                    let x = geometry.size.width / CGFloat(data.count - 1) * CGFloat(index)
                    let y = geometry.size.height - (CGFloat((value - minValue) / range) * geometry.size.height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, lineWidth: 2)
        }
    }
}
