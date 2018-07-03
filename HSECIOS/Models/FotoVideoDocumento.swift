import UIKit
import DKImagePickerController

class Multimedia: Codable{
    var Correlativo: Int?
    var Url: String?
    var Tamanio: String?
    var TipoArchivo: String?
    var Descripcion: String?
    
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
    var nombre: String = ""
    var tamanho: String = ""
    var url: URL? = nil
    // var multimedia = Multimedia()
}

class FotoVideo: Multimedia {
    var esVideo = false
    var asset: DKAsset? = nil
    var nombre = ""
    var imagen: UIImage? = nil
    var imagenFull: UIImage? = nil
    // var multimedia = Multimedia()
}
