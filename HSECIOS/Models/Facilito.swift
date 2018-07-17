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
    var CodObsFacilito: String?
    var Tipo: String?
    var CodPosicionGer: String?
    var CodPosicionSup: String?
    var UbicacionExacta: String?
    var Observacion: String?
    var Accion: String?
    var RespAuxiliar: String?
    var RespAuxiliarDesc: String? // Verificar
    var FecCreacion: String?
    var FechaFin: String?
    var Persona: String?
    var Estado: String?
}

class HistorialAtencionElement: Codable {
    var Correlativo: Int?
    var CodObsFacilito: String?
    var FechaFin: String?
    var Comentario: String?
    var Estado: String?
    var Fecha: String?
    var Persona: String?
    var UrlObs: String?
    
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
