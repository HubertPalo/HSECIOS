import UIKit
import Alamofire
import DKImagePickerController

class Images {
    
    static let colorClover = UIColor.init(red: 0, green: 143/250, blue: 0, alpha: 1)
    
    static let blank = UIImage(named: "white")!
    static let checked = UIImage(named: "checked")
    static let unchecked = UIImage(named: "unchecked")
    static let user = UIImage(named: "user")
    static let lock = UIImage(named: "lock")
    
    static let minero = UIImage(named: "minero")
    static let add = UIImage(named: "add")
    static let observacion = UIImage(named: "observacion")
    static let inspeccion = UIImage(named: "inspeccion")
    static let facilito = UIImage(named: "facilito")
    
    static let alertaRoja = UIImage(named: "alertaRoja")!
    static let alertaVerde = UIImage(named: "alertaVerde")!
    static let alertaAmarilla = UIImage(named: "alertaAmarilla")!
    
    static var flags: Set<String> = Set()
    static var imagenes: [String: UIImage] = [:]
    static var avatars: [String: UIImage] = [:]
    
    
    static var iconos: [String:UIImage] = [:]
    static func initDicts() {
        imagenes["-1"] = Images.blank
    }
    
    static func initImages() {
        self.iconos["FILES.doc"] = UIImage.init(named: "doc")
        self.iconos["FILES.DOC"] = UIImage.init(named: "doc")
        self.iconos["FILES.docx"] = UIImage.init(named: "doc")
        self.iconos["FILES.DOCX"] = UIImage.init(named: "doc")
        self.iconos["FILES.xls"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.XLS"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.xlsx"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.XLSX"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.ppt"] = UIImage.init(named: "ppt")
        self.iconos["FILES.PPT"] = UIImage.init(named: "ppt")
        self.iconos["FILES.pptx"] = UIImage.init(named: "ppt")
        self.iconos["FILES.PPTX"] = UIImage.init(named: "ppt")
        self.iconos["FILES.pdf"] = UIImage.init(named: "pdf")
        self.iconos["FILES.PDF"] = UIImage.init(named: "pdf")
        self.iconos["NIVELRIESGO.BA"] = self.alertaVerde
        self.iconos["NIVELRIESGO.ME"] = self.alertaAmarilla
        self.iconos["NIVELRIESGO.AL"] = self.alertaRoja
        self.iconos["ESTADOFACILITO.A"] = UIImage.init(named: "alertaVerde")
        self.iconos["ESTADOFACILITO.O"] = UIImage.init(named: "interrogacion")
        self.iconos["ESTADOFACILITO.P"] = UIImage.init(named: "alertaRoja")
        self.iconos["ESTADOFACILITO.S"] = UIImage.init(named: "alertaAmarilla")
        
    }
    
    static func resize(_ input: UIImage, _ newWidth: Int, _ newHeight: Int) -> UIImage {
       UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        input.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func loadIcon(_ key: String, _ imageView: UIImageView) {
        imageView.image = self.iconos[key] ?? Images.blank
    }
    
    static func getImageFor(_ code: String) -> UIImage {
        return self.imagenes[code] ?? Images.blank
    }
    
    static func downloadImage(_ correlativo: String) {
        let route = "\(Config.urlBase)/media/getImagePreview/\(correlativo)/Imagen.jpg"
        print(route)
        if !flags.contains("P-\(correlativo)") {
            flags.insert("P-\(correlativo)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["P-\(correlativo)"] = imagen
                    } else {
                        self.imagenes["P-\(correlativo)"] = Images.blank
                        flags.remove(correlativo)
                    }
                }
                Utils.desbloquearPantalla()
            }
        }
    }
    
    static func downloadImage(_ correlativo: String, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getImagePreview/\(correlativo)/Imagen.jpg"
        print(route)
        if !flags.contains("P-\(correlativo)") {
            flags.insert("P-\(correlativo)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["P-\(correlativo)"] = imagen
                    } else {
                        self.imagenes["P-\(correlativo)"] = Images.blank
                        flags.remove(correlativo)
                    }
                }
                Utils.desbloquearPantalla()
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    static func downloadAvatar(_ codPersona: String) {
        let route = "\(Config.urlBase)/media/getAvatar/\(codPersona)/Carnet.jpg"
        print(route)
        if !flags.contains("A-\(codPersona)") {
            flags.insert("A-\(codPersona)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["A-\(codPersona)"] = imagen
                    } else {
                        self.imagenes["A-\(codPersona)"] = Images.blank
                        flags.remove(codPersona)
                    }
                }
                Utils.desbloquearPantalla()
            }
        }
    }
    
    static func downloadAvatar(_ codPersona: String, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getAvatar/\(codPersona)/Carnet.jpg"
        print(route)
        if !flags.contains("A-\(codPersona)") {
            flags.insert("A-\(codPersona)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["A-\(codPersona)"] = imagen
                    } else {
                        self.imagenes["A-\(codPersona)"] = Images.blank
                        flags.remove(codPersona)
                    }
                }
                Utils.desbloquearPantalla()
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    static func resizeImageToKB(_ imagen: UIImage, _ toKB: Int) -> Data{
        let data = UIImageJPEGRepresentation(imagen, 1)!
        let umbral = toKB * 1000
        print("total: \(data.count)")
        if data.count > umbral {
            let ratio: CGFloat = CGFloat(umbral) / CGFloat(data.count)
            print("ratio = \(ratio)")
            let newdata = UIImageJPEGRepresentation(imagen, ratio)!
            print("total: \(newdata.count)")
            return newdata
        }
        return data
    }
    
    static func imageToDataCompressed(_ imagen: UIImage) -> Data{
        var newimagen = imagen
        let data = UIImageJPEGRepresentation(newimagen, 1)!
        let umbral = 200 * 1000
        if data.count > umbral {
            let ratio: CGFloat = CGFloat(umbral) / CGFloat(data.count)
            let newdata = UIImageJPEGRepresentation(imagen, ratio)!
            return newdata
        }
        return data
    }
    
    static func showGallery(fotos: [FotoVideo], index: Int, viewController: UIViewController) {
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderVC") as! ImageSliderVC
        vc.index = index
        vc.fotos = fotos
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func getImageForRisk(_ risk: String) -> UIImage{
        switch risk {
        case "AL":
            return alertaRoja
        case "ME":
            return alertaAmarilla
        case "BA":
            return alertaVerde
        default:
            return blank
        }
    }
}
