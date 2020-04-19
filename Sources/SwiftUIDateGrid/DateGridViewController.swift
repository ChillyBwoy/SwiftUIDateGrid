import SwiftUI

fileprivate enum DateGridViewControllerDirection: Int {
  case up = 1
  case down = -1
}

fileprivate class DateGridViewControllerCache {
  private let dateFormatterForCacheKey: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    return dateFormatter
  }()

  private var data: [String: UIViewController] = [:]

  private func getCacheKey(for date: Date) -> String {
    return dateFormatterForCacheKey.string(from: date)
  }

  func controller(for date: Date, createController: @escaping () -> UIViewController)
    -> UIViewController
  {
    let key = getCacheKey(for: date)
    if let controller = data[key] {
      return controller
    }

    let newController = createController()
    data[key] = newController
    return newController
  }
}

struct DateGridViewController: UIViewControllerRepresentable {
  var manager: DateGridManager
  @Binding var date: Date
  var createViewController: () -> UIViewController

  private let cache = DateGridViewControllerCache()

  func makeCoordinator() -> DateGridViewController.Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal)

    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator

    return pageViewController
  }

  func updateUIViewController(_ pageViewController: UIPageViewController, context _: Context) {
    let firstViewController = pageViewController.viewControllers?.first

    let viewController =
      firstViewController != nil
      ? firstViewController!
      : createViewController()

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

    fileprivate func nextViewController(direction: DateGridViewControllerDirection)
      -> UIViewController
    {
      parent.date = parent.manager.calendar.date(
        byAdding: .month, value: direction.rawValue, to: parent.date)!
      return parent.cache.controller(
        for: parent.date, createController: parent.createViewController)
    }

    func pageViewController(_: UIPageViewController, viewControllerBefore _: UIViewController)
      -> UIViewController?
    {
      return nextViewController(direction: .down)
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter _: UIViewController)
      -> UIViewController?
    {
      return nextViewController(direction: .up)
    }

    func pageViewController(
      _ pageViewController: UIPageViewController, didFinishAnimating _: Bool,
      previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
      if completed {
        guard
          let prevController = previousViewControllers.first
            as? UIHostingController<DateGridMonthView>,
          let currController = pageViewController.viewControllers?.first
            as? UIHostingController<DateGridMonthView>
        else {
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
  }
}
