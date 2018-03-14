import UIKit

class ImageSliderPVCItem: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    
    var imageCode = ""
    
    @IBOutlet weak var imagen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.delegate = self
        self.scroll.minimumZoomScale = 1.0
        self.scroll.maximumZoomScale = 6.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let image = Images.imagenes[imageCode] {
            imagen.image = image
        } else {
            Images.get(imageCode, success: updateImage)
        }
    }
    
    func updateImage() {
        if let image = Images.imagenes[imageCode] {
            imagen.image = image
        } else {
            imagen.image = Images.blank
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagen
    }
    
    @IBAction func clickEnX(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
