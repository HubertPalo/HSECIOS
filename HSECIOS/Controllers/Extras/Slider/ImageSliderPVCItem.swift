import UIKit
import DKImagePickerController

class ImageSliderPVCItem: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var imagen: UIImageView!
    
    var indice = 0
    // var index = 0
    var foto = FotoVideo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.delegate = self
        self.scroll.minimumZoomScale = 1.0
        self.scroll.maximumZoomScale = 6.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Utils.galeriaIndice = self.indice
        Dict.unitToData(self.foto)
        if let imagenFull = self.foto.imagenFull {
            self.imagen.image = imagenFull
        } else {
            if let imagenMini = self.foto.imagen {
                self.imagen.image = imagenMini
            } else {
                self.imagen.image = Images.imagenes["P-\(foto.Correlativo!)"] ?? Images.blank
            }
            if self.foto.asset == nil {
                print("no hay asset")
                if let imagenPreview = Images.imagenes["P-\(foto.Correlativo!)"] {
                   self.imagen.image = imagenPreview
                } else {
                    Images.downloadImage("\(foto.Correlativo!)", {() in
                        self.imagen.image = Images.imagenes["P-\(self.foto.Correlativo!)"] ?? Images.blank
                    })
                }
                if let imagenFull = Images.imagenes["F-\(foto.Correlativo!)"] {
                    self.imagen.image = imagenFull
                } else {
                    Images.downloadImageFull("\(foto.Correlativo!)", false, {() in
                        self.imagen.image = Images.imagenes["F-\(self.foto.Correlativo!)"] ?? Images.blank
                    })
                }
            } else {
                self.foto.asset!.fetchOriginalImageWithCompleteBlock({(image, info) in
                    if image != nil {
                        self.imagen.image = image
                        self.foto.imagenFull = image
                    }
                })
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagen
    }
    
}
