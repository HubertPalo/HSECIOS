import  UIKit

class FacilitoElement: Codable {
    var CodObsFacilito: String?
    var Tipo: String?
    var Observacion: String?
    var Estado: String?
    var Empresa: String?
    var Editable: String?
    var Total: String?
    var Persona: String?
    var Fecha: String?
    var FechaFin: String?
    var UrlPrew: String?
    var UrlObs: String?
    var TiempoDiffMin: Int?
    
    func toMuroElement() -> MuroElement {
        let unit = MuroElement()
        unit.Codigo = self.CodObsFacilito
        unit.Tipo = self.Tipo
        unit.Area = nil
        unit.NivelR = nil
        unit.Fecha = self.Fecha
        unit.ObsPor = self.Persona
        unit.Comentarios = -10
        unit.Editable = self.Editable
        unit.Obs = self.Observacion
        unit.UrlPrew = self.UrlPrew
        unit.UrlObs = self.UrlObs
        unit.Empresa = self.Empresa
        unit.Estado = self.Estado
        return unit
    }
    
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

class FacilitoGD: Codable {
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
    var PersonaDesc: String? // Solo usado en filtro Facilito
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
    
    func copy() -> HistorialAtencionElement {
        let copia = HistorialAtencionElement()
        copia.Correlativo = self.Correlativo
        copia.CodObsFacilito = self.CodObsFacilito
        copia.FechaFin = self.FechaFin
        copia.Comentario = self.Comentario
        copia.Estado = self.Estado
        copia.Fecha = self.Fecha
        copia.Persona = self.Persona
        copia.UrlObs = self.UrlObs
        return copia
    }
    
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
