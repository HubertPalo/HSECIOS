import UIKit
import Alamofire

class Helper {
    
    static func getData(_ route: String, _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ dict: NSDictionary)-> Void) {
        print(route)
        Utils.bloquearPantalla(vcontroller, shouldBlock)
        Alamofire.request(route, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    Utils.desbloquearPantalla(shouldBlock)
                    success(response.result.value as! NSDictionary)
                default:
                    Utils.desbloquearPantalla(shouldBlock)
                    handleError("\(status)", vcontroller)
                }
            } else {
                Utils.desbloquearPantalla(shouldBlock)
                handleError("Error", vcontroller)
            }
        }
    }
    
    static func getData(_ route: String, _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ str: String)-> Void) {
        Utils.bloquearPantalla(vcontroller, shouldBlock)
        print(route)
        Alamofire.request(route, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    Utils.desbloquearPantalla(shouldBlock)
                    success(response.result.value as! String)
                default:
                    Utils.desbloquearPantalla(shouldBlock)
                    handleError("\(status)", vcontroller)
                }
            } else {
                Utils.desbloquearPantalla(shouldBlock)
                handleError("Error", vcontroller)
            }
        }
    }
    
    static func postData(_ route: String, _ parameters: [String:String], _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ dict: NSDictionary)-> Void) {
        print(route)
        Utils.bloquearPantalla(vcontroller, shouldBlock)
        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    Utils.desbloquearPantalla(shouldBlock)
                    success(response.result.value as! NSDictionary)
                default:
                    Utils.desbloquearPantalla(shouldBlock)
                    handleError("\(status)", vcontroller)
                }
            } else {
                Utils.desbloquearPantalla(shouldBlock)
                handleError("Error", vcontroller)
            }
        }
    }
    
    static func postData(_ route: String, _ parameters: [String:String], _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ str: String)-> Void) {
        print(route)
        Utils.bloquearPantalla(vcontroller, shouldBlock)
        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    Utils.desbloquearPantalla(shouldBlock)
                    success(response.result.value as! String)
                default:
                    Utils.desbloquearPantalla(shouldBlock)
                    handleError("\(status)", vcontroller)
                }
            } else {
                Utils.desbloquearPantalla(shouldBlock)
                handleError("Error", vcontroller)
            }
        }
    }
    
    static func handleError(_ error: String, _ vcontroller: UIViewController){
        print(error)
    }
}
