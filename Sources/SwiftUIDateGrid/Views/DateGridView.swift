//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//
#if os(iOS)
import SwiftUI

@available(iOS 13.0, *)
struct DateGridView: View {
  @State var date: Date
  @State var selectedDates: [Date]
  var theme: Theme
  var onSelect: DateGridOnDateSelect
  var manager = DateGridManager()

  var body: some View {
    ZStack(alignment: .topLeading) {
      DateGridViewController(
        manager: manager,
        date: $date,
        createViewController: { date in
          let rootView = DateGridMonthView(
            month: self.manager.month(for: date, selectedDates: self.selectedDates),
            theme: self.theme,
            onSelect: self.onSelect
          )
          return UIHostingController(rootView: rootView)
        }
      )
    }
  }
}


@available(iOS 13.0, *)
struct CalendarView_Previews: PreviewProvider {
  static var previews: some View {
    let calendar = Calendar.current
    let date = Date()
    let selectedDates: [Date] = [
      calendar.date(byAdding: .day, value: 3, to: date)!,
      calendar.date(byAdding: .day, value: 1, to: date)!,
      calendar.date(byAdding: .day, value: -1, to: date)!,
      calendar.date(byAdding: .day, value: -3, to: date)!,
      calendar.date(byAdding: .day, value: -3, to: date)!,
      calendar.date(byAdding: .day, value: -5, to: date)!,
      calendar.date(byAdding: .day, value: -5, to: date)!,
      calendar.date(byAdding: .day, value: -5, to: date)!,
      calendar.date(byAdding: .day, value: -5, to: date)!,
    ]

    return DateGridView(
      date: Date(),
      selectedDates: selectedDates,
      theme: Theme.orange,
      onSelect: { day in
        print(day)
      }
    )
  }
}

#endif
