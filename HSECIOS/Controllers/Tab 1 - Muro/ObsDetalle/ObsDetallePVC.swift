import UIKit

class ObsDetallePVC: UIPageViewController, UIPageViewControllerDataSource {
    
    //var temp = 0
    
    // var padre = ObsDetalleVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setViewControllers([Tabs.forObsDetalle[Tabs.indexObsDetalle]], direction: .forward, animated: true, completion: nil)
        // self.padre = self.parent as! ObsDetalleVC
        //(self.parent as! ObsDetalleVC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return Tabs.getNextVCFor(viewController, forward: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return Tabs.getNextVCFor(viewController, forward: true)
    }
}
