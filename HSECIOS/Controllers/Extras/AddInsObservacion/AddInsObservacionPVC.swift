import UIKit

class AddInsObservacionPVC: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setViewControllers([Tabs.forAddInsObs[Tabs.indexAddInsObs]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return Tabs.getNextVCFor(viewController, forward: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return Tabs.getNextVCFor(viewController, forward: true)
    }
}
