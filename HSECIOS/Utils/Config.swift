import UIKit

class Config {
    
    static let globals = UserDefaults.standard
    
    static var loginSaveFlag = false
    static var loginUsername = ""
    static var loginPassword = ""
    static var urlBase = ""
    
    
    
    static func initConfig() {
        loginSaveFlag = globals.bool(forKey: "configLoginSaveFlag")
        loginUsername = ""
        loginPassword = ""
        urlBase = ""
        
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
