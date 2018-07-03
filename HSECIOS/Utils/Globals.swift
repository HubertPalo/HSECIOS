import UIKit

class Globals {
    
    static func loadGlobals() {
        
        
        Utils.maestroStatic1["REFERENCIAPLAN"] = ["01", "02", "03", "04", "05", "06", "07", "08", "09"]
        Utils.maestroStatic2["REFERENCIAPLAN"] = ["Observaciones", "Inspecciones", "Incidentes", "IPERC", "Auditorias", "Simulacros", "Reuniones", "Comites", "Capacitaciones"]
        Utils.maestroStatic1["ESTADOPLAN"] = ["01", "02", "03", "04", "05"]
        Utils.maestroStatic2["ESTADOPLAN"] = ["Pendiente", "Atendido", "En Proceso", "Observado", "Cerrado"]
        Utils.maestroStatic1["TABLAS"] = ["TCOM", "THIG", "TINC", "TINS", "TIPE", "TOBS", "TREU", "TSIM", "TYOS", "TCAP", "TDETAINSP", "TDIPEAFEC", "TEAU", "TEIN", "THALL", "TINVEAFEC", "TSEC", "TSIM", "TTES", "OTROS"]
        Utils.maestroStatic2["TABLAS"] = ["Comites", "Higiene", "Incidentes", "Inspecciones", "IPERC", "Observaciones", "Reuniones", "Simulacro", "Yo Aseguro", "ActaAsistencia", "DetalleInspeccion", "DiasPerdidosAfectado", "EquipoAuditor", "EquipoInvestigacion", "Hallazgos", "InvestigaAfectado", "SecuenciaEvento", "Simulacro", "TestigoInvolucrado", "Otros"]
        
        Utils.maestroStatic1["TIPOFACILITO"] = ["A", "C"]
        Utils.maestroStatic2["TIPOFACILITO"] = ["Acción", "Condición"]
        Utils.maestroStatic1["ESTADOFACILITO"] = ["A", "O", "P", "S"]
        Utils.maestroStatic2["ESTADOFACILITO"] = ["Atendido", "Observado", "Pendiente", "Espera"]
        
        Utils.maestroStatic1["NIVELRIESGO"] = ["BA", "ME", "AL"]
        Utils.maestroStatic2["NIVELRIESGO"] = ["Baja", "Media", "Alta"]
        Utils.maestroStatic1["ACTOSUBESTANDAR"] = ["0001","0002","0003","0004","0005","0006","0007","0008","0009","0010","0011","0012","0013","0014","0015","0016","0017","0018","0019","0020","0021","0022","0023","0024","0025"]
        Utils.maestroStatic2["ACTOSUBESTANDAR"] = ["Operar equipos sin autorización","Operar  equipo a velocidad inadecuada","No Avisar","No Advertir","No Asegurar","Desactivar Dispositivos de Seguridad","Usar Equipos y Herramientas Defectuosos","Uso inadecuado o no uso de EPP","Cargar Incorrectamente","Ubicación Incorrecta","Levantar Incorrectamente","Posición Inadecuada para el Trabajo o la Tarea","Dar mantenimiento a equipo en operación","Jugar en el trabajo","Usar equipo inadecuadamente","Trabajo bajo la Influencia del Alcohol y/u otras Drogas","Maniobra incorrecta","Uso inapropiado de herramientas","Evaluación de riesgos deficiente por parte del personal","Control inadecuado de energía (bloqueo/etiquetado)","Instrumentos mal interpretados / mal leídos","Hechos de violencia","Exponerse a la línea de fuego","No uso de los 3 puntos de apoyo","Intento por realizar tareas múltiples en forma simultánea"]
        Utils.maestroStatic1["CONDICIONSUBESTANDAR"] = ["0027","0028","0029","0030","0031","0032","0033","0034","0035","0036","0037","0038","0039","0040","0041","0042","0043","0044","0045","0046","0047"]
        Utils.maestroStatic2["CONDICIONSUBESTANDAR"] = ["Protección inadecuada, defectuosa o inexistente","Paredes, techos, etc. inestables","Caminos, pisos, superficies inadecuadas","Equipo de protección personal inadecuado","Herramientas, Equipos, Materiales Defectuosos o sin calibración","Congestión o Acción Restringida","Alarmas, Sirenas, Sistemas de Advertencia Inadecuado  o defectuosos","Peligros de Incendio y Explosión","Limpieza y Orden deficientes","Exceso de Ruido","Exceso de Radiación","Temperaturas Extremas","Peligros ergonómicos","Excesiva o inadecuada iluminación","Ventilación Inadecuada","Condiciones Ambientales Peligrosas","Dispositivos de seguridad inadecuados / defectuosos","Sistemas y Equipos energizados","Productos químicos peligrosos","Altura desprotegida","Derrame"]
    }
}
