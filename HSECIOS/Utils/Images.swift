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
        self.iconos["FILES.xls"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.XLS"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.xlsx"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.XLSX"] = UIImage.init(named: "xlsx")
        self.iconos["FILES.ppt"] = UIImage.init(named: "ppt")
        self.iconos["FILES.PPT"] = UIImage.init(named: "ppt")
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
    
    static func downloadAllImagesIn(_ elementos: [Any], _ completionHandler: @escaping () -> Void) {
        Utils.bloquearPantalla()
        var imagesToDownload: [String] = []
        var avatarToDownload: [String] = []
        if elementos is [MuroElement] {
            for i in 0..<elementos.count {
                let unit = elementos[i] as! MuroElement
                if unit.UrlPrew != "" {
                    imagesToDownload.append(unit.UrlPrew ?? "")
                }
                if unit.UrlObs != "" && !avatarToDownload.contains(unit.UrlObs ?? "") {
                    avatarToDownload.append(unit.UrlObs ?? "")
                }
            }
        }
        var contadorImagen = 0
        var contadorAvatar = 0
        
        for i in 0..<imagesToDownload.count {
            self.downloadImage(imagesToDownload[i], {
                contadorImagen = contadorImagen + 1
                print("Contador image - \(contadorImagen)")
                if contadorImagen == imagesToDownload.count && contadorAvatar == avatarToDownload.count {
                    Utils.desbloquearPantalla()
                    completionHandler()
                }
            })
        }
        
        for j in (0..<avatarToDownload.count).reversed() {
            self.downloadAvatar(avatarToDownload[j], {
                contadorAvatar = contadorAvatar + 1
                print("Contador avatar - \(contadorAvatar)")
                if contadorImagen == imagesToDownload.count && contadorAvatar == avatarToDownload.count {
                    Utils.desbloquearPantalla()
                    completionHandler()
                }
            })
        }
    }
    
    static func downloadImage(_ code: String, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getImagePreview/\(code)/Imagen.jpg"
        print(route)
        if !flags.contains("P-\(code)") {
            flags.insert("P-\(code)")
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["P-\(code)"] = imagen
                    } else {
                        self.imagenes["P-\(code)"] = Images.blank
                        flags.remove(code)
                    }
                }
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    static func downloadAvatar(_ code: String, _ completionHandler: @escaping () -> Void) {
        let route = "\(Config.urlBase)/media/getAvatar/\(code)/Carnet.jpg"
        print(route)
        if !flags.contains("A-\(code)") {
            flags.insert("A-\(code)")
            Alamofire.request(route).responseJSON { response in
                if let imagenData = response.data {
                    if let imagen = UIImage(data: imagenData) {
                        self.imagenes["A-\(code)"] = imagen
                    } else {
                        self.imagenes["A-\(code)"] = Images.blank
                        flags.remove(code)
                    }
                }
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    static func getFromCode(_ code: String,_ type: String, _ tableView: UITableView, _ index: Int) {
        if !flags.contains(code) {
            flags.insert(code)
            var route = ""
            switch type {
            case "Avatar":
                route = "\(Config.urlBase)/media/getAvatar/\(code)/Carnet.jpg"
                break
            case "Image":
                route = "\(Config.urlBase)/media/getImagepreview//\(code)/Imagen.jpg"
                break
            default:
                break
            }
            
            Alamofire.request(route).responseJSON { response in
                if let data = response.data {
                    var image = UIImage(data: data)
                    if image == nil {
                        image = UIImage(named: "white")!
                        flags.remove(code)
                    }
                    imagenes[code] = image
                    //let contentOffset = tableView.contentOffset
                    tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                    // tableView.setContentOffset(contentOffset, animated: false)
                    /*if tableView.indexPathsForVisibleRows!.contains(IndexPath.init(row: index, section: 0)) {
                     tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                     }*/
                    
                }
            }
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
        let data = UIImageJPEGRepresentation(imagen, 1)!
        let umbral = 200 * 1000
        if data.count > umbral {
            let ratio: CGFloat = CGFloat(umbral) / CGFloat(data.count)
            let newdata = UIImageJPEGRepresentation(imagen, ratio)!
            return newdata
        }
        return data
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
    
    static func loadAvatarFromDNI(_ dni: String, _ imageView: UIImageView, _ rounded: Bool, _ tableview: UITableView, _ indexpath: IndexPath) {
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = true
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
                    tableview.reloadRows(at: [indexpath], with: .none)
                }
            }
        }
    }
    
    
    static func loadImagePreviewFromCode(_ code: String, _ imageView: UIImageView) {
        if let imagen = imagenes[code] {
            imageView.image = imagen
        } else {
            Alamofire.request(Routes.forImagePreview(code)).responseJSON { response in
                if let data = response.data {
                    if let imagen = UIImage(data: data) {
                        imageView.image = imagen
                        imagenes[code] = imagen
                    } else {
                        imageView.image = Images.blank
                    }
                }
            }
        }
    }
    
    static func loadImage(_ code: String, _ afterGetting: ((_ image: UIImage) -> Void)?) {
        if let imagen = imagenes[code] {
            afterGetting?(imagen)
        } else {
            Alamofire.request(Routes.forImagePreview(code)).responseJSON { response in
                if let data = response.data {
                    if let imagen = UIImage(data: data) {
                        afterGetting?(imagen)
                    } else {
                        afterGetting?(Images.blank)
                    }
                }
            }
        }
    }
    
    static func loadImagePreviewFromCode(_ code: String, _ imageView: UIImageView, _ completionHandler : @escaping () -> Void) {
        if let imagen = imagenes[code] {
            imageView.image = imagen
        } else {
            Alamofire.request(Routes.forImagePreview(code)).responseJSON { response in
                if let data = response.data {
                    if let imagen = UIImage(data: data) {
                        // imageView.image = imagen
                        imagenes[code] = imagen
                    } else {
                        imagenes[code] = Images.blank
                    }
                    completionHandler()
                    /*(if (table.indexPathsForVisibleRows?.contains(indexPath))! {
                        table.reloadRows(at: [indexPath], with: .none)
                    }*/
                }
            }
        }
    }
    
    static func get(_ code: String, _ tableView: UITableView, _ index: Int) {
        if !flags.contains(code) {
            flags.insert(code)
            Alamofire.request("\(Config.urlBase)/\(code)").responseJSON { response in
                if let data = response.data {
                    var image = UIImage(data: data)
                    if image == nil {
                        image = UIImage(named: "white")!
                        flags.remove(code)
                    }
                    imagenes[code] = image
                    tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
    
    
    static func get(_ code: String, success: @escaping ()-> Void) {
        if !flags.contains(code) {
            flags.insert(code)
            Alamofire.request("\(Config.urlBase)/\(code)").responseJSON { response in
                if let data = response.data {
                    var image = UIImage(data: data)
                    if image == nil {
                        image = UIImage(named: "white")!
                        flags.remove(code)
                    }
                    imagenes[code] = image
                    success()
                }
            }
        }
    }
    
    /*static func showGallery(codigo: String, list: [Multimedia], index: Int, viewController: UIViewController) {
        // let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "imageSlider") as! ImageSliderPVC
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSlider") as! ImageSliderPVC
        vc.imageCode = codigo
        vc.multimedia = list
        viewController.present(vc, animated: true, completion: nil)
    }*/
    
    /*static func showGallery(assets: [DKAsset], index: Int, viewController: UIViewController) {
        let vc = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderVC") as! ImageSliderVC
        vc.index = index
        vc.assets = assets
        viewController.present(vc, animated: true, completion: nil)
    }*/
    
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
