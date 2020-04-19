import SwiftUI

public struct DateGridDayStyle {
  public var background: Color
  public var foregroundColor: Color

  public init(background: Color, foregroundColor: Color) {
    self.background = background
    self.foregroundColor = foregroundColor
  }
}

public class DateGridTheme: ObservableObject {
  public var today: DateGridDayStyle = DateGridDayStyle(
    background: Color(UIColor.systemBlue),
    foregroundColor: .white)

  public var day: DateGridDayStyle = DateGridDayStyle(
    background: .clear,
    foregroundColor: .accentColor)

  public var selected: DateGridDayStyle = DateGridDayStyle(
    background: Color(UIColor.systemBlue),
    foregroundColor: .accentColor)

  public var weekend: DateGridDayStyle = DateGridDayStyle(
    background: .clear,
    foregroundColor: Color(UIColor.systemRed))

  public var inactive: DateGridDayStyle = DateGridDayStyle(
    background: .clear,
    foregroundColor: Color(UIColor.systemGray))

  public init() {}
}
