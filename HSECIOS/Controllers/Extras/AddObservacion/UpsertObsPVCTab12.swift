import UIKit
import DropDown
import DatePickerDialog

class UpsertObsPVCTab12: UITableViewController {
    
    let dropdown = DropDown()
    let datePicker = DatePickerDialog()
    
    var data: [String:String] = ["Tipo":"TO01"]
    
    @IBOutlet weak var labelNombreCompleto: UILabel!
    
    @IBOutlet weak var botonFecha: UIButton!
    
    @IBOutlet weak var botonSubUbicacion: UIButton!
    
    @IBOutlet weak var botonUbicacionEsp: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickObservadoPor(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona) in
            self.labelNombreCompleto.text = persona.Nombres
            self.data["CodObservadoPor"] = persona.CodPersona
            print(self.data)
        })
    }
    
    @IBAction func clickTipo(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, ["Comportamiento", "Condición"], {(index, item) in
            let realValues = ["TO01", "TO02"]
            self.data["Tipo"] = realValues[index]
            let padre = self.parent as! UpsertObsPVC
            padre.tab1Tipo = realValues[index]
            print(self.data)
        })
    }
    
    @IBAction func clickArea(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
            let realValues = Utils.maestroCodTipo["AREA"] ?? []
            self.data["Area"] = realValues[index]
            print(self.data)
        })
    }
    
    @IBAction func clickNivelRiesgo(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
            let realValues = Utils.maestroStatic1["NIVELRIESGO"] ?? []
            self.data["NivelRiesgo"] = realValues[index]
            print(self.data)
        })
    }
    
    @IBAction func clickFecha(_ sender: Any) {
        let currentCalendar = Calendar.current
        let interval = currentCalendar.dateInterval(of: .month, for: Date())
        let endDate = currentCalendar.date(byAdding: .day, value: -1, to: interval!.end)
        Utils.openDatePicker("Seleccione Fecha", Date(), interval?.start, endDate, chandler: {(date) in
            self.data["Fecha"] = Utils.date2str(date)
            self.botonFecha.setTitle(Utils.date2str(date), for: .normal)
            print(self.data)
        })
    }
    
    @IBAction func clickUbicacion(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["UBIC"] ?? [], {(index, item) in
            let realValues = Utils.maestroCodTipo["UBIC"] ?? []
            self.data["TempUbicacion"] = realValues[index]
            self.data["SubUbicacion"] = nil
            self.data["UbicacionEspecifica"] = nil
            self.botonSubUbicacion.setTitle(" - Seleccione - ", for: .normal)
            self.botonUbicacionEsp.setTitle(" - Seleccione - ", for: .normal)
            print(self.data)
        })
    }
    
    @IBAction func clickSubUbicacion(_ sender: Any) {
        let ubicDesc = "UBIC.\(self.data["TempUbicacion"] ?? "")"
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion[ubicDesc] ?? [], {(index, item) in
            let realValues = Utils.maestroCodTipo[ubicDesc] ?? []
            self.data["SubUbicacion"] = realValues[index]
            self.data["UbicacionEspecifica"] = nil
            self.botonUbicacionEsp.setTitle(" - Seleccione - ", for: .normal)
            print(self.data)
        })
    }
    
    @IBAction func clickUbicacionEspecifica(_ sender: Any) {
        let ubicDesc = "UBIC.\(self.data["TempUbicacion"] ?? "").\(self.data["SubUbicacion"] ?? "")"
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion[ubicDesc] ?? [], {(index, item) in
            let realValues = Utils.maestroCodTipo[ubicDesc] ?? []
            self.data["UbicacionEspecifica"] = realValues[index]
            print(self.data)
        })
    }
    
    
    
}
