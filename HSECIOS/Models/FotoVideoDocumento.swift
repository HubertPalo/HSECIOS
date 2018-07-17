import UIKit
import DKImagePickerController

class Multimedia: Codable{
    var Correlativo: Int?
    var Url: String?
    var Tamanio: String?
    var TipoArchivo: String?
    var Descripcion: String?
    
    var multimediaData: Data? // Solo usado para upload
    
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
        resultado.esVideo = self.TipoArchivo == "TP02"
        return resultado
    }
}

class DocumentoGeneral: Multimedia {
    var data: NSData = NSData()
    var tamanho: String = ""
    var url: URL? = nil
    // var multimedia = Multimedia()
}

class FotoVideo: Multimedia {
    var esVideo = false
    var asset: DKAsset? = nil
    var imagen: UIImage? = nil
    var imagenFull: UIImage? = nil
    // var multimedia = Multimedia()
}
