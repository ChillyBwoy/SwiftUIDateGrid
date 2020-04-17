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

@available(iOS 13.0, macOS 10.15, *)
enum Theme: String, Codable, CaseIterable {
  case red
  case orange
  case yellow
  case green
  case blue
  case indigo
  case violet
  case cyan
  case monochrome

  static func random() -> Theme {
    let themeName = Theme.allCases.randomElement()!
    return themeName
  }

  func style() -> Style {
    switch self {
    case .red:
      return Style(
        bgColor: .red,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.red, .pink, .red]),
        textColor: .red
      )

    case .orange:
      return Style(
        bgColor: .orange,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.orange, .red, .orange]),
        textColor: .orange
      )

    case .yellow:
      return Style(
        bgColor: .yellow,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.yellow, .red, .yellow]),
        textColor: .yellow
      )

    case .green:
      return Style(
        bgColor: .green,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.green, .blue, .green]),
        textColor: .green
      )

    case .blue:
      return Style(
        bgColor: .blue,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.blue, .green, .blue]),
        textColor: .blue
      )

    case .indigo:
      return Style(
        bgColor: Color(hue: 0.75, saturation: 1.0, brightness: 0.25),
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.blue, .orange, .blue]),
        textColor: Color(hue: 0.75, saturation: 1.0, brightness: 0.25)
      )

    case .violet:
      return Style(
        bgColor: .purple,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.blue, .purple, .blue]),
        textColor: .purple
      )

    case .cyan:
      return Style(
        bgColor: Color(hue: 0.5, saturation: 1.0, brightness: 0.5),
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.orange, .blue, .orange]),
        textColor: Color(hue: 0.5, saturation: 1.0, brightness: 0.5)
      )

    case .monochrome:
      return Style(
        bgColor: .black,
        bgTextColor: .white,
        bgGradient: Gradient(colors: [.black, .white]),
        textColor: .black
      )
    }
  }

  struct Style {
    let bgColor: Color
    let bgTextColor: Color
    let bgGradient: Gradient
    let textColor: Color
  }
}

#endif
