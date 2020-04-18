import SwiftUI

fileprivate struct DateGridDayPosition: ViewModifier {
  func body(content: Content) -> some View {
    GeometryReader { geom in
      content
        .frame(
          width: geom.size.width,
          height: geom.size.height,
          alignment: .center
        )
    }
  }
}

fileprivate struct DateGridDayLabelMarked: ViewModifier {
  var style: DateGridStyle

  func body(content: Content) -> some View {
    content
      .background(Circle().fill(style.background))
  }
  
}

fileprivate struct DateGridDayLabelView: View {
  var date: Date
  var style: DateGridStyle
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
  }()

  var body: some View {
    Text("\(date, formatter: dateFormatter)")
      .foregroundColor(style.foregroundColor)
      .modifier(DateGridDayPosition())
      .padding(2)
  }
}

struct DateGridDayView: View {
  @EnvironmentObject var theme: DateGridTheme
  var day: DateGridDay

  var body: some View {
    Button(action: {
      print(self.day)
    }) {
      if self.day.isToday {
        DateGridDayLabelView(date: day.date, style: theme.today)
          .modifier(DateGridDayLabelMarked(style: theme.today))
      } else if self.day.matchedDates > 0 {
        ZStack(alignment: .bottom) {
          DateGridDayLabelView(date: day.date, style: theme.selected)
          HStack(alignment: .center, spacing: 2) {
            ForEach(1...self.day.matchedDates, id: \.self) { _ in
              Circle()
                .fill(self.theme.selected.background)
                .frame(width: 5, height: 5, alignment: .center)
            }
          }
        }
      } else if !self.day.isCurrentMonth {
        DateGridDayLabelView(date: day.date, style: theme.day)
      } else if self.day.isWeekend {
        DateGridDayLabelView(date: day.date, style: theme.weekend)
      } else {
        DateGridDayLabelView(date: day.date, style: theme.day)
      }
    }
    .foregroundColor(.primary)
  }
}

struct DateGridDayView_Previews: PreviewProvider {
  static var previews: some View {
    let calendar = Calendar.current
    let date = calendar.date(from: DateComponents(calendar: calendar, year: 2019, month: 9, day: 18))!
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
