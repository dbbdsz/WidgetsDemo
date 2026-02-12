//
//  WidgetsExampleBundle.swift
//  WidgetsExample
//
//  Created by admin on 2026/2/11.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsExampleBundle: WidgetBundle {
    var body: some Widget {
        WidgetsExample()
        StockChartWidget()
        CircularProgressWidget()
        BarChartWidget()
        ClockWidget()
    }
}
