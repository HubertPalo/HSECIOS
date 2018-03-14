import UIKit
import Alamofire

class HConfig {
    
    static func updateGlobals() {
        if Globals.needsUpdate("Ubicaciones") {
            updateConfig("UBIC", success: Globals.updateUbicaciones(_:))
        }
        if Globals.needsUpdate("Gerencia") {
            updateConfig("GERE", success: Globals.updateGerencia(_:))
        }
        if Globals.needsUpdate("Superintendencia") {
            updateConfig("SUPE", success: Globals.updateSuperintendencia(_:))
        }
    }
    
    static func updateConfig(_ tipo: String, success: @escaping (_ data: [Maestro])-> Void) {
        Alamofire.request("\(Config.urlBase)/Maestro/GetTipoMaestro/\(tipo)", headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    let dict = response.result.value as! NSDictionary
                    let data = Dict.toArrayMaestro(dict)
                    success(data)
                default:
                    break
                }
            }
        }
    }
}
