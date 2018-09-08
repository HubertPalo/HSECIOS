import UIKit
import DKImagePickerController

class ImageSliderVC: UIViewController {
    
    // var index = 0
    // var fotos: [FotoVideo] = []
    
    var pvc = ImageSliderPVC()
    
    override func viewWillAppear(_ animated: Bool) {
        pvc.setViewControllers([Utils.galeriaVCs[Utils.galeriaIndice]], direction: .forward, animated: true, completion: nil)
        pvc.dataSource = nil
        pvc.dataSource = pvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.exit))
        tapRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapRecognizer)
        self.pvc = self.childViewControllers[0] as! ImageSliderPVC
        pvc.setViewControllers([Utils.galeriaVCs[Utils.galeriaIndice]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func clickEnX(_ sender: Any) {
        self.exit()
    }
    
    @objc func exit(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
