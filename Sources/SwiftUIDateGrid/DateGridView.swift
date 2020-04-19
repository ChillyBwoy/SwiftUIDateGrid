import SwiftUI

@available(iOS 13.0, *)
public struct DateGridView: View {
  @Binding public var date: Date
  @Binding public var selectedDates: [Date]
  var theme: DateGridTheme

  private let manager = DateGridManager()

  public init(
    date: Binding<Date>, selectedDates: Binding<[Date]>, theme: DateGridTheme = DateGridTheme()
  ) {
    self._date = date
    self._selectedDates = selectedDates
    self.theme = theme
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      DateGridViewController(
        manager: manager,
        date: $date,
        createViewController: {
          let rootView = DateGridMonthView(
            month: self.manager.month(for: self.date, selectedDates: self.selectedDates)
          ).environmentObject(self.theme)
          return UIHostingController(rootView: rootView)
        }
      )
    }
  }
}

struct DateGridView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewWrapper()
  }

  struct PreviewWrapper: View {
    @State(initialValue:Date()) var date: Date

    var body: some View {
      let calendar = Calendar.current
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
        date: $date,
        selectedDates: .constant(selectedDates)
      )
    }
  }
}
