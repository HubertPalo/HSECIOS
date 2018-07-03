import UIKit
import DKImagePickerController

class ImageSliderPVCItem: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var imagen: UIImageView!
    
    var index = 0
    var foto = FotoVideo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.delegate = self
        self.scroll.minimumZoomScale = 1.0
        self.scroll.maximumZoomScale = 6.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*var parent = self.parent
        while !(parent is ImageSliderPVC) {
            parent = parent?.parent
            print("Cont parent")
        }*/
        let padre = self.parent as! ImageSliderPVC
        padre.index = self.index
        if let imagenFull = self.foto.imagenFull {
            self.imagen.image = imagenFull
            print("hay Full")
        } else {
            print("no Hay Full")
            if let imagenMini = self.foto.imagen {
                self.imagen.image = imagenMini
                print("hay mini")
            } else {
                print("no hay mini")
            }
            if self.foto.asset == nil {
                print("no hay asset")
            } else {
                print("hay asset")
                self.foto.asset!.fetchOriginalImageWithCompleteBlock({(image, info) in
                    if image != nil {
                        self.imagen.image = image
                        self.foto.imagenFull = image
                        padre.fotos[self.index].imagenFull = image
                    }
                })
            }
        }
        
        /*if self.imagen != nil {
            if imageToLoad == Images.blank && asset != nil {
                asset!
            }
            self.imagen.image = imageToLoad
        }*/
        //self.imagen.image = self.imageToLoad
        /*
        if let image = Images.imagenes[imageCode] {
            imagen.image = image
        } else {
            Images.get(imageCode, success: updateImage)
        }*/
    }
    /*func loadImage(_ image: UIImage) {
        if self.imagen != nil {
            self.imagen.image = image
        }
        self.imageToLoad = image
    }
    
    func updateImage() {
        if let image = Images.imagenes[imageCode] {
            imagen.image = image
        } else {
            imagen.image = Images.blank
        }
    }*/
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagen
    }
    
}
