//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//

#if os(iOS)
  import Combine
  import SwiftUI

  struct DateGridDay {
    let num: Int
    let date: Date
    let isToday: Bool
    let isWeekend: Bool
    let isCurrentMonth: Bool
    let matchedDates: Int
  }

  struct DateGridWeek {
    let weekOfYear: Int
    let days: [DateGridDay]
  }

  struct DateGridMonth {
    let date: Date
    let weeks: [DateGridWeek]
  }

  struct DateGridStyle {
    let bgColor: Color
    let bgTextColor: Color
    let bgGradient: Gradient
    let textColor: Color
  }
#endif
