import UIKit

class Config {
    
    static let globals = UserDefaults.standard
    
    static var loginSaveFlag = false
    static var loginUsername = ""
    static var loginPassword = ""
    static var urlBase = ""
    
    
    static func getAllMaestro() {
        Utils.maestroCodTipo = globals.dictionary(forKey: "HSECMaestroCodTipo") as? [String : [String]] ?? [:]
        Utils.maestroDescripcion = globals.dictionary(forKey: "HSECMaestroDescripcion") as? [String : [String]] ?? [:]
        Rest.getDataGeneral(Routes.forMaestroALL(), false, success: {(resultValue:Any?,data:Data?) in
            let arrayMaestros: ArrayGeneral<Maestro> = Dict.dataToArray(data!)
            let maestros = arrayMaestros.Data//Dict.toArrayMaestro(dict)
            var newMaestroCodTipo: [String:[String]] = [:]
            var newMaestroDescripcion: [String:[String]] = [:]
            for i in 0..<maestros.count {
                let codigo = maestros[i].Codigo
                let codTipo = maestros[i].CodTipo
                let descripcion = maestros[i].Descripcion
                if newMaestroCodTipo[codigo] == nil {
                    newMaestroCodTipo[codigo] = []
                    newMaestroDescripcion[codigo] = []
                }
                switch codigo {
                case "UBIC":
                    let splits = codTipo.components(separatedBy: ".")
                    if splits.count == 1 {
                        newMaestroCodTipo[codigo]!.append(codTipo)
                        newMaestroDescripcion[codigo]!.append(descripcion)
                    } else if splits.count == 2 {
                        let newcodigo = "\(codigo).\(String(splits[0]))"
                        if newMaestroCodTipo[newcodigo] == nil {
                            newMaestroCodTipo[newcodigo] = []
                            newMaestroDescripcion[newcodigo] = []
                        }
                        newMaestroCodTipo[newcodigo]!.append(String(splits[1]))
                        newMaestroDescripcion[newcodigo]!.append(descripcion)
                    } else if splits.count == 3 {
                        let newcodigo = "\(codigo).\(String(splits[0])).\(String(splits[1]))"
                        if newMaestroCodTipo[newcodigo] == nil {
                            newMaestroCodTipo[newcodigo] = []
                            newMaestroDescripcion[newcodigo] = []
                        }
                        newMaestroCodTipo[newcodigo]!.append(String(splits[2]))
                        newMaestroDescripcion[newcodigo]!.append(descripcion)
                    }
                case "SUPE":
                    let splits = codTipo.components(separatedBy: ".")
                    if splits.count == 1 {
                        newMaestroCodTipo[codigo]!.append(codTipo)
                        newMaestroDescripcion[codigo]!.append(descripcion)
                    } else if splits.count == 2 {
                        let newcodigo = "\(codigo).\(String(splits[0]))"
                        if newMaestroCodTipo[newcodigo] == nil {
                            newMaestroCodTipo[newcodigo] = []
                            newMaestroDescripcion[newcodigo] = []
                        }
                        newMaestroCodTipo[newcodigo]!.append(String(splits[1]))
                        newMaestroDescripcion[newcodigo]!.append(descripcion)
                    } else if splits.count == 3 {
                        let newcodigo = "\(codigo).\(String(splits[0])).\(String(splits[1]))"
                        if newMaestroCodTipo[newcodigo] == nil {
                            newMaestroCodTipo[newcodigo] = []
                            newMaestroDescripcion[newcodigo] = []
                        }
                        newMaestroCodTipo[newcodigo]!.append(String(splits[2]))
                        newMaestroDescripcion[newcodigo]!.append(descripcion)
                    }
                default:
                    newMaestroCodTipo[codigo]!.append(codTipo)
                    newMaestroDescripcion[codigo]!.append(descripcion)
                }
            }
            globals.set(newMaestroCodTipo, forKey: "HSECMaestroCodTipo")
            globals.set(newMaestroDescripcion, forKey: "HSECMaestroDescripcion")
            Utils.maestroCodTipo = newMaestroCodTipo
            Utils.maestroDescripcion = newMaestroDescripcion
            print("Obtuvo todos los maestros")
        }, error: nil)
    }
    
    static func initConfig() {
        loginSaveFlag = globals.bool(forKey: "configLoginSaveFlag")
        loginUsername = ""
        loginPassword = ""
        urlBase = ""
        
        let savedYear = globals.integer(forKey: "HSEC_CURRENT_YEAR")
        let phoneYear = Int(Utils.date2str(Date(), "YYYY")) ?? 0
        var currentYear = savedYear
        if phoneYear > savedYear {
            currentYear = phoneYear
        }
        globals.set(currentYear, forKey: "HSEC_CURRENT_YEAR")
        Utils.currentYear = currentYear
        
        if loginSaveFlag {
            if let username = globals.string(forKey: "configLoginUsername") {
                loginUsername = username
            }
            if let password = globals.string(forKey: "configLoginPassword") {
                loginPassword = password
            }
        }
        if let url = globals.string(forKey: "configUrlBase") {
            urlBase = url
        } else {
            urlBase = "https://app.antapaccay.com.pe/hsecweb/whsec_Service/api"
            globals.set(urlBase, forKey: "configUrlBase")
        }
        //Comentar estas lineas despues, solo es para usar pango
        //urlBase = "http://192.168.1.2/WHSEC_Servicedmz/api"
        //globals.set(urlBase, forKey: "configUrlBase")
        urlBase = "https://app.antapaccay.com.pe/hsecweb/whsec_Service/api"
        globals.set(urlBase, forKey: "configUrlBase")
    }
    
    static func save(_ key: String) {
        switch key {
        case "configLoginUsername":
            globals.set(loginUsername, forKey: "configLoginUsername")
        case "configLoginPassword":
            globals.set(loginPassword, forKey: "configLoginPassword")
        case "configLoginSaveFlag":
            globals.set(loginSaveFlag, forKey: "configLoginSaveFlag")
        case "configUrlBase":
            globals.set(urlBase, forKey: "configUrlBase")
        default:
            break
        }
    }
    
    static func saveLogin(_ username: String, _ password: String) {
        globals.set(username, forKey: "configLoginUsername")
        globals.set(password, forKey: "configLoginPassword")
        loginUsername = username
        loginPassword = password
    }
}
