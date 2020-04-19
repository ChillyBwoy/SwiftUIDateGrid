import SwiftUI

fileprivate struct DateGridDayLabelWithCircle: ViewModifier {
  var style: DateGridDayStyle

  func body(content: Content) -> some View {
    content.background(Circle().fill(style.background))
  }
}

fileprivate struct DateGridDayLabelWithInfo: ViewModifier {
  @EnvironmentObject var theme: DateGridTheme
  var day: DateGridDay
  var style: DateGridDayStyle

  func body(content: Content) -> some View {
    ZStack(alignment: .bottom) {
      content
      HStack(alignment: .center, spacing: 2) {
        ForEach(1...day.matchedDates, id: \.self) { _ in
          Circle()
            .fill(self.style.background)
            .frame(width: 5, height: 5, alignment: .center)
        }
      }
    }
  }
}

fileprivate struct DateGridDayLabelView: View {
  var day: DateGridDay
  var style: DateGridDayStyle

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
  }()

  var body: some View {
    GeometryReader { geom in
      Text("\(self.day.date, formatter: self.dateFormatter)")
        .foregroundColor(self.style.foregroundColor)
        .frame(
          width: geom.size.width,
          height: geom.size.height,
          alignment: .center
        )
        .padding(2)
    }
  }
}

struct DateGridDayView: View {
  @EnvironmentObject var theme: DateGridTheme
  var day: DateGridDay

  var body: some View {
    Button(action: {
      debugPrint(self.day)
    }) {
      if self.day.isToday {
        DateGridDayLabelView(day: day, style: theme.today)
          .modifier(DateGridDayLabelWithCircle(style: theme.today))
      } else if self.day.matchedDates > 0 {
        DateGridDayLabelView(day: day, style: theme.selected)
          .modifier(DateGridDayLabelWithInfo(day: day, style: theme.selected))
      } else if !self.day.isCurrentMonth {
        DateGridDayLabelView(day: day, style: theme.inactive)
      } else if self.day.isWeekend {
        DateGridDayLabelView(day: day, style: theme.weekend)
      } else {
        DateGridDayLabelView(day: day, style: theme.day)
      }
    }
    .foregroundColor(.primary)
  }
}

struct DateGridDayView_Previews: PreviewProvider {
  static var previews: some View {
    let calendar = Calendar.current
    let date = calendar.date(
      from: DateComponents(calendar: calendar, year: 2019, month: 9, day: 18))!
    let dayNum = calendar.dateComponents([.day], from: date)

    return Group {
      DateGridDayView(
        day: DateGridDay(
          num: dayNum.day!,
          date: date,
          isToday: false,
          isWeekend: false,
          isCurrentMonth: true,
          matchedDates: 0
        )
      )
      DateGridDayView(
        day: DateGridDay(
          num: dayNum.day!,
          date: date,
          isToday: true,
          isWeekend: false,
          isCurrentMonth: true,
          matchedDates: 0
        )
      )
      DateGridDayView(
        day: DateGridDay(
          num: dayNum.day!,
          date: date,
          isToday: false,
          isWeekend: false,
          isCurrentMonth: false,
          matchedDates: 3
        )
      )
    }
    .padding(20)
    .previewLayout(.fixed(width: 75, height: 75))
    .environmentObject(DateGridTheme())
  }
}
