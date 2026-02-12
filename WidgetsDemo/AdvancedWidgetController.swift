//
//  AdvancedWidgetController.swift
//  WidgetsDemo
//
//  Created by admin on 2026/2/11.
//

import UIKit
import WidgetKit

// MARK: - 高级 Widget 控制器
class AdvancedWidgetController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    
    // 股票 Widget 控制
    private let stockSectionLabel = UILabel()
    private let stockNameField = UITextField()
    private let stockPriceField = UITextField()
    private let stockChangeField = UITextField()
    private let updateStockButton = UIButton(type: .system)
    
    // 进度 Widget 控制
    private let progressSectionLabel = UILabel()
    private let progressTitleField = UITextField()
    private let progressCurrentField = UITextField()
    private let progressTargetField = UITextField()
    private let progressUnitField = UITextField()
    private let updateProgressButton = UIButton(type: .system)
    
    // 柱状图 Widget 控制
    private let barChartSectionLabel = UILabel()
    private let barChartTitleField = UITextField()
    private let generateRandomDataButton = UIButton(type: .system)
    private let updateBarChartButton = UIButton(type: .system)
    
    // 状态标签
    private let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCurrentData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "高级 Widget 控制"
        
        // 设置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 标题
        titleLabel.text = "📊 高级 Widget 控制面板"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        // 股票部分
        setupStockSection()
        
        // 进度部分
        setupProgressSection()
        
        // 柱状图部分
        setupBarChartSection()
        
        // 状态标签
        statusLabel.text = ""
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        
        // 添加所有子视图
        [titleLabel, stockSectionLabel, stockNameField, stockPriceField, stockChangeField, updateStockButton,
         progressSectionLabel, progressTitleField, progressCurrentField, progressTargetField, progressUnitField, updateProgressButton,
         barChartSectionLabel, barChartTitleField, generateRandomDataButton, updateBarChartButton,
         statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupStockSection() {
        stockSectionLabel.text = "📈 股票折线图 Widget"
        stockSectionLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        stockNameField.placeholder = "股票代码 (如: AAPL)"
        stockNameField.borderStyle = .roundedRect
        
        stockPriceField.placeholder = "当前价格 (如: 178.50)"
        stockPriceField.borderStyle = .roundedRect
        stockPriceField.keyboardType = .decimalPad
        
        stockChangeField.placeholder = "涨跌额 (如: 2.35 或 -1.20)"
        stockChangeField.borderStyle = .roundedRect
        stockChangeField.keyboardType = .numbersAndPunctuation
        
        updateStockButton.setTitle("📤 更新股票 Widget", for: .normal)
        updateStockButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        updateStockButton.backgroundColor = .systemGreen
        updateStockButton.setTitleColor(.white, for: .normal)
        updateStockButton.layer.cornerRadius = 10
        updateStockButton.addTarget(self, action: #selector(updateStockWidget), for: .touchUpInside)
    }
    
    private func setupProgressSection() {
        progressSectionLabel.text = "⭕ 圆形进度 Widget"
        progressSectionLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        progressTitleField.placeholder = "标题 (如: 今日步数)"
        progressTitleField.borderStyle = .roundedRect
        
        progressCurrentField.placeholder = "当前值 (如: 6500)"
        progressCurrentField.borderStyle = .roundedRect
        progressCurrentField.keyboardType = .numberPad
        
        progressTargetField.placeholder = "目标值 (如: 10000)"
        progressTargetField.borderStyle = .roundedRect
        progressTargetField.keyboardType = .numberPad
        
        progressUnitField.placeholder = "单位 (如: 步)"
        progressUnitField.borderStyle = .roundedRect
        
        updateProgressButton.setTitle("📤 更新进度 Widget", for: .normal)
        updateProgressButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        updateProgressButton.backgroundColor = .systemBlue
        updateProgressButton.setTitleColor(.white, for: .normal)
        updateProgressButton.layer.cornerRadius = 10
        updateProgressButton.addTarget(self, action: #selector(updateProgressWidget), for: .touchUpInside)
    }
    
    private func setupBarChartSection() {
        barChartSectionLabel.text = "📊 柱状图 Widget"
        barChartSectionLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        barChartTitleField.placeholder = "标题 (如: 本周活动)"
        barChartTitleField.borderStyle = .roundedRect
        
        generateRandomDataButton.setTitle("🎲 生成随机数据", for: .normal)
        generateRandomDataButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        generateRandomDataButton.backgroundColor = .systemOrange
        generateRandomDataButton.setTitleColor(.white, for: .normal)
        generateRandomDataButton.layer.cornerRadius = 10
        generateRandomDataButton.addTarget(self, action: #selector(generateRandomBarData), for: .touchUpInside)
        
        updateBarChartButton.setTitle("📤 更新柱状图 Widget", for: .normal)
        updateBarChartButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        updateBarChartButton.backgroundColor = .systemPurple
        updateBarChartButton.setTitleColor(.white, for: .normal)
        updateBarChartButton.layer.cornerRadius = 10
        updateBarChartButton.addTarget(self, action: #selector(updateBarChartWidget), for: .touchUpInside)
    }
    
    private func setupConstraints() {
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
            
            // 股票部分
            stockSectionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            stockSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stockSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stockNameField.topAnchor.constraint(equalTo: stockSectionLabel.bottomAnchor, constant: 12),
            stockNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stockNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stockNameField.heightAnchor.constraint(equalToConstant: 44),
            
            stockPriceField.topAnchor.constraint(equalTo: stockNameField.bottomAnchor, constant: 8),
            stockPriceField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stockPriceField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stockPriceField.heightAnchor.constraint(equalToConstant: 44),
            
            stockChangeField.topAnchor.constraint(equalTo: stockPriceField.bottomAnchor, constant: 8),
            stockChangeField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stockChangeField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stockChangeField.heightAnchor.constraint(equalToConstant: 44),
            
            updateStockButton.topAnchor.constraint(equalTo: stockChangeField.bottomAnchor, constant: 12),
            updateStockButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            updateStockButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            updateStockButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 进度部分
            progressSectionLabel.topAnchor.constraint(equalTo: updateStockButton.bottomAnchor, constant: 30),
            progressSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            progressTitleField.topAnchor.constraint(equalTo: progressSectionLabel.bottomAnchor, constant: 12),
            progressTitleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressTitleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressTitleField.heightAnchor.constraint(equalToConstant: 44),
            
            progressCurrentField.topAnchor.constraint(equalTo: progressTitleField.bottomAnchor, constant: 8),
            progressCurrentField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressCurrentField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressCurrentField.heightAnchor.constraint(equalToConstant: 44),
            
            progressTargetField.topAnchor.constraint(equalTo: progressCurrentField.bottomAnchor, constant: 8),
            progressTargetField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressTargetField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressTargetField.heightAnchor.constraint(equalToConstant: 44),
            
            progressUnitField.topAnchor.constraint(equalTo: progressTargetField.bottomAnchor, constant: 8),
            progressUnitField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressUnitField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressUnitField.heightAnchor.constraint(equalToConstant: 44),
            
            updateProgressButton.topAnchor.constraint(equalTo: progressUnitField.bottomAnchor, constant: 12),
            updateProgressButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            updateProgressButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            updateProgressButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 柱状图部分
            barChartSectionLabel.topAnchor.constraint(equalTo: updateProgressButton.bottomAnchor, constant: 30),
            barChartSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            barChartSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            barChartTitleField.topAnchor.constraint(equalTo: barChartSectionLabel.bottomAnchor, constant: 12),
            barChartTitleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            barChartTitleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            barChartTitleField.heightAnchor.constraint(equalToConstant: 44),
            
            generateRandomDataButton.topAnchor.constraint(equalTo: barChartTitleField.bottomAnchor, constant: 12),
            generateRandomDataButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generateRandomDataButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            generateRandomDataButton.heightAnchor.constraint(equalToConstant: 50),
            
            updateBarChartButton.topAnchor.constraint(equalTo: generateRandomDataButton.bottomAnchor, constant: 8),
            updateBarChartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            updateBarChartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            updateBarChartButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.topAnchor.constraint(equalTo: updateBarChartButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 数据加载
    
    private func loadCurrentData() {
        stockNameField.text = SharedDataManager.shared.getStockName()
        stockPriceField.text = String(format: "%.2f", SharedDataManager.shared.getStockPrice())
        stockChangeField.text = String(format: "%.2f", SharedDataManager.shared.getStockChange())
        
        progressTitleField.text = SharedDataManager.shared.getProgressTitle()
        progressCurrentField.text = "\(SharedDataManager.shared.getCurrentValue())"
        progressTargetField.text = "\(SharedDataManager.shared.getTargetValue())"
        progressUnitField.text = SharedDataManager.shared.getProgressUnit()
        
        barChartTitleField.text = SharedDataManager.shared.getBarChartTitle()
    }
    
    // MARK: - 按钮事件
    
    @objc private func updateStockWidget() {
        guard let name = stockNameField.text, !name.isEmpty,
              let priceText = stockPriceField.text, let price = Double(priceText),
              let changeText = stockChangeField.text, let change = Double(changeText) else {
            showStatus("请填写完整的股票信息", isError: true)
            return
        }
        
        // 生成模拟股票数据
        let stockData = generateStockData(basePrice: price, change: change)
        
        SharedDataManager.shared.saveStockData(name: name, price: price, change: change, data: stockData)
        WidgetCenter.shared.reloadTimelines(ofKind: "StockChartWidget")
        
        showStatus("✅ 股票 Widget 已更新", isError: false)
        view.endEditing(true)
    }
    
    @objc private func updateProgressWidget() {
        guard let title = progressTitleField.text, !title.isEmpty,
              let currentText = progressCurrentField.text, let current = Int(currentText),
              let targetText = progressTargetField.text, let target = Int(targetText),
              let unit = progressUnitField.text, !unit.isEmpty else {
            showStatus("请填写完整的进度信息", isError: true)
            return
        }
        
        let progress = Double(current) / Double(target)
        
        SharedDataManager.shared.saveProgressData(title: title, progress: progress, current: current, target: target, unit: unit)
        WidgetCenter.shared.reloadTimelines(ofKind: "CircularProgressWidget")
        
        showStatus("✅ 进度 Widget 已更新", isError: false)
        view.endEditing(true)
    }
    
    @objc private func generateRandomBarData() {
        let days = ["一", "二", "三", "四", "五", "六", "日"]
        let colors = ["blue", "green", "orange", "purple", "pink", "red", "cyan"]
        
        let data = days.enumerated().map { index, day in
            return [
                "label": day,
                "value": Double.random(in: 30...100),
                "color": colors[index]
            ] as [String : Any]
        }
        
        let title = barChartTitleField.text ?? "本周活动"
        SharedDataManager.shared.saveBarChartData(title: title, data: data, maxValue: 100)
        
        showStatus("✅ 已生成随机柱状图数据", isError: false)
    }
    
    @objc private func updateBarChartWidget() {
        let title = barChartTitleField.text ?? "本周活动"
        
        // 如果没有数据，先生成
        let currentData = SharedDataManager.shared.getBarChartData()
        if currentData.isEmpty {
            generateRandomBarData()
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "BarChartWidget")
        
        showStatus("✅ 柱状图 Widget 已更新", isError: false)
        view.endEditing(true)
    }
    
    // MARK: - 辅助方法
    
    private func generateStockData(basePrice: Double, change: Double) -> [[String: Any]] {
        let times = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00"]
        
        // 生成超级波折的价格数据
        var prices: [Double] = []
        var currentPrice = basePrice
        
        for index in 0..<times.count {
            // 1. 整体趋势（更大幅度）
            let trendDirection = sin(Double(index) * 0.5)
            let trend = trendDirection * (change * 0.5)  // 增加趋势影响
            
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
            ]
        }
    }
    
    private func showStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.statusLabel.text = ""
        }
    }
}
