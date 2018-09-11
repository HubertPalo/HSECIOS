import UIKit

class Dict {
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static func dataToArray<Class: Codable>(_ data: Data) -> ArrayGeneral<Class> {
        do {
            let result: ArrayGeneral<Class> = try decoder.decode(ArrayGeneral<Class>.self, from: data)
            return result
        } catch {
            print("Error\n\(error)")
            return ArrayGeneral<Class>()
        }
    }
    
    static func dataToUnit<Class: Codable>(_ data: Data) -> Class? {
        do {
            let result: Class = try decoder.decode(Class.self, from: data)
            return result
        } catch {
            print("Error\n\(error)")
            return nil
        }
    }
    
    static func unitToData<Class: Codable>(_ objeto: Class) -> Data? {
        do {
            let result = try encoder.encode(objeto)
            return result
        } catch {
            return nil
        }
    }
    
    static func unitToParams<Class: Codable>(_ objeto: Class) -> [String:String] {
        if let unit = objeto as? PlanAccionDetalle {
            let temp: Int? = unit.NroAccionOrigen
            unit.NroAccionOrigen = nil
            var respuesta: [String:String] = Dict.dataToUnit(Dict.unitToData(unit)!)!
            respuesta["NroAccionOrigen"] = temp == nil ? nil : "\(temp!)"
            return respuesta
        }
        if let unit = objeto as? AccionMejoraAtencion {
            let temp: Int? = unit.Correlativo
            unit.Correlativo = nil
            var respuesta: [String:String] = Dict.dataToUnit(Dict.unitToData(unit)!)!
            respuesta["Correlativo"] = temp == nil ? nil : "\(temp!)"
            return respuesta
        }
        if let unit = objeto as? InspeccionGD {
            var temp: Int? = unit.Elemperpage
            var temp2: Int? = unit.Pagenumber
            unit.Elemperpage = nil
            unit.Pagenumber = nil
            var respuesta: [String:String] = Dict.dataToUnit(Dict.unitToData(unit)!)!
            respuesta["Elemperpage"] = temp == nil ? nil : "\(temp!)"
            respuesta["Pagenumber"] = temp2 == nil ? nil : "\(temp2!)"
            return respuesta
        }
        return Dict.dataToUnit(Dict.unitToData(objeto)!)!
    }
}
