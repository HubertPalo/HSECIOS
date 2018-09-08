import UIKit
import Alamofire

class Rest {
    
    static var requestFlags = Set<Int>()
    
    static var requests: [Int:Alamofire.Request] = [:]
    
    static func generateId() -> Int {
        var newId = arc4random_uniform(2000)
        while requestFlags.contains(Int(newId)) {
            newId = arc4random_uniform(2000)
        }
        return Int(newId)
    }
    
    static func getDataGeneral(_ route: String, _ shouldBlock: Bool, success: @escaping (_  resultValue: Any?, _ data: Data?) -> Void, error: ((_ error: String) -> Void)? ) {
        print(route)
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
                case 401:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    Rest.postDataGeneral(Routes.forLogin(), ["username":Utils.loginUsr, "password":Utils.loginPwd, "domain":"anyaccess", "token": Utils.FCMToken], shouldBlock, success: {(resultValueToken:Any?,dataToken:Data?) in
                        Utils.token = resultValueToken as! String
                        Rest.getDataGeneral(route, shouldBlock, success: success, error: error)
                    }, error: {(errorToken) in
                        error?(errorToken)
                    })
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
                case 401:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    Rest.postDataGeneral(Routes.forLogin(), ["username":Utils.loginUsr, "password":Utils.loginPwd, "domain":"anyaccess", "token": Utils.FCMToken], shouldBlock, success: {(resultValueToken:Any?,dataToken:Data?) in
                        Utils.token = resultValueToken as! String
                        Rest.postDataGeneral(route, parameters, shouldBlock, success: success, error: error)
                    }, error: {(errorToken) in
                        error?(errorToken)
                    })
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
    
    /*static func postDataGeneralNoHeader(_ route: String, _ parameters: [String:String], _ shouldBlock: Bool, success: @escaping (_ resultValue: Any?, _ data: Data?) -> Void, error: ((_ error: String) -> Void)?) {
        print(route)
        print(parameters)
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
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
    }*/
    
    static func getDataGeneral(_ route: String, _ shouldBlock: Bool, success: @escaping (_  resultValue: Any?, _ data: Data?) -> Void, progress: ((_ progress: Double) -> Void)? , error: ((_ error: String) -> Void)? ) {
        print(route)
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.request(route, headers: Utils.getHeader()).downloadProgress(closure: {(progreso:Progress) in
            progress?(progreso.fractionCompleted)
        }).responseJSON { response in
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
    
    /*static func uploadMultimediaFor(_ nroDocReferencia: String, _ codTabla: String, _ grupoPertenece: String, _ files: [FotoVideo]) {
        var imagenes: [UIImage] = []
        var imagenesNombres: [String] = []
        
        for i in 0..<files.count {
            imagenesNombres.append(files[i].Descripcion ?? "")
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
    }*/
    
    static func downloadFileTo(_ filename: String, _ route: String, _ shouldBlock: Bool, _ id: Int, _ progresoHandler: ((_ :Double) -> Void)?, _ success: ((_ :DownloadResponse<Data>) -> Void)?, _ error: ((_ : String) -> Void)?) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(filename)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        self.requests[id] = Alamofire.download(route, to: destination).downloadProgress(closure: {(progress) in
            progresoHandler?(progress.fractionCompleted)
        }).validate().responseData(completionHandler: {(response) in
            if let status = response.response?.statusCode {
                switch status {
                case 200:
                    if shouldBlock {
                        Utils.desbloquearPantalla()
                    }
                    // response.destinationURL!.path
                    success?(response)
                    // success(response.result.value, response.data)
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
        
        /*Alamofire.download(route, to: destination)
            .downloadProgress { progress in
                progresoHandler?(progress.fractionCompleted)
                
            }.validate().responseData { ( response ) in
                print(response)
                self.docController = UIDocumentInteractionController(url: NSURL.fileURL(withPath: response.destinationURL!.path))
                
                self.docController?.delegate = self
                self.docController?.presentOptionsMenu(from: self.botonDescarga, animated: true)
                cargaProgreso.hide(animated: true)
        }*/
    }
    
    static func postMultipartFormData(_ route: String, params: [[String]], _ multipartData: [Data], _ name: [String], _ filename: [String], _ mimeType: [String], _ shouldBlock: Bool, _ id: Int, success: @escaping (_ resultValue: Any?, _ data: Data?)-> Void, progress: ((_ progress: Double) -> Void)?, error: ((_ error: String) -> Void)?) {
        print(route)
        print(params)
        self.requestFlags.insert(id)
        // Ejemplo params: [["data1", "valorData1"], ["data2", "valorData2"]]
        if shouldBlock {
            Utils.bloquearPantalla()
        }
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            for i in 0..<params.count {
                multipartFormData.append(params[i][1].data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: params[i][0])
            }
            for i in 0..<multipartData.count {
                // let dataImagen = Images.imageToDataCompressed(images[i])
                let dataImagen = multipartData[i]
                // print("Tamaño archivo: \(dataImagen.count)")
                print("Nombre archvo: \(filename[i]), tamaño: \(dataImagen.count), name: \(name[i]), mimetype: \(mimeType[i])")
                multipartFormData.append(dataImagen, withName: name[i], fileName: filename[i], mimeType: mimeType[i])
                
                /*if multimediaIsVideo[i] {
                    multipartFormData.append(dataImagen, withName: "name-\(i)", fileName: "filename-\(i).mp4", mimeType: "video/mp4")
                } else {
                    multipartFormData.append(dataImagen, withName: "name-\(i)", fileName: "filename-\(i).jpg", mimeType: "image/jpg")
                }*/
                
            }
            
        }, usingThreshold: UInt64(), to: route, method: HTTPMethod.post, headers: Utils.getHeader(), encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _) :
                uploadRequest.uploadProgress(closure: {(progreso) in
                    print(self.requestFlags)
                    if !self.requestFlags.contains(id) {
                        uploadRequest.cancel()
                    }
                    print(progreso.fractionCompleted)
                    progress?(progreso.fractionCompleted)
                })
                uploadRequest.responseJSON(completionHandler: {(response) in
                    self.requestFlags.remove(id)
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
                        print(response.result)
                        print(response.response?.statusCode)
                        if shouldBlock {
                            Utils.desbloquearPantalla()
                        }
                        error?("Error")
                    }
                })
            case .failure(let uploadError) :
                self.requestFlags.remove(id)
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
