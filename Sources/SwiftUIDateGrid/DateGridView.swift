import SwiftUI

@available(iOS 13.0, *)
public struct DateGridView: View {
  @Binding public var date: Date
  @Binding public var selectedDates: [Date]
  var theme: DateGridTheme = DateGridTheme()

  private let manager = DateGridManager()

  public var body: some View {
    ZStack(alignment: .topLeading) {
      DateGridViewController(
        manager: manager,
        date: $date,
        createViewController: { date in
          let rootView = DateGridMonthView(
            month: self.manager.month(for: date, selectedDates: self.selectedDates)
          ).environmentObject(self.theme)
          return UIHostingController(rootView: rootView)
        }
      )
    }
  }
}

struct DateGridView_Previews: PreviewProvider {
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
    ]

    return DateGridView(
      date: .constant(Date()),
      selectedDates: .constant(selectedDates)
    )
  }
}
