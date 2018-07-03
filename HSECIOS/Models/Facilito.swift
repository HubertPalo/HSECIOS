import  UIKit

class FacilitoElement: Codable {
    var CodObsFacilito: String?
    var Tipo: String?
    var Observacion: String?
    var Estado: String?
    var Editable: String?
    var Total: String?
    var Persona: String?
    var Fecha: String?
    var FechaFin: String?
    var UrlPrew: String?
    var UrlObs: String?
    var TiempoDiffMin: Int?
    
    func printDescription(){
        let mirrored_object = Mirror(reflecting: self)
        let str:NSMutableString = NSMutableString()
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                str.append(" Attr \(index): \(property_name) = \(attr.value)")
            }
        }
        print(str as String)
    }
    
}

class FacilitoDetalle: Codable {
    var CodObsFacilito = ""
    var Tipo = ""
    var CodPosicionGer = ""
    var CodPosicionSup = ""
    var UbicacionExacta = ""
    var Observacion = ""
    var RespAuxiliar = ""
    var RespAuxiliarDesc = ""
    var Accion = ""
    var FecCreacion = ""
    var FechaFin = ""
    var Persona = ""
    var Estado = ""
}

class HistorialAtencionElement: Codable {
    var Correlativo = ""
    var CodObsFacilito = ""
    var FechaFin = ""
    var Comentario = ""
    var Estado = ""
    var Fecha = ""
    var Persona = ""
    var UrlObs = ""
    
    func printDescription(){
        let mirrored_object = Mirror(reflecting: self)
        let str:NSMutableString = NSMutableString()
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                str.append(" Attr \(index): \(property_name) = \(attr.value)")
            }
        }
        print(str as String)
    }
}
