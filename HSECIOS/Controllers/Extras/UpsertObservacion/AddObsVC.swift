import UIKit

class UpsertObservacionVC: UIViewController {
    
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
        let slider = self.childViewControllers[0] as! AddObsPVC
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
        print("--------")
        /*print(String.init(data: Dict.translateToJSON(["string1":"valor", "objeto":["subdata":"subvalor"], "array":[["arraysub1":"arraysub2"]]])!, encoding: String.Encoding.utf8))*/
        print(String.init(data: Dict.translateToJSON(TempClass())!, encoding: String.Encoding.utf8))
        print(String.init(data: Dict.translateToJSON((Tabs.forAddObs[0] as! AddObsPVCTab1).data)!, encoding: String.Encoding.utf8))
        print(String.init(data: Dict.translateToJSON((Tabs.forAddObs[1] as! AddObsPVCTab2).data)!, encoding: String.Encoding.utf8))
        print(String.init(data: Dict.translateToJSON((Tabs.forAddObs[3] as! AddObsPVCTab4).planes)!, encoding: String.Encoding.utf8))
        print("--------")
        // Rest.uploadMultimediaFor("OBF000000001", "TOBS", "1", (Tabs.forAddObs[2].childViewControllers[0] as! GaleriaFVDVC).galeria.fotosyvideos)
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! AddObsPVC
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
