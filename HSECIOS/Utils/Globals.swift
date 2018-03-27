import UIKit

class Globals {
    
    static var obsArea: [String:String] = [:]
    static var obsTipo: [String:String] = [:]
    static var obsRiesgo: [String:String] = [:]
    static var obsEstado: [String:String] = [:]
    
    static var insTipo: [String:String] = [:]
    
    static var gArrayObsArea: [[String]] = [[]]
    static var gArrayObsTipo: [[String]] = [[]]
    static var gArrayRiesgo: [[String]] = [[]]
    static var gArrayEstado: [[String]] = [[]]
    
    static var gArrayGerencia: [[String]] = [[]]
    static var gArraySuperintendencia: [String:[[String]]] = [:]
    static var gArrayUbicaciones: [[String]] = [[]]
    static var gArraySubUbicaciones: [String:[[String]]] = [:]
    static var gArrayUbicacionesEsp: [String:[String:[[String]]]] = [:]
    
    static var gUbicaciones: [String:String] = [:]
    static var gSubUbicaciones: [String:[String: String]] = [:]
    static var gUbicacionesEsp: [String:[String:[String:String]]] = [:]
    static var gGerencia: [String:String] = [:]
    static var gSuperintendencia: [String:[String:String]] = [:]
    
    static func obtainGArray(from: [String:String]) -> [[String]] {
        return [[String].init(from.keys), [String].init(from.values)]
    }
    static func obtainGArray(from: [String:[String:String]]) -> [String:[[String]]] {
        var dict: [String: [[String]]] = [:]
        let list = [String].init(from.keys)
        for i in 0..<list.count {
            dict[list[i]] = [[String].init(from[list[i]]!.keys), [String].init(from[list[i]]!.values)]
        }
        return dict
    }
    
    static func obtainGArray(from: [String:[String:[String:String]]]) -> [String:[String:[[String]]]] {
        var dict: [String:[String: [[String]]]] = [:]
        let list1 = [String].init(from.keys)
        for i in 0..<list1.count {
            let list2 = [String].init(from[list1[i]]!.keys)
            if dict[list1[i]] == nil {
                dict[list1[i]] = [:]
            }
            for j in 0..<list2.count {
                dict[list1[i]]![list2[j]] = [[String].init(from[list1[i]]![list2[j]]!.keys), [String].init(from[list1[i]]![list2[j]]!.values)]
            }
            
        }
        return dict
    }
    
    static func separateSemicolon(_ str: String) -> String {
        let splits = str.split(separator: ";")
        if splits.count == 1 {
            return str
        } else if splits.count == 2 {
            return String(splits[1])
        } else {
            var substring = String(splits[1])
            for i in 2..<splits.count {
                substring.append(contentsOf: splits[i])
            }
            return substring
        }
    }
    
    static func separateDot(_ str: String) -> [String] {
        let splits = str.split(separator: ".")
        var array: [String] = []
        for i in 0..<splits.count {
            array.append(String(splits[i]))
        }
        return array
    }
    
    static func decode(_ str: String, _ tipo: String) -> String {
        var value: String = "-"
        switch tipo {
        case "G"://Gerencia
            if let val = gGerencia[str] {
                value = separateSemicolon(val)
            }
            break
        case "S"://Superintendencia
            let splits = separateDot(str)
            if splits.count == 2 && gSuperintendencia[splits[0]] != nil && gSuperintendencia[splits[0]]![splits[1]] != nil {
                value = separateSemicolon(gSuperintendencia[splits[0]]![splits[1]]!)
            }
            break
        case "UB"://Ubicacion
            let splits = separateDot(str)
            if let val = gUbicaciones[splits[0]] {
                value = separateSemicolon(val)
            }
            break
        case "SU"://SubUbicacion
            let splits = separateDot(str)
            if splits.count > 1 && gSubUbicaciones[splits[0]] != nil && gSubUbicaciones[splits[0]]![splits[1]] != nil {
                value = separateSemicolon(gSubUbicaciones[splits[0]]![splits[1]]!)
            }
            break
        case "UE"://UbicacionEspecifica
            let splits = separateDot(str)
            if splits.count > 2 && gUbicacionesEsp[splits[0]] != nil && gUbicacionesEsp[splits[0]]![splits[1]] != nil && gUbicacionesEsp[splits[0]]![splits[1]]![splits[2]] != nil {
                value = separateSemicolon(gUbicacionesEsp[splits[0]]![splits[1]]![splits[2]]!)
            }
            break
        default:
            break
        }
        return value
    }
    
    static func needsUpdate(_ config: String) -> Bool {
        return true
        var flag = false
        switch config {
        case "Ubicaciones":
            if let dict = UserDefaults.standard.dictionary(forKey: "HSEC_gUbicaciones") {
                gUbicaciones = dict as! [String : String]
            } else {
                flag = true
            }
            if let dict = UserDefaults.standard.dictionary(forKey: "HSEC_gSubUbicaciones") {
                gSubUbicaciones = dict as! [String:[String:String]]
            } else {
                flag = true
            }
            if let dict = UserDefaults.standard.dictionary(forKey: "HSEC_gUbicacionesEsp") {
                gUbicacionesEsp = dict as! [String:[String:[String:String]]]
            } else {
                flag = true
            }
            break
        case "Gerencia":
            if let dict = UserDefaults.standard.dictionary(forKey: "HSEC_gGerencia") {
                gGerencia = dict as! [String:String]
                gArrayGerencia = obtainGArray(from: gGerencia)
            } else {
                flag = true
            }
            break
        case "Superintendencia":
            if let dict = UserDefaults.standard.dictionary(forKey: "HSEC_gSuperintendencia") {
                gSuperintendencia = dict as! [String:[String:String]]
                gArraySuperintendencia = obtainGArray(from: gSuperintendencia)
            } else {
                flag = true
            }
            break
        default:
            break
        }
        return flag
    }
    
    static func updateUbicaciones(_ data: [Maestro]) {
        for i in 0..<data.count {
            let unit = data[i]
            let splits = unit.CodTipo.split(separator: ".")
            if splits.count == 3 {
                if gUbicacionesEsp[String(splits[0])] == nil {
                    gUbicacionesEsp[String(splits[0])] = [:]
                }
                if gUbicacionesEsp[String(splits[0])]![String(splits[1])] == nil {
                    gUbicacionesEsp[String(splits[0])]![String(splits[1])] = [:]
                }
                gUbicacionesEsp[String(splits[0])]![String(splits[1])]![String(splits[2])] = unit.Descripcion//"\(unit.CodTipo);\()"
            }
            if splits.count == 2 {
                if gSubUbicaciones[String(splits[0])] == nil {
                    gSubUbicaciones[String(splits[0])] = [:]
                }
                gSubUbicaciones[String(splits[0])]![String(splits[1])] = unit.Descripcion//"\(unit.CodTipo);\(unit.Descripcion)"
            }
            if splits.count == 1 {
                gUbicaciones[String(splits[0])] = unit.Descripcion//"\(unit.CodTipo);\(unit.Descripcion)"
            }
        }
        
        gArrayUbicaciones = obtainGArray(from: gUbicaciones)
        gArraySubUbicaciones = obtainGArray(from: gSubUbicaciones)
        gArrayUbicacionesEsp = obtainGArray(from: gUbicacionesEsp)
        
        UserDefaults.standard.set(gUbicaciones, forKey: "HSEC_gUbicaciones")
        UserDefaults.standard.set(gSubUbicaciones, forKey: "HSEC_gSubUbicaciones")
        UserDefaults.standard.set(gUbicacionesEsp, forKey: "HSEC_gUbicacionesEsp")
        
    }
    
    static func updateGerencia(_ data: [Maestro]) {
        for i in 0..<data.count {
            let unit = data[i]
            gGerencia[unit.CodTipo] = data[i].Descripcion//"\(unit.CodTipo);\(data[i].Descripcion)"
        }
        gArrayGerencia = obtainGArray(from: gGerencia)
        UserDefaults.standard.set(gGerencia, forKey: "HSEC_gGerencia")
    }
    
    static func updateSuperintendencia(_ data: [Maestro]) {
        for i in 0..<data.count {
            let unit = data[i]
            let splits = unit.CodTipo.split(separator: ".")
            if splits.count == 2 {
                if gSuperintendencia[String(splits[0])] == nil {
                    gSuperintendencia[String(splits[0])] = [:]
                }
                gSuperintendencia[String(splits[0])]![String(splits[1])] = unit.Descripcion//"\(unit.CodTipo);\(unit.Descripcion)"
            }
        }
        gArraySuperintendencia = obtainGArray(from: gSuperintendencia)
        UserDefaults.standard.set(gSuperintendencia, forKey: "HSEC_gSuperintendencia")
    }
    
    static func loadGlobals() {
        
        obsArea["001"] = "Seguridad"
        obsArea["002"] = "Salud Ocupacional"
        obsArea["004"] = "Comunidades"
        
        obsTipo["TO01"] = "Comportamiento"
        obsTipo["TO02"] = "Condición"
        obsTipo["TO03"] = "Tarea"
        obsTipo["TO04"] = "Interacción de  Seguridad (IS)"
        
        obsRiesgo["BA"] = "Baja"
        obsRiesgo["ME"] = "Media"
        obsRiesgo["AL"] = "Alta"
        
        obsEstado["01"] = "Prisa"
        obsEstado["02"] = "Frustracion"
        obsEstado["03"] = "Fatiga"
        obsEstado["04"] = "Exceso de confianza"
        obsEstado["05"] = "No aplica"
        
        insTipo["1"] = "Operativo"
        insTipo["2"] = "Gerencial"
        insTipo["3"] = "Comité"
        
        gArrayObsArea = obtainGArray(from: obsArea)
        gArrayObsTipo = obtainGArray(from: obsTipo)
        gArrayRiesgo = obtainGArray(from: obsRiesgo)
        gArrayEstado = obtainGArray(from: obsEstado)
    }
}
