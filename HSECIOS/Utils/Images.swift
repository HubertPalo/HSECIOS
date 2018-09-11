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
    static let cursos = UIImage(named: "cursos")
    
    static let alertaRoja = UIImage(named: "alertaRoja")!
    static let alertaVerde = UIImage(named: "alertaVerde")!
    static let alertaAmarilla = UIImage(named: "alertaAmarilla")!
    static let confirmIcon = UIImage(named: "confirmicon")!
    static let errorIcon = UIImage(named: "erroricon")
    
    static var flags: Set<String> = Set()
    static var imagenes: [String: UIImage] = [:]
    static var avatars: [String: UIImage] = [:]
    static var notasCap = UIImage(named: "notasCapa")
    
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
        self.iconos["ESTADOFACILITO.A"] = UIImage.init(named: "FacilitoEstadoA")
        self.iconos["ESTADOFACILITO.O"] = UIImage.init(named: "FacilitoEstadoO")
        self.iconos["ESTADOFACILITO.P"] = UIImage.init(named: "FacilitoEstadoP")
        self.iconos["ESTADOFACILITO.S"] = UIImage.init(named: "FacilitoEstadoS")
        self.iconos["ESTADOFACILITO.1"] = self.alertaVerde
        self.iconos["ESTADOFACILITO.0"] = self.alertaVerde
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
    
    static func getIconFor(_ key: String) -> UIImage?{
        return self.iconos[key]
    }
    
    static func getImageFor(_ code: String) -> UIImage {
        return self.imagenes[code] ?? UIImage.init(named: "Carnet")!
    }
    
    static func downloadImage(_ correlativo: String) {
        let route = "\(Config.urlBase)/media/getImagePreview/\(correlativo)/Imagen.jpg"
        print(route)
        if correlativo == "" {
            return
        }
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
    
    static func downloadImageFull(_ correlativo: String) {
        let route = "\(Config.urlBase)/media/getImage/\(correlativo)/Imagen.jpg"
        print(route)
        if correlativo == "" {
            return
        }
        if !flags.contains("F-\(correlativo)") {
            flags.insert("F-\(correlativo)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["F-\(correlativo)"] = imagen
                    } else {
                        self.imagenes["F-\(correlativo)"] = Images.blank
                        flags.remove(correlativo)
                    }
                }
                Utils.desbloquearPantalla()
            }
        }
    }
    
    static func downloadImageFull(_ correlativo: String, _ shouldBlock: Bool, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getImage/\(correlativo)/Imagen.jpg"
        print(route)
        if correlativo == "" {
            completionHandler()
            return
        }
        if !flags.contains("F-\(correlativo)") {
            flags.insert("F-\(correlativo)")
            if shouldBlock {
                Utils.bloquearPantalla()
            }
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["F-\(correlativo)"] = imagen
                    } else {
                        self.imagenes["F-\(correlativo)"] = Images.blank
                        flags.remove(correlativo)
                    }
                }
                if shouldBlock {
                    Utils.desbloquearPantalla()
                }
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    static func downloadImage(_ correlativo: String, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getImagePreview/\(correlativo)/Imagen.jpg"
        print(route)
        if correlativo == "" {
            completionHandler()
            return
        }
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
        var newCodPersona = codPersona
        newCodPersona = newCodPersona.replacingOccurrences(of: "*", with: "")
        newCodPersona = newCodPersona.replacingOccurrences(of: ".", with: "")
        let route = "\(Config.urlBase)/media/getAvatar/\(newCodPersona.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)/Carnet.jpg"
        print(route)
        if codPersona == "" {
            return
        }
        if !flags.contains("A-\(codPersona)") {
            flags.insert("A-\(codPersona)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["A-\(codPersona)"] = imagen
                    } else {
                        self.imagenes["A-\(codPersona)"] = UIImage.init(named: "Carnet")
                        flags.remove(codPersona)
                    }
                }
                Utils.desbloquearPantalla()
            }
        }
    }
    
    static func downloadAvatar(_ codPersona: String, _ completionHandler: @escaping () -> Void) {
        var newCodPersona = codPersona
        newCodPersona = newCodPersona.replacingOccurrences(of: "*", with: "")
        newCodPersona = newCodPersona.replacingOccurrences(of: ".", with: "")
        let route = "\(Config.urlBase)/media/getAvatar/\(newCodPersona.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)/Carnet.jpg"
        print(route)
        if codPersona == "" {
            completionHandler()
            return
        }
        if !flags.contains("A-\(codPersona)") {
            flags.insert("A-\(codPersona)")
            Utils.bloquearPantalla()
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["A-\(codPersona)"] = imagen
                    } else {
                        self.imagenes["A-\(codPersona)"] = UIImage.init(named: "Carnet")
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
    
    /*static func showGallery(fotos: [FotoVideo], index: Int, viewController: UIViewController) {
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderVC") as! ImageSliderVC
        // vc.index = index
        // vc.fotos = fotos
        viewController.present(vc, animated: true, completion: nil)
    }*/
    
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
    
    static func loadAvatarFromDNI(_ dni: String, _ imageView: UIImageView, _ rounded: Bool) {
        if let imagen = avatars[dni] {
            imageView.image = imagen
        } else {
            Alamofire.request(Routes.forAvatarFromDNI(dni)).responseJSON { response in
                if let data = response.data {
                    if let image = UIImage(data: data) {
                        avatars[dni] = image
                        imageView.image = image
                    } else {
                        imageView.image = Images.blank
                    }
                    if true/*rounded*/ {
                        imageView.layer.cornerRadius = imageView.frame.height/2
                        imageView.layer.masksToBounds = true
                    }
                }
            }
        }
    }
}
