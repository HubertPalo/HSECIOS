import UIKit

class UpsertObsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    var oldSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       Utils.setTitleAndImage(self, "Nueva Observación", Images.observacion)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func focusScroll() {
        let height = tabs.frame.height
        let width = tabs.frame.width
        let singleTabWidth = width/CGFloat(tabs.numberOfSegments)
        let rect = CGRect.init(
            x: singleTabWidth*CGFloat(tabs.selectedSegmentIndex),
            y: CGFloat(0),
            width: singleTabWidth,
            height: height)
        tabsScroll.scrollRectToVisible(rect, animated: true)
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! UpsertObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forAddObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func ClickTopIzq(_ sender: Any) {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        } else {
            Utils.openMenuTab()
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        print((Tabs.forAddObs[0] as! UpsertObsPVCTab1).getData())
        print((Tabs.forAddObs[1] as! UpsertObsPVCTab2).getData())
        print("--------")
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! UpsertObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forAddObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
}
