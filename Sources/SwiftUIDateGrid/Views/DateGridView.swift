#if os(iOS)
  import SwiftUI

  @available(iOS 13.0, *)
  public struct DateGridView: View {
    @State var date: Date
    @State var selectedDates: [Date]
    var style: DateGridStyle
    var onSelect: DateGridOnDateSelect
    var manager = DateGridManager()

    public var body: some View {
      ZStack(alignment: .topLeading) {
        DateGridViewController(
          manager: manager,
          date: $date,
          createViewController: { date in
            let rootView = DateGridMonthView(
              month: self.manager.month(for: date, selectedDates: self.selectedDates),
              style: self.style,
              onSelect: self.onSelect
            )
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
        calendar.date(byAdding: .day, value: -5, to: date)!,
      ]

      return DateGridView(
        date: Date(),
        selectedDates: selectedDates,
        style: DateGridStyle(
          bgColor: .orange,
          bgTextColor: .white,
          bgGradient: Gradient(colors: [.orange, .red, .orange]),
          textColor: .orange
        ),
        onSelect: { day in
          print(day)
        }
      )
    }
  }
#endif
