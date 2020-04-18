//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//
#if os(iOS)
  import SwiftUI

  @available(iOS 13.0, *)
  struct DateGridWeekDaysView: View {
    @Environment(\.calendar) var calendar

    private var weekdaySymbols: [String] {
      extractWeekdaySymbols(from: calendar.weekdaySymbols)
    }

    private var shortWeekdaySymbols: [String] {
      extractWeekdaySymbols(from: calendar.shortWeekdaySymbols)
    }

    private func extractWeekdaySymbols(from symbols: [String]) -> [String] {
      let rangeLeft = calendar.firstWeekday - 1..<symbols.count
      let rangeRight = 0..<calendar.firstWeekday - 1

      return Array(symbols[rangeLeft] + symbols[rangeRight])
    }

    var body: some View {
      HStack(spacing: 0) {
        ForEach(shortWeekdaySymbols, id: \.self) { label in
          Text(label)
            .bold()
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              alignment: .center
            )
        }
      }
      .padding(0)
    }
  }

  struct DateGridWeekDaysView_Previews: PreviewProvider {
    static var previews: some View {
      DateGridWeekDaysView()
    }
  }
#endif
