import SwiftUI

fileprivate enum DateGridViewControllerDirection: Int {
  case after = 1
  case before = -1
}

fileprivate class DateGridViewControllerCache {
  var createViewController: (_ date: Date) -> UIViewController

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    return dateFormatter
  }()

  private var data: [String: UIViewController] = [:]

  private func getCacheKey(for date: Date) -> String {
    return dateFormatter.string(from: date)
  }
  
  init(createViewController: @escaping (_ date: Date) -> UIViewController) {
    self.createViewController = createViewController
  }

  func controller(for date: Date) -> UIViewController {
    let key = getCacheKey(for: date)
    if let viewController = data[key] {
      return viewController
    }

    let newViewController = createViewController(date)
    data[key] = newViewController

    return newViewController
  }
}

struct DateGridViewController: UIViewControllerRepresentable {
  var manager: DateGridManager
  @Binding var date: Date
  private let cache: DateGridViewControllerCache
  
  init(manager: DateGridManager, date: Binding<Date>, createViewController: @escaping (_ date: Date) -> UIViewController) {
    self.manager = manager
    self._date = date
    self.cache = DateGridViewControllerCache(createViewController: createViewController)
  }

  func makeCoordinator() -> DateGridViewController.Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIPageViewController {
    let viewController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal)

    viewController.dataSource = context.coordinator
    viewController.delegate = context.coordinator

    return viewController
  }

  func updateUIViewController(_ pageViewController: UIPageViewController, context _: Context) {
    let firstViewController = pageViewController.viewControllers?.first
    let viewController = firstViewController != nil
      ? firstViewController!
      : cache.controller(for: date)

    pageViewController.setViewControllers(
      [viewController],
      direction: .forward,
      animated: true)
  }

  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var parent: DateGridViewController

    init(_ pageViewController: DateGridViewController) {
      parent = pageViewController
    }

    fileprivate func getViewController(direction: DateGridViewControllerDirection) -> UIViewController {
      let calendar = parent.manager.calendar
      let newDate = calendar.date(byAdding: .month, value: direction.rawValue, to: parent.date)!
      return parent.cache.controller(for: newDate)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      return getViewController(direction: .before)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      return getViewController(direction: .after)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      if completed {
        guard let prevController = previousViewControllers.first as? UIHostingController<DateGridMonthView> else {
          return
        }

        guard let currController = pageViewController.viewControllers?.first as? UIHostingController<DateGridMonthView> else {
          return
        }

        let prev = prevController.rootView.month
        let curr = currController.rootView.month

        let calendar = parent.manager.calendar

        let components1 = calendar.dateComponents([.year, .month], from: curr.date)
        let components2 = calendar.dateComponents([.year, .month], from: prev.date)

        let firstDate1 = calendar.date(from: components1)!
        let firstDate2 = calendar.date(from: components2)!

        if firstDate1 > firstDate2 {
          parent.date = calendar.date(byAdding: .month, value: 1, to: parent.date)!
        } else if firstDate1 < firstDate2 {
          parent.date = calendar.date(byAdding: .month, value: -1, to: parent.date)!
        }
      }
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//      let itemController = pendingViewControllers.first
//    }
  }
}
