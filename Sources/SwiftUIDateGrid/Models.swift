import Combine
import SwiftUI

public struct DateGridDay {
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

public struct DateGridStyle {
  var background: Color
  var foregroundColor: Color
}
