import UIKit
import DKImagePickerController

class ImageSliderPVC: UIPageViewController, UIPageViewControllerDataSource {

    var index = 0
    var fotos: [FotoVideo] = []
    
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
    }
    
    func loadFotos(_ fotos: [FotoVideo], _ index: Int) {
        self.index = index
        self.fotos = fotos
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        vc.index = self.index
        vc.foto = self.fotos[self.index]
        
        /*self.fotos[self.index].asset!.fetchOriginalImageWithCompleteBlock({(image, info) in
            vc.loadImage(image ?? Images.blank)
            
            self.images[self.index] = image ?? Images.blank
        })*/
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func exit(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getNextImagenVC(viewController, false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextImagenVC(viewController, true)
    }
    
    func getNextImagenVC(_ view: UIViewController, _ next: Bool) -> UIViewController? {
        let vcSiguiente = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        let vcActual = view as! ImageSliderPVCItem
        let nextIndex = next ? vcActual.index + 1 : vcActual.index - 1
        vcSiguiente.index = nextIndex
        
        if next && nextIndex < self.fotos.count {
            vcSiguiente.foto = self.fotos[nextIndex]
            /*let nextIndex = self.index + 1
            vc.asset = self.assets[nextIndex]
            vc.index = nextIndex
            if self.needsLoadAsset[nextIndex] {
                assets[self.index + 1].fetchOriginalImageWithCompleteBlock({(image, info) in
                    vc.loadImage(image ?? Images.blank)
                    self.images[nextIndex] = image ?? Images.blank
                    self.needsLoadAsset[nextIndex] = false
                })
            } else {
                vc.loadImage(self.images[nextIndex])
                self.needsLoadAsset[nextIndex] = false
            }*/
            return vcSiguiente
        } else if !next && nextIndex > 0 {
            vcSiguiente.foto = self.fotos[nextIndex]
            /*let nextIndex = self.index - 1
            vc.asset = self.assets[nextIndex]
            vc.index = nextIndex
            if self.needsLoadAsset[nextIndex] {
                assets[nextIndex].fetchOriginalImageWithCompleteBlock({(image, info) in
                    vc.loadImage(image ?? Images.blank)
                    self.images[nextIndex] = image ?? Images.blank
                    self.needsLoadAsset[nextIndex] = false
                })
            } else {
                vc.loadImage(self.images[nextIndex])
                self.needsLoadAsset[nextIndex] = false
            }*/
            return vcSiguiente
        } else {
            return nil
        }
        /*
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
        
        /*let vc = Tabs.sb.instantiateViewController(withIdentifier: "imageSliderItem") as! ImageSliderPVCItem
        vc.imageCode = nextCode*/
        return vc*/
    }
    
}
