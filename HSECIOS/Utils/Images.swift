import UIKit
import Alamofire

class Images {
    static let blank = UIImage(named: "white")!
    static let checked = UIImage(named: "checked")
    static let unchecked = UIImage(named: "unchecked")
    static let user = UIImage(named: "user")
    static let lock = UIImage(named: "lock")
    
    static let lightRed = UIImage(named: "lightR")!
    static let lightGreen = UIImage(named: "lightG")!
    static let lightYellow = UIImage(named: "lightY")!
    
    
    static var flags: Set<String> = Set()
    static var imagenes: [String: UIImage] = [:]
    
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
                    tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
                }
            }
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
                    tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
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
    
    static func showGallery(codigo: String, list: [Multimedia], index: Int, viewController: UIViewController) {
        let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "imageSlider") as! ImageSliderPVC
        vc.imageCode = codigo
        vc.multimedia = list
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func getImageForRisk(_ risk: String) -> UIImage{
        switch risk {
        case "AL":
            return lightRed
        case "ME":
            return lightYellow
        case "BA":
            return lightGreen
        default:
            return blank
        }
    }
}
