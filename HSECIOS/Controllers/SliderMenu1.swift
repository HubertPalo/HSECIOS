import UIKit

class SliderMenu1: UIPageViewController, UIPageViewControllerDataSource {
    
    var index = 0
    override func viewDidLoad() {
        self.dataSource = self
        setViewControllers([Tabs.forTest[index]], direction: .forward , animated: true, completion: nil)
    }
    
    func getId(_ vc: UIViewController) -> Int{
        if vc as? Tab1VC != nil {
            return 0
        }
        if vc as? Tab2VC != nil {
            return 1
        }
        if vc as? Tab3VC != nil {
            return 2
        }
        if vc as? Tab4VC != nil {
            return 3
        }
        return -1
    }
    
    func presentViewAt(_ index: Int) {
        self.setViewControllers([Tabs.forTest[index]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(index)
        index = getId(viewController)
        if index > 0 {
            return Tabs.forTest[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(index)
        index = getId(viewController)
        if index < 3 {
            return Tabs.forTest[index + 1]
        }
        return nil
    }
}
