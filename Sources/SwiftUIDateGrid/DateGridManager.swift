import Combine
import SwiftUI

struct DateGridManager {
  var calendar: Calendar

  var weekdaySymbols: [String] {
    extractWeekdaySymbols(from: calendar.weekdaySymbols)
  }

  var shortWeekdaySymbols: [String] {
    extractWeekdaySymbols(from: calendar.shortWeekdaySymbols)
  }

  init(calendar: Calendar = Calendar.current) {
    self.calendar = calendar
  }

  fileprivate func extractWeekdaySymbols(from symbols: [String]) -> [String] {
    let rangeLeft = calendar.firstWeekday - 1..<symbols.count
    let rangeRight = 0..<calendar.firstWeekday - 1

    return Array(symbols[rangeLeft] + symbols[rangeRight])
  }

  fileprivate func isDateInCurrentMonth(checkDate: Date, date: Date) -> Bool {
    return calendar.isDate(checkDate, equalTo: date, toGranularity: .month)
  }

  fileprivate func selectedTimes(date: Date, selectedDates: [Date]) -> Int {
    let matched = selectedDates.filter { selectedDate -> Bool in
      self.calendar.isDate(date, equalTo: selectedDate, toGranularity: .day)
    }

    return matched.count
  }

  fileprivate func calendarDay(for day: Int, of date: Date, selectedDates: [Date]) -> DateGridDay {
    var dc = calendar.dateComponents([.year, .month], from: date)
    dc.calendar = calendar
    dc.day = day

    let currentDate = calendar.date(from: dc)!
    let dayNum = calendar.dateComponents([.day], from: currentDate)

    return DateGridDay(
      num: dayNum.day!,
      date: currentDate,
      isToday: calendar.isDateInToday(currentDate),
      isWeekend: calendar.isDateInWeekend(currentDate),
      isCurrentMonth: isDateInCurrentMonth(checkDate: currentDate, date: date),
      matchedDates: selectedTimes(date: currentDate, selectedDates: selectedDates)
    )
  }

  fileprivate func mapDays(from range: Range<Int>, for date: Date, selectedDates: [Date])
    -> [DateGridDay]
  {
    return range.map { day -> DateGridDay in
      self.calendarDay(for: day, of: date, selectedDates: selectedDates)
    }
  }

  fileprivate func monthRange(from date: Date) -> Range<Int> {
    let components = calendar.dateComponents([.year, .month], from: date)
    let firstDate = calendar.date(from: components)!

    let start = calendar.component(.weekday, from: firstDate) - calendar.firstWeekday - 1
    let finish = 42 - start

    return (-start..<finish)
  }
}

extension DateGridManager {
  func month(for date: Date, selectedDates: [Date] = []) -> DateGridMonth {
    let range = monthRange(from: date)
    let days = mapDays(from: range, for: date, selectedDates: selectedDates)
    let length = calendar.maximumRange(of: .weekday)!.count

    let weeks = stride(from: 0, to: days.count, by: length).map { d -> DateGridWeek in
      let days = Array(days[d..<min(d + length, days.count)])
      let dc = calendar.dateComponents([.weekOfYear], from: days[0].date)

      return DateGridWeek(weekOfYear: dc.weekOfYear!, days: days)
    }

    return DateGridMonth(date: date, weeks: weeks)
  }
}

extension DateGridManager {
  func year(for yearNum: Int, selectedDates: [Date] = []) -> DateGridYear {
    DateGridYear(year: yearNum, monthes: [])
  }
}
