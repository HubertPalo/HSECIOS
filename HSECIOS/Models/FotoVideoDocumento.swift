import UIKit
import DKImagePickerController

class Multimedia: Codable{
    var Correlativo: Int?
    var Url: String?
    var Tamanio: String?
    var TipoArchivo: String?
    var Descripcion: String?
    
    var multimediaData: Data? // Solo usado para UPLOAD
    var mimeType: String? // Solo usado para UPLOAD
    
    
    
    func setMimeType() {
        if let nombre = self.Descripcion {
            let nombreSplits = nombre.components(separatedBy: ".")
            if nombreSplits.count > 1 {
                switch nombreSplits[nombreSplits.count - 1].lowercased() {
                case "pdf":
                    self.mimeType = "application/pdf"
                    break
                case "doc":
                    self.mimeType = "application/msword"
                    break
                case "docx":
                    self.mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                    break
                case "xls":
                    self.mimeType = "application/vnd.ms-excel"
                    break
                case "xlsx":
                    self.mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    break
                case "ppt":
                    self.mimeType = "application/vnd.ms-powerpoint"
                    break
                case "pptx":
                    self.mimeType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
                    break
                case "mp4":
                    self.mimeType = "video/mp4"
                    break
                case "mov":
                    self.mimeType = "video/mp4"
                    break
                case "jpg":
                    self.mimeType = "image/jpg"
                    break
                case "png":
                    self.mimeType = "image/jpg"
                    break
                default:
                    self.mimeType = "application/octet-stream"
                    break
                }
            }
        }
    }
    
    func getMimeType() -> String { // Solo usado para upload
        if let nombre = self.Descripcion {
            let nombreSplits = nombre.components(separatedBy: ".")
            print(nombreSplits)
            if nombreSplits.count > 1 {
                switch nombreSplits[nombreSplits.count - 1].lowercased() {
                case "pdf":
                    return "application/pdf"
                case "doc":
                    return "application/msword"
                case "docx":
                    return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                case "xls":
                    return "application/vnd.ms-excel"
                case "xlsx":
                    return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                case "ppt":
                    return "application/vnd.ms-powerpoint"
                case "pptx":
                    return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
                case "mp4":
                    return "video/mp4"
                case "mov":
                    return "video/mp4"
                case "jpg":
                    return "image/jpg"
                case "png":
                    return "image/jpg"
                default:
                    break
                }
            }
        }
        return "application/octet-stream"
    }
    
    func getFileName() -> String { // Solo usado para upload
        if let nombre = self.Descripcion {
            let nombreSplits = nombre.components(separatedBy: ".")
            if nombreSplits.count > 1 {
                switch nombreSplits[nombreSplits.count - 1].lowercased() {
                case "pdf":
                    return nombreSplits.joined(separator: ".")
                case "doc":
                    return nombreSplits.joined(separator: ".")
                case "docx":
                    return nombreSplits.joined(separator: ".")
                case "xls":
                    return nombreSplits.joined(separator: ".")
                case "xlsx":
                    return nombreSplits.joined(separator: ".")
                case "ppt":
                    return nombreSplits.joined(separator: ".")
                case "pptx":
                    return nombreSplits.joined(separator: ".")
                case "mp4":
                    return nombreSplits.joined(separator: ".")
                case "mov":
                    var nombre = ""
                    for i in 0..<(nombreSplits.count - 1) {
                        nombre += nombreSplits[i]
                    }
                    return "\(nombre).mp4"
                case "jpg":
                    return nombreSplits.joined(separator: ".")
                case "png":
                    var nombre = ""
                    for i in 0..<(nombreSplits.count - 1) {
                        nombre += nombreSplits[i]
                    }
                    return "\(nombre).jpg"
                default:
                    break
                }
            }
        }
        return "application/octet-stream"
    }
    
    func toDocumentoGeneral() -> DocumentoGeneral{
        let resultado = DocumentoGeneral()
        resultado.Correlativo = self.Correlativo
        resultado.Url = self.Url
        resultado.Tamanio = self.Tamanio
        resultado.TipoArchivo = self.TipoArchivo
        resultado.Descripcion = self.Descripcion
        return resultado
    }
    func toFotoVideo() -> FotoVideo{
        let resultado = FotoVideo()
        resultado.Correlativo = self.Correlativo
        resultado.Url = self.Url
        resultado.Tamanio = self.Tamanio
        resultado.TipoArchivo = self.TipoArchivo
        resultado.Descripcion = self.Descripcion
        return resultado
    }
}

class DocumentoGeneral: Multimedia {
    var data: NSData = NSData()
    var tamanho: String = ""
    var url: URL?
    
    func getIcon() -> UIImage {
        let nombre = (self.Descripcion ?? "").uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if nombre.hasSuffix(".PDF") {
            return UIImage.init(named: "pdf") ?? Images.blank
        }
        if nombre.hasSuffix(".DOC") || nombre.hasSuffix(".DOCX") {
            return UIImage.init(named: "doc") ?? Images.blank
        }
        if nombre.hasSuffix(".XLS") || nombre.hasSuffix(".XLSX") {
            return UIImage.init(named: "xlsx") ?? Images.blank
        }
        if nombre.hasSuffix(".PPT") || nombre.hasSuffix(".PPTX") {
            return UIImage.init(named: "ppt") ?? Images.blank
        }
        return Images.blank
    }
}

class FotoVideo: Multimedia {
    var asset: DKAsset? = nil
    var imagen: UIImage? = nil
    var imagenFull: UIImage? = nil
    
    func copy() -> FotoVideo {
        let copia = FotoVideo()
        copia.Correlativo = self.Correlativo
        copia.Url = self.Url
        copia.Tamanio = self.Tamanio
        copia.TipoArchivo = self.TipoArchivo
        copia.Descripcion = self.Descripcion
        
        copia.multimediaData = self.multimediaData
        copia.mimeType = self.mimeType
        
        copia.asset = self.asset
        copia.imagen = self.imagen
        copia.imagenFull = self.imagenFull
        return copia
    }
}
