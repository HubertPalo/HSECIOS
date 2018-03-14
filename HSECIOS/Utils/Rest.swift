//
//  Rest.swift
//  HSECIOS
//
//  Created by Mac02 on 15/12/17.
//  Copyright © 2017 pangolabs. All rights reserved.
//
import Alamofire
import Foundation

class Rest {
    
    static func get(_ route: String, vc: UIViewController, success: @escaping (_ dict: Any)-> Void) {
        Alamofire.request(route).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let datos = response.result.value!
                    success(datos)
                default:
                    Utils.error("\(status)", vc)
                }
            } else {
                Utils.error("Error", vc)
            }
        }
    }
    
    static func get(_ route: String, vc: UIViewController, success: @escaping (_ dict: Any)-> Void, error: @escaping (_ tipo: String)-> Void ) {
        Alamofire.request(route).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let datos = response.result.value!
                    success(datos)
                default:
                    error("\(status)")
                }
            } else {
                error("Error")
            }
        }
    }
    
    static func post(_ route: String, success: @escaping (_ dict: Any)-> Void, error: @escaping (_ tipo: String)-> Void ) {
        Alamofire.request(route).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let datos = response.result.value!
                    success(datos)
                default:
                    error("\(status)")
                }
            } else {
                error("Error")
            }
        }
    }
    
}
