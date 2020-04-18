#if os(iOS)
  import SwiftUI

  @available(iOS 13.0, *)
  struct DateGridHeadView: View {
    var date: Date

    private let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "LLLL YYYY"
      return formatter
    }()

    var body: some View {
      HStack(alignment: .center) {
        Spacer()

        Text("\(date, formatter: dateFormatter)")
          .font(.system(.title))
          .frame(alignment: .center)
        Spacer()
      }
    }
  }

  struct DateGridHeadView_Previews: PreviewProvider {
    static var previews: some View {
      DateGridHeadView(date: Date())
    }
  }
#endif
