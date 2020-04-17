//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//
#if os(iOS)
import SwiftUI

@available(iOS 13.0, *)
struct DateGridMonthView: View {
  var month: DateGridMonth
  var theme: Theme
  var onSelect: DateGridOnDateSelect

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      DateGridHeadView(date: month.date)
        .padding(.bottom, 30)

      ForEach(month.weeks, id: \.weekOfYear) { week in
        HStack(alignment: .center, spacing: 10) {
          ForEach(week.days, id: \.num) { day in
            DateGridDayView(
              day: day,
              theme: self.theme,
              onSelect: self.onSelect
            )
          }
        }
        .padding(0)
      }
    }
    .padding(0)
  }
}

@available(iOS 13.0, *)
struct CalendarMonthView_Previews: PreviewProvider {
  static var previews: some View {
    DateGridMonthView(
      month: DateGridManager().month(for: Date()),
      theme: Theme.orange,
      onSelect: { day in
        print(day)
      }
    ).environment(\.locale, Locale(identifier: "ru_RU"))
  }
}
#endif
