import UIKit
import Alamofire

class HLogin {
    
    static func login(_ username: String, _ password: String, vcontroller: UIViewController, success: @escaping ()-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/membership/authenticate?username=\(username)&password=\(password)&domain=anyaccess").responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    Utils.token = response.result.value as! String
                    Utils.desbloquearPantalla()
                    success()
                default:
                    Utils.desbloquearPantalla()
                    error("\(status)")
                    //Utils.error("\(status)", vc)
                }
            } else {
                Utils.desbloquearPantalla()
                error("Error")
                //Utils.error("Error", vc)
            }
        }
    }
    
    static func getUserInfo(vcontroller: UIViewController, success: @escaping ()->Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/usuario/getdata/", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    Dict.extractUserData(dict)
                    Utils.desbloquearPantalla()
                    success()
                default:
                    Utils.desbloquearPantalla()
                    error("\(status)")
                    //Utils.error("\(status)", vc)
                }
            } else {
                Utils.desbloquearPantalla()
                error("Error")
                //Utils.error("Error", vc)
            }
        }
    }
    
}
