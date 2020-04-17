//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//

#if os(iOS)
import SwiftUI

typealias DateGridOnDateSelect = (_ day: DateGridDay) -> Void

@available(iOS 13.0, *)
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

@available(iOS 13.0, *)
struct DateGridDayView: View {
  var day: DateGridDay
  var theme: Theme
  var onSelect: DateGridOnDateSelect

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
  }()

  private var label: Text {
    Text("\(day.date, formatter: dateFormatter)")
  }

  private var dayView: some View {
    let style = theme.style()

    return ZStack(alignment: .bottom) {
      if self.day.isToday {
        label
          .fontWeight(.heavy)
          .foregroundColor(style.bgTextColor)
          .modifier(DateGridDayPosition())
          .background(Circle().fill(style.bgColor))
      } else if self.day.matchedDates > 0 {
        label
          .modifier(DateGridDayPosition())
        HStack(alignment: .center, spacing: 2) {
          ForEach(1...self.day.matchedDates, id: \.self) { _ in
            Circle()
              .fill(style.bgColor)
              .frame(width: 5, height: 5, alignment: .center)
          }
        }
      } else if !self.day.isCurrentMonth {
        label
          .foregroundColor(Color.gray)
          .modifier(DateGridDayPosition())
      } else if self.day.isWeekend {
        label
          .foregroundColor(Color.red)
          .modifier(DateGridDayPosition())
      } else {
        label
          .modifier(DateGridDayPosition())
      }
    }
  }

  var body: some View {
    Button(action: {
      self.onSelect(self.day)
    }) {
      dayView.padding(2)
    }
    .foregroundColor(.primary)
  }
}

@available(iOS 13.0, *)
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
        ),
        theme: Theme.orange,
        onSelect: { day in
          print(day)
        }
      )
      DateGridDayView(
        day: DateGridDay(
          num: dayNum.day!,
          date: date,
          isToday: true,
          isWeekend: false,
          isCurrentMonth: true,
          matchedDates: 0
        ),
        theme: Theme.orange,
        onSelect: { day in
          print(day)
        }
      )
      DateGridDayView(
        day: DateGridDay(
          num: dayNum.day!,
          date: date,
          isToday: false,
          isWeekend: false,
          isCurrentMonth: false,
          matchedDates: 3
        ),
        theme: Theme.orange,
        onSelect: { day in
          print(day)
        }
      )
    }
    .padding(20)
    .previewLayout(.fixed(width: 75, height: 75))
  }
}

#endif
