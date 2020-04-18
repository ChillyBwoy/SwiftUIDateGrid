import SwiftUI

struct DateGridMonthView: View {
  var month: DateGridMonth

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      DateGridHeadView(date: month.date)
        .padding(.bottom, 30)

      ForEach(month.weeks, id: \.weekOfYear) { week in
        HStack(alignment: .center, spacing: 10) {
          ForEach(week.days, id: \.num) { day in
            DateGridDayView(day: day)
          }
        }
        .padding(0)
      }
    }
    .padding(0)
  }
}

struct CalendarMonthView_Previews: PreviewProvider {
  static var previews: some View {
    DateGridMonthView(
      month: DateGridManager().month(for: Date())
    ).environment(\.locale, Locale(identifier: "ru_RU"))
  }
}
