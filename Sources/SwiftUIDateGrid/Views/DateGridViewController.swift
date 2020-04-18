//
//  File.swift
//  
//
//  Created by Eugene Cheltsov on 18.04.2020.
//

import SwiftUI

#if os(iOS)
  @available(iOS 13.0, *)
  struct DateGridViewController: UIViewControllerRepresentable {
    var manager: DateGridManager
    @Binding var date: Date
    var createViewController: (_ date: Date) -> UIViewController

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
      var parent: DateGridViewController

      init(_ pageViewController: DateGridViewController) {
        parent = pageViewController
      }

      func pageViewController(_: UIPageViewController, viewControllerBefore _: UIViewController)
        -> UIViewController?
      {
        let prevDate = parent.manager.calendar.date(
          byAdding: .month, value: -1, to: parent.date)!
        return parent.createViewController(prevDate)
      }

      func pageViewController(_: UIPageViewController, viewControllerAfter _: UIViewController)
        -> UIViewController?
      {
        let nextDate = parent.manager.calendar.date(
          byAdding: .month, value: 1, to: parent.date)!
        return parent.createViewController(nextDate)
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

    func makeCoordinator() -> DateGridViewController.Coordinator {
      Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
      let vc = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
      )

      vc.dataSource = context.coordinator
      vc.delegate = context.coordinator

      return vc
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context _: Context) {
      let firstViewController = pageViewController.viewControllers?.first

      let viewController =
        firstViewController != nil ? firstViewController! : createViewController(date)

      pageViewController.setViewControllers(
        [viewController],
        direction: .forward,
        animated: true
      )
    }
  }
#endif
