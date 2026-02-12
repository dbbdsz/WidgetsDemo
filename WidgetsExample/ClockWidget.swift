//
//  ClockWidget.swift
//  WidgetsExample
//
//  Created by admin on 2026/2/11.
//

import WidgetKit
import SwiftUI

// MARK: - 时钟 Widget

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct ClockProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> ()) {
        let entry = ClockEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> ()) {
        // 生成未来一分钟内的每秒更新条目，并确保对齐到秒的起始
        var entries: [ClockEntry] = []
        let calendar = Calendar.current
        let now = Date()
        
        // 获取当前秒的起始点，消除毫秒级偏移
        let currentSeconds = calendar.component(.second, from: now)
        let startOfCurrentSecond = calendar.date(bySetting: .second, value: currentSeconds, of: now)!
        
        // 预生成 60 个条目，确保秒数精确对齐
        for offset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .second, value: offset, to: startOfCurrentSecond) {
                // 只有当 entryDate 在现在或之后时才添加，避免过时条目
                if entryDate >= now.addingTimeInterval(-0.1) {
                    entries.append(ClockEntry(date: entryDate))
                }
            }
        }
        
        // 如果由于过滤导致 entries 为空，至少加一个当前的
        if entries.isEmpty {
            entries.append(ClockEntry(date: now))
        }
        
        // 策略：在条目用完后重新请求时间轴
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ClockWidgetView: View {
    var entry: ClockEntry
    @Environment(\.widgetFamily) var family
    
    // 日期格式化器（月日 星期）
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 E"
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // 农历格式化器
    private var lunarFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .chinese)
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // 获取农历字符串
    private var lunarString: String {
        let lunarDate = lunarFormatter.string(from: entry.date)
        return convertToChineseLunar(lunarDate)
    }
    
    // 转换农历为中文
    private func convertToChineseLunar(_ lunarDate: String) -> String {
        var result = ""
        
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents([.year, .month, .day], from: entry.date)
        
        // 天干地支年份
        let yearIndex = (components.year! - 1) % 60
        let tianGan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        let diZhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        let yearName = tianGan[yearIndex % 10] + diZhi[yearIndex % 12] + "年"
        
        // 月份
        let months = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
        let monthName = months[components.month! - 1]
        
        // 日期
        let chineseDay = convertDayToChinese(components.day!)
        
        result = yearName + monthName + chineseDay
        return result
    }
    
    // 转换日期为中文
    private func convertDayToChinese(_ day: Int) -> String {
        let days = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                    "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                    "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        
        if day > 0 && day <= 30 {
            return days[day - 1]
        }
        return "\(day)日"
    }
    
    var body: some View {
        ZStack {
            // 黑色背景
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 4) {
                // 时间显示
                HStack(spacing: 0) {
                    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: entry.date)
                    
                    // 时
                    Text(String(format: "%02d", components.hour ?? 0))
                    Text(":")
                    // 分
                    Text(String(format: "%02d", components.minute ?? 0))
                    Text(":")
                    // 秒
                    Text(String(format: "%02d", components.second ?? 0))
                }
                .font(.system(size: 72, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .monospacedDigit()
                .contentTransition(.identity) // 禁用内容切换动画，防止数字跳动
                
                VStack(spacing: 2) {
                    // 日期显示（月日 星期）
                    Text(dateFormatter.string(from: entry.date))
                        .font(.system(size: 22, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                    
                    // 农历显示
                    Text(lunarString)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ClockWidget: Widget {
    let kind: String = "ClockWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            if #available(iOS 17.0, *) {
                ClockWidgetView(entry: entry)
                    .containerBackground(.black, for: .widget)
            } else {
                ClockWidgetView(entry: entry)
            }
        }
        .configurationDisplayName("时钟")
        .description("显示当前时间和日期")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
