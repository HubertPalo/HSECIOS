import UIKit
import DKImagePickerController

class ImageSliderPVC: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    /*func loadFotos(_ fotos: [FotoVideo], _ index: Int) {
        self.index = index
        self.fotos = fotos
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        vc.index = self.index
        vc.foto = self.fotos[self.index]
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }*/
    
    /*@objc func exit(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }*/
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(Utils.galeriaIndice)
        if Utils.galeriaIndice > 0 {
            return Utils.galeriaVCs[Utils.galeriaIndice - 1]
        }
        return nil
        // return getNextImagenVC(viewController, false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(Utils.galeriaIndice)
        if Utils.galeriaIndice + 1 < Utils.galeriaVCs.count {
            return Utils.galeriaVCs[Utils.galeriaIndice + 1]
        }
        return nil
        // return getNextImagenVC(viewController, true)
    }
    
    /*func getNextImagenVC(_ view: UIViewController, _ next: Bool) -> UIViewController? {
        // let vcActual = view as! ImageSliderPVCItem
        // let nextIndex = next ? vcActual.indice + 1 : vcActual.indice - 1
        let nextIndex = next ? Utils.galeriaIndice + 1 : Utils.galeriaIndice - 1
        
        if next && nextIndex < Utils.galeriaVCs.count {
            return Utils.galeriaVCs[nextIndex]
            // vcSiguiente.foto = self.fotos[nextIndex]
            // return vcSiguiente
        } else if !next && nextIndex > 0 {
            return Utils.galeriaVCs[nextIndex]
            // vcSiguiente.foto = self.fotos[nextIndex]
            // return vcSiguiente
        } else {
            return nil
        }
    }*/
    
}
