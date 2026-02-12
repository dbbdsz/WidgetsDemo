//
//  ViewController.swift
//  WidgetsDemo
//
//  Created by admin on 2026/2/11.
//

import UIKit
import WidgetKit

// MARK: - 共享数据管理器（与 Widget 共享）
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
    
    // 重置计数器
    func resetCounter() {
        userDefaults?.set(0, forKey: counterKey)
        userDefaults?.set(Date(), forKey: lastUpdateKey)
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
    
    func getStockData() -> [[String: Any]] {
        guard let jsonData = userDefaults?.data(forKey: "stockData"),
              let array = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return generateDefaultStockData()
        }
        return array
    }
    
    private func generateDefaultStockData() -> [[String: Any]] {
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
            return [
                "time": time,
                "price": smoothedPrices[index]
            ] as [String : Any]
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
    
    func getBarChartData() -> [[String: Any]] {
        guard let jsonData = userDefaults?.data(forKey: "barChartData"),
              let array = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return generateDefaultBarData()
        }
        return array
    }
    
    func getBarChartMaxValue() -> Double {
        return userDefaults?.double(forKey: "barChartMaxValue") ?? 100.0
    }
    
    private func generateDefaultBarData() -> [[String: Any]] {
        let days = ["一", "二", "三", "四", "五", "六", "日"]
        let colors = ["blue", "green", "orange", "purple", "pink", "red", "cyan"]
        return days.enumerated().map { index, day in
            return [
                "label": day,
                "value": Double(50 + index * 5),
                "color": colors[index]
            ] as [String : Any]
        }
    }
}

// MARK: - 主视图控制器
class ViewController: UIViewController {
    
    // UI 组件
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // 消息输入区域
    private let messageTextField = UITextField()
    private let sendMessageButton = UIButton(type: .system)
    
    // 计数器区域
    private let counterLabel = UILabel()
    private let incrementButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    
    // 刷新方式说明
    private let refreshInfoLabel = UILabel()
    
    // 三种刷新按钮
    private let refreshMethod1Button = UIButton(type: .system)
    private let refreshMethod2Button = UIButton(type: .system)
    private let refreshMethod3Button = UIButton(type: .system)
    
    // 高级 Widget 按钮
    private let advancedWidgetsButton = UIButton(type: .system)
    
    // 随机数据生成按钮
    private let randomStockButton = UIButton(type: .system)
    private let randomProgressButton = UIButton(type: .system)
    
    // 状态显示
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCounterDisplay()
    }
    
    // MARK: - UI 设置
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 设置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 标题
        titleLabel.text = "Widget 通信示例"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        
        // 描述
        descriptionLabel.text = "演示主 App 与 Widget 之间的三种刷新方式"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        // 消息输入框
        messageTextField.placeholder = "输入要发送到 Widget 的消息"
        messageTextField.borderStyle = .roundedRect
        messageTextField.font = .systemFont(ofSize: 16)
        
        // 发送消息按钮
        sendMessageButton.setTitle("📤 发送消息到 Widget", for: .normal)
        sendMessageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        sendMessageButton.backgroundColor = .systemBlue
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.addTarget(self, action: #selector(sendMessageTapped), for: .touchUpInside)
        
        // 计数器标签
        counterLabel.text = "计数: 0"
        counterLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        counterLabel.textAlignment = .center
        
        // 增加按钮
        incrementButton.setTitle("➕ 增加计数", for: .normal)
        incrementButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        incrementButton.backgroundColor = .systemGreen
        incrementButton.setTitleColor(.white, for: .normal)
        incrementButton.layer.cornerRadius = 10
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        
        // 重置按钮
        resetButton.setTitle("🔄 重置计数", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        resetButton.backgroundColor = .systemOrange
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        
        // 刷新方式说明
        refreshInfoLabel.text = "三种 Widget 刷新方式："
        refreshInfoLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        refreshInfoLabel.textAlignment = .center
        
        // 刷新方式 1：自动刷新
        refreshMethod1Button.setTitle("⏰ 方式1: 自动刷新 (Timeline)", for: .normal)
        refreshMethod1Button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        refreshMethod1Button.backgroundColor = .systemPurple
        refreshMethod1Button.setTitleColor(.white, for: .normal)
        refreshMethod1Button.layer.cornerRadius = 10
        refreshMethod1Button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        refreshMethod1Button.addTarget(self, action: #selector(showAutoRefreshInfo), for: .touchUpInside)
        
        // 刷新方式 2：主 App 触发刷新
        refreshMethod2Button.setTitle("📱 方式2: App 主动刷新", for: .normal)
        refreshMethod2Button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        refreshMethod2Button.backgroundColor = .systemIndigo
        refreshMethod2Button.setTitleColor(.white, for: .normal)
        refreshMethod2Button.layer.cornerRadius = 10
        refreshMethod2Button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        refreshMethod2Button.addTarget(self, action: #selector(triggerWidgetRefresh), for: .touchUpInside)
        
        // 刷新方式 3：用户手动刷新
        refreshMethod3Button.setTitle("👆 方式3: 用户手动刷新", for: .normal)
        refreshMethod3Button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        refreshMethod3Button.backgroundColor = .systemTeal
        refreshMethod3Button.setTitleColor(.white, for: .normal)
        refreshMethod3Button.layer.cornerRadius = 10
        refreshMethod3Button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        refreshMethod3Button.addTarget(self, action: #selector(showManualRefreshInfo), for: .touchUpInside)
        
        // 高级 Widget 按钮
        advancedWidgetsButton.setTitle("🎨 高级 Widget 控制", for: .normal)
        advancedWidgetsButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        advancedWidgetsButton.backgroundColor = .systemIndigo
        advancedWidgetsButton.setTitleColor(.white, for: .normal)
        advancedWidgetsButton.layer.cornerRadius = 10
        advancedWidgetsButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        advancedWidgetsButton.addTarget(self, action: #selector(showAdvancedWidgets), for: .touchUpInside)
        
        // 随机股票数据按钮
        randomStockButton.setTitle("🎲 生成随机股票数据", for: .normal)
        randomStockButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        randomStockButton.backgroundColor = .systemGreen
        randomStockButton.setTitleColor(.white, for: .normal)
        randomStockButton.layer.cornerRadius = 10
        randomStockButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        randomStockButton.addTarget(self, action: #selector(generateRandomStockData), for: .touchUpInside)
        
        // 随机进度数据按钮
        randomProgressButton.setTitle("🎲 生成随机进度数据", for: .normal)
        randomProgressButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        randomProgressButton.backgroundColor = .systemPurple
        randomProgressButton.setTitleColor(.white, for: .normal)
        randomProgressButton.layer.cornerRadius = 10
        randomProgressButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        randomProgressButton.addTarget(self, action: #selector(generateRandomProgressData), for: .touchUpInside)
        
        // 状态标签
        statusLabel.text = ""
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        
        // 添加所有子视图
        [titleLabel, descriptionLabel, messageTextField, sendMessageButton,
         counterLabel, incrementButton, resetButton,
         refreshInfoLabel, refreshMethod1Button, refreshMethod2Button, refreshMethod3Button,
         advancedWidgetsButton, randomStockButton, randomProgressButton,
         statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // 布局约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            messageTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            messageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            messageTextField.heightAnchor.constraint(equalToConstant: 44),
            
            sendMessageButton.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: 12),
            sendMessageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sendMessageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 50),
            
            counterLabel.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 30),
            counterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            incrementButton.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 12),
            incrementButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            incrementButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            incrementButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 12),
            resetButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            refreshInfoLabel.topAnchor.constraint(equalTo: incrementButton.bottomAnchor, constant: 40),
            refreshInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            refreshInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            refreshMethod1Button.topAnchor.constraint(equalTo: refreshInfoLabel.bottomAnchor, constant: 16),
            refreshMethod1Button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            refreshMethod1Button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            refreshMethod2Button.topAnchor.constraint(equalTo: refreshMethod1Button.bottomAnchor, constant: 12),
            refreshMethod2Button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            refreshMethod2Button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            refreshMethod3Button.topAnchor.constraint(equalTo: refreshMethod2Button.bottomAnchor, constant: 12),
            refreshMethod3Button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            refreshMethod3Button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            advancedWidgetsButton.topAnchor.constraint(equalTo: refreshMethod3Button.bottomAnchor, constant: 30),
            advancedWidgetsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            advancedWidgetsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            randomStockButton.topAnchor.constraint(equalTo: advancedWidgetsButton.bottomAnchor, constant: 20),
            randomStockButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            randomStockButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            randomProgressButton.topAnchor.constraint(equalTo: randomStockButton.bottomAnchor, constant: 12),
            randomProgressButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            randomProgressButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: randomProgressButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 按钮事件
    
    @objc private func sendMessageTapped() {
        guard let message = messageTextField.text, !message.isEmpty else {
            showStatus("请输入消息内容", isError: true)
            return
        }
        
        // 保存消息到共享存储
        SharedDataManager.shared.saveMessage(message)
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        
        // 触发 Widget 刷新（方式2）
        WidgetCenter.shared.reloadAllTimelines()
        
        showStatus("✅ 消息已发送到 Widget 并触发刷新", isError: false)
    }
    
    @objc private func incrementTapped() {
        SharedDataManager.shared.incrementCounter()
        updateCounterDisplay()
        
        // 触发 Widget 刷新（方式2）
        WidgetCenter.shared.reloadAllTimelines()
        
        showStatus("✅ 计数已增加并触发 Widget 刷新", isError: false)
    }
    
    @objc private func resetTapped() {
        SharedDataManager.shared.resetCounter()
        updateCounterDisplay()
        
        // 触发 Widget 刷新（方式2）
        WidgetCenter.shared.reloadAllTimelines()
        
        showStatus("✅ 计数已重置并触发 Widget 刷新", isError: false)
    }
    
    @objc private func showAutoRefreshInfo() {
        let message = """
        【方式1: 自动刷新 (Timeline)】
        
        • Widget 通过 Timeline 提供数据
        • 系统按照 timeline 策略自动更新
        • 本示例设置为每15分钟更新一次
        • Timeline Policy 可设置为：
          - .atEnd: 最后一个条目后刷新
          - .after(date): 指定时间后刷新
          - .never: 永不自动刷新
        
        这是最节能的刷新方式！
        """
        showAlert(title: "自动刷新说明", message: message)
    }
    
    @objc private func triggerWidgetRefresh() {
        // 方式2：主 App 主动触发 Widget 刷新
        WidgetCenter.shared.reloadAllTimelines()
        
        let message = """
        【方式2: App 主动刷新】
        
        ✅ 已触发 Widget 刷新！
        
        • 使用 WidgetCenter.shared.reloadAllTimelines()
        • 主 App 可以在任何时候触发刷新
        • 适用于数据更新后立即同步到 Widget
        • 也可以刷新特定 Widget：
          reloadTimelines(ofKind: "WidgetKind")
        
        这是最常用的刷新方式！
        """
        showAlert(title: "App 主动刷新", message: message)
    }
    
    @objc private func showManualRefreshInfo() {
        let message = """
        【方式3: 用户手动刷新】
        
        • 用户长按 Widget
        • 在弹出菜单中选择"刷新"
        • 系统会调用 getTimeline 重新获取数据
        
        操作步骤：
        1. 添加 Widget 到主屏幕
        2. 长按 Widget
        3. 点击"刷新"选项
        
        这是用户主动控制的刷新方式！
        """
        showAlert(title: "用户手动刷新说明", message: message)
    }
    
    @objc private func showAdvancedWidgets() {
        let advancedVC = AdvancedWidgetController()
        navigationController?.pushViewController(advancedVC, animated: true)
    }
    
    @objc private func generateRandomStockData() {
        // 随机选择股票
        let stocks = ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "META", "NVDA", "NFLX"]
        let randomStock = stocks.randomElement() ?? "AAPL"
        
        // 随机生成价格（100-300之间）
        let randomPrice = Double.random(in: 100...300)
        
        // 随机生成涨跌额（-10到+10之间）
        let randomChange = Double.random(in: -10...10)
        
        // 生成股票数据
        let stockData = self.generateStockDataForRandom()
        
        // 保存数据
        SharedDataManager.shared.saveStockData(
            name: randomStock,
            price: randomPrice,
            change: randomChange,
            data: stockData
        )
        
        // 刷新 Widget
        WidgetCenter.shared.reloadTimelines(ofKind: "StockChartWidget")
        
        // 显示状态
        let changeSymbol = randomChange >= 0 ? "+" : ""
        showStatus("✅ 已生成随机股票数据\n\(randomStock): $\(String(format: "%.2f", randomPrice)) (\(changeSymbol)\(String(format: "%.2f", randomChange)))", isError: false)
    }
    
    @objc private func generateRandomProgressData() {
        // 随机选择进度类型
        let progressTypes = [
            ("今日步数", "步", 10000),
            ("喝水目标", "杯", 8),
            ("学习时长", "分钟", 120),
            ("运动时长", "分钟", 60),
            ("阅读页数", "页", 50),
            ("卡路里消耗", "千卡", 500)
        ]
        
        let randomType = progressTypes.randomElement() ?? ("今日步数", "步", 10000)
        let title = randomType.0
        let unit = randomType.1
        let target = randomType.2
        
        // 随机生成当前值（目标的30%-95%之间）
        let minValue = Int(Double(target) * 0.3)
        let maxValue = Int(Double(target) * 0.95)
        let current = Int.random(in: minValue...maxValue)
        
        // 计算进度
        let progress = Double(current) / Double(target)
        
        // 保存数据
        SharedDataManager.shared.saveProgressData(
            title: title,
            progress: progress,
            current: current,
            target: target,
            unit: unit
        )
        
        // 刷新 Widget
        WidgetCenter.shared.reloadTimelines(ofKind: "CircularProgressWidget")
        
        // 显示状态
        showStatus("✅ 已生成随机进度数据\n\(title): \(current)/\(target) \(unit) (\(Int(progress * 100))%)", isError: false)
    }
    
    // MARK: - 辅助方法
    
    private func updateCounterDisplay() {
        let count = SharedDataManager.shared.getCounter()
        counterLabel.text = "计数: \(count)"
    }
    
    private func generateStockDataForRandom() -> [[String: Any]] {
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
            
            currentPrice = basePrice + trend + volatility + shortCycle + longCycle + spike + momentum + jump
            currentPrice = max(basePrice - 25, min(basePrice + 25, currentPrice))  // 范围从±15增加到±25
            
            prices.append(currentPrice)
        }
        
        // 轻度平滑处理（保留更多波动）
        var smoothedPrices: [Double] = []
        for i in 0..<prices.count {
            if i == 0 || i == prices.count - 1 {
                smoothedPrices.append(prices[i])
            } else {
                let smoothed = prices[i] * 0.7 + prices[i-1] * 0.15 + prices[i+1] * 0.15  // 从60%增加到70%，保留更多原始波动
                smoothedPrices.append(smoothed)
            }
        }
        
        return times.enumerated().map { index, time in
            return [
                "time": time,
                "price": smoothedPrices[index]
            ] as [String : Any]
        }
    }
    
    private func showStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
        
        // 3秒后清除状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.statusLabel.text = ""
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default))
        present(alert, animated: true)
    }
}

