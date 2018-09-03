import UIKit
import Alamofire

class Rest {
    
    static func getDataGeneral(_ route: String, _ shouldBlock: Bool, success: @escaping (_  resultValue: Any?, _ data: Data?) -> Void, error: ((_ error: String) -> Void)? ) {
        //print(route)
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.request(route, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    success(response.result.value, response.data)
                default:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    error?("\(status)")
                }
            } else {
                if shouldBlock {
                    Utils.desbloquearPantalla()
                }
                error?("Error")
            }
        }
    }
    
    static func postDataGeneral(_ route: String, _ parameters: [String:String], _ shouldBlock: Bool, success: @escaping (_ resultValue: Any?, _ data: Data?) -> Void, error: ((_ error: String) -> Void)?) {
        print(route)
        print(parameters)
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Utils.getHeader()).responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    success(response.result.value, response.data)
                default:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    error?("\(status)")
                }
            } else {
                if shouldBlock {
                    Utils.desbloquearPantalla()
                }
                error?("Error")
            }
        }
    }
    
    static func uploadMultimediaFor(_ nroDocReferencia: String, _ codTabla: String, _ grupoPertenece: String, _ files: [FotoVideo]) {
        
        var imagenes: [UIImage] = []
        var imagenesNombres: [String] = []
        
        for i in 0..<files.count {
            imagenesNombres.append(files[i].nombre)
            if files[i].imagenFull != nil {
                imagenes.append(files[i].imagenFull!)
            } else if files[i].imagen != nil {
                imagenes.append(files[i].imagen!)
            }
        }
        
        // terminar la subida de imagenes
        postData(Routes.forPostMultimedia(), [["NroDocReferencia",nroDocReferencia], ["CodTabla", codTabla], ["GrupoPertenece", grupoPertenece]], imagenes, imagenesNombres, false, vcontroller: UIViewController(), success: {(data) in
            print(data)
        }, error: {(error) in
            print(error)
        })
        /*postData(Routes.forLogin(), [["username","admin"], ["password", "Tintaya123."], ["domain", "anyaccess"]], [], [], false, vcontroller: UIViewController(), success: {(data) in
            print(data)
        }, error: {(error) in
            print(error)
        })*/
    }
    
    static func postMultipartFormData(_ route: String, params: [[String]], _ images: [UIImage], _ shouldBlock: Bool, success: @escaping (_ resultValue: Any?, _ data: Data?)-> Void, error: ((_ error:String) -> Void)?) {
        print(route)
        print(params)
        // Ejemplo params: [["data1", "valorData1"], ["data2", "valorData2"]]
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            for i in 0..<params.count {
                multipartFormData.append(params[i][1].data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: params[i][0])
            }
            for i in 0..<images.count {
                let dataImagen = Images.imageToDataCompressed(images[i])
                multipartFormData.append(dataImagen, withName: "name-\(i)", fileName: "filename-\(i).jpg", mimeType: "image/jpg")
            }
        }, usingThreshold: UInt64(), to: route, method: HTTPMethod.post, headers: Utils.getHeader(), encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _) :
                uploadRequest.responseJSON(completionHandler: {(response) in
                    if let status = response.response?.statusCode {
                        switch status {
                        case 200:
                            if shouldBlock {
                                Utils.desbloquearPantalla()
                            }
                            success(response.result.value, response.data)
                        default:
                            if shouldBlock {
                                Utils.desbloquearPantalla()
                            }
                            error?("\(status)")
                        }
                    } else {
                        if shouldBlock {
                            Utils.desbloquearPantalla()
                        }
                        error?("Error")
                    }
                })
            case .failure(let uploadError) :
                if shouldBlock {
                    Utils.desbloquearPantalla()
                }
                error?(uploadError.localizedDescription)
            default :
                // Nunca deberia ingresar aqui, pero por si acaso...
                if shouldBlock {
                    Utils.desbloquearPantalla()
                }
                print("Encoding Result - Case Default")
            }
        })
    }
    
    static func postData(_ route: String, _ parameters: [[String]], _ images: [UIImage], _ imageNames: [String], _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ str: String)-> Void, error: @escaping (_ str: String)-> Void) {
        print(route)
        print(parameters)
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            for i in 0..<parameters.count {
                multipartFormData.append(parameters[i][1].data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: parameters[i][0])
            }
            // multipartFormData.append(UIImageJPEGRepresentation(Images.unchecked!, 1.0)!, withName: "fileset", fileName: "hola2.jpg", mimeType: "image/jpg")
            for i in 0..<images.count {
                let dataImagen = Images.imageToDataCompressed(images[i])
                multipartFormData.append(dataImagen, withName: imageNames[i], fileName: imageNames[i], mimeType: "image/jpg")
                /*multipartFormData.append(imageData, withName: imageNames[i], mimeType: "image/jpeg")
                multipartFormData.append(imageData, withName: imageNames[i], fileName: imageNames[i], mimeType: "image/png")*/
            }
        }, usingThreshold: UInt64(), to: route, method: HTTPMethod.post, headers: Utils.getHeader(), encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: let streamingFromDisk, streamFileURL: let _) :
                uploadRequest.responseJSON(completionHandler: {(response) in
                    
                    print("Final final")
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(String.init(data: response.data!, encoding: String.Encoding.utf8))
                    print(response.result)   // result of response serialization
                    print(response.response?.allHeaderFields)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                })
                print("Final de la codificacion")
                print("Encoding Result - Case Success")
                print("Encoding Result - uploadRequest : \(uploadRequest)")
                print("Encoding Result - streamingFromDisk : \(streamingFromDisk)")
                //print("Encoding Result - streamFileURL : \(streamFileURL.absoluteString ?? "nil")")
                
            case .failure(let uploadError) :
                print("Encoding Result - Case Failure")
                print("Encoding Result - uploadError : \(uploadError.localizedDescription)")
                error(uploadError.localizedDescription)
            default :
                print("Encoding Result - Case Default")
            }
        })
        // Utils.bloquearPantalla(vcontroller, shouldBlock)
        
    }
    
    static func postData2(_ route: String, _ parameters: [String:String], _ images: [UIImage], _ imageNames: [String], _ shouldBlock: Bool, vcontroller: UIViewController, success: @escaping (_ str: String)-> Void) {
        print(route)
        print(parameters)
        /*if shouldBlock {
            Utils.bloquearPantalla()
        }*/
        // Utils.bloquearPantalla(vcontroller, shouldBlock)
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            var newParams = parameters
            while !newParams.isEmpty {
                var pair = newParams.popFirst()
                multipartFormData.append(pair!.value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: pair!.key)
            }
            for i in 0..<images.count {
                if let imageData = UIImagePNGRepresentation(images[i]) {
                    
                    //multipartFormData.append(imageData, withName: imageNames[i])
                    multipartFormData.append(imageData, withName: imageNames[i], mimeType: "image/jpeg")
                    multipartFormData.append(imageData, withName: imageNames[i], fileName: imageNames[i], mimeType: "image/png")
                } else {
                    print("No se pudo tranformar imagen")
                }
            }
            
        }, to: route, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: let streamingFromDisk, streamFileURL: let streamFileURL) :
                uploadRequest.responseJSON(completionHandler: {(response) in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                })
                print("Encoding Result - Case Success")
                print("Encoding Result - uploadRequest : \(uploadRequest)")
                print("Encoding Result - streamingFromDisk : \(streamingFromDisk)")
                //print("Encoding Result - streamFileURL : \(streamFileURL.absoluteString ?? "nil")")
                
            case .failure(let uploadError) :
                print("Encoding Result - Case Failure")
                print("Encoding Result - uploadError : \(uploadError.localizedDescription)")
            default :
                print("Encoding Result - Case Default")
            }
        })
    }
}
