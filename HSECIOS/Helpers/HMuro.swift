/*import UIKit
import Alamofire

class HMuro {
    
    
    
    static func getMuro(_ pagina: Int, _ elementos: Int, vcontroller: UIViewController, success: @escaping (_ data: [MuroElement])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/Muro/GetMuro/\(pagina)/\(elementos)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayMuroElement(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func getObservaciones(_ pagina: Int, _ elementos: Int, vcontroller: UIViewController, success: @escaping (_ data: [MuroElement])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/observaciones/getobservaciones/-/\(pagina)/\(elementos)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayMuroElement(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func getObservacionesGeneralData(_ codigo: String, vcontroller: UIViewController, success: @escaping (_ data: ObservacionGD)-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/observaciones/get/\(codigo)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toObsGeneralData(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func getObservacionesMultimedia(_ codigo: String, vcontroller: UIViewController, success: @escaping (_ data: [ObsMultimedia])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/media/GetMultimedia/\(codigo)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayObsMultimedia(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func getObservacionesPlanAccion(_ codigo: String, vcontroller: UIViewController, success: @escaping (_ data: [ObsPlanAccion])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/PlanAccion/GetPlanes/\(codigo)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayObsPlanAccion(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func getObservacionesComentario(_ codigo: String, vcontroller: UIViewController, success: @escaping (_ data: [ObsComentario])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/Comentario/getObs/\(codigo)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayObsComentario(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
    
    static func postObservacionesComentario(_ codigo: String, _ mensaje: String, vcontroller: UIViewController, success: @escaping (_ data: String)-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        let parametros: Parameters = ["CodComentario":codigo,"Comentario": mensaje]
        Alamofire.request("\(Config.urlBase)/Comentario/insert", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let result = response.result.value as! String
                    Utils.desbloquearPantalla()
                    success(result)
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
    
    static func buscarPersonas(_ apellidos: String, _ nombres: String, _ dni: String, _ gerencia: String, _ superintendencia: String, _ nropagina: Int, _ nroitems: Int, vcontroller: UIViewController) {
        Utils.bloquearPantalla(vcontroller)
        Alamofire.request("\(Config.urlBase)/Usuario/FiltroPersona/\(apellidos)@\(nombres)@\(dni)@\(gerencia)@\(superintendencia)/\(nropagina)/\(nroitems)", headers: Utils.getHeader()).responseJSON { response in
            let vc = vcontroller as! FiltroPersonaVC
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayPersona(dict)
                    Utils.desbloquearPantalla()
                    //success(data)
                    vc.personas = data
                    vc.tabla.reloadData()
                default:
                    Utils.desbloquearPantalla()
                    vc.errorGettingData("\(status)")
                    //Utils.error("\(status)", vc)
                }
            } else {
                Utils.desbloquearPantalla()
                vc.errorGettingData("Error")
                //Utils.error("Error", vc)
            }
        }
    }
    
    static func filtrarData(_ tipo: String, _ parametros: [String:String], vcontroller: UIViewController, success: @escaping (_ data: [MuroElement])-> Void, error: @escaping (_ error: String)-> Void) {
        Utils.bloquearPantalla(vcontroller)
        var route = ""
        switch tipo {
        case "Observaciones":
            route = "\(Config.urlBase)/Observaciones/FiltroObservaciones"
            break
        case "Inspecciones":
            route = "\(Config.urlBase)/Inspecciones/FiltroInspecciones"
            break
        default:
            break
        }
        Alamofire.request(route, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayMuroElement(dict)
                    Utils.desbloquearPantalla()
                    success(data)
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
*/
