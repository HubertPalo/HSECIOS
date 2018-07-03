import UIKit
import DKImagePickerController

class ImageSliderVC: UIViewController {
    
    var index = 0
    var fotos: [FotoVideo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.exit))
        tapRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapRecognizer)
        let hijo = self.childViewControllers[0] as! ImageSliderPVC
        hijo.loadFotos(self.fotos, self.index)
    }
    
    @IBAction func clickEnX(_ sender: Any) {
        self.exit()
    }
    
    @objc func exit(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
