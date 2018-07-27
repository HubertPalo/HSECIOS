import UIKit

class Dict {
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static func dataToArray<Class: Codable>(_ data: Data) -> ArrayGeneral<Class> {
        do {
            let result: ArrayGeneral<Class> = try decoder.decode(ArrayGeneral<Class>.self, from: data)
            return result
        } catch {
            return ArrayGeneral<Class>()
        }
    }
    
    static func dataToUnit<Class: Codable>(_ data: Data) -> Class? {
        do {
            let result: Class = try decoder.decode(Class.self, from: data)
            return result
        } catch {
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
        return [:]
    }
}
