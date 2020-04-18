import SwiftUI

public class DateGridTheme: ObservableObject {
  var today: DateGridStyle = DateGridStyle(
    background: Color(UIColor.systemBlue),
    foregroundColor: .white)

  var day: DateGridStyle = DateGridStyle(
    background: .clear,
    foregroundColor: .accentColor)

  var selected: DateGridStyle = DateGridStyle(
    background: Color(UIColor.systemBlue),
    foregroundColor: .accentColor)

  var weekend: DateGridStyle = DateGridStyle(
    background: .clear,
    foregroundColor: Color(UIColor.systemRed)
  )
}
