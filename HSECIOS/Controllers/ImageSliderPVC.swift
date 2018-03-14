import UIKit

class ImageSliderPVC: UIPageViewController, UIPageViewControllerDataSource {
    
    var imageCode = ""
    var multimedia: [Multimedia] = []
    /*
     override func viewWillAppear(_ animated: Bool) {
     Utils.orientation = UIInterfaceOrientationMask.all
     }
     
     override func viewWillDisappear(_ animated: Bool) {
     Utils.orientation = UIInterfaceOrientationMask.portrait
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.exit))
        tapRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapRecognizer)
        let vc = Tabs.sb.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        vc.imageCode = imageCode
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func exit(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let view = viewController as! ImageSliderPVCItem
        return getNextImagenVC(view.imageCode, false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let view = viewController as! ImageSliderPVCItem
        return getNextImagenVC(view.imageCode, true)
    }
    
    func getNextImagenVC(_ codigo: String, _ next: Bool) -> UIViewController? {
        var indice = -1
        for i in 0..<multimedia.count {
            if multimedia[i].Url == codigo {
                indice = i
                break
            }
        }
        var nextCode = ""
        if indice == -1 {
            return nil
        } else {
            if next && indice + 1 < multimedia.count {
                nextCode = multimedia[indice + 1].Url
            } else if !next && indice > 0 {
                nextCode = multimedia[indice - 1].Url
            } else {
                return nil
            }
        }
        
        let vc = Tabs.sb.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        vc.imageCode = nextCode
        return vc
    }
    
}
