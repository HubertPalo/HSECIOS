import UIKit

class FiltroObservacionVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var campoCodigo: UITextField!
    @IBOutlet weak var campoArea: UIButton!
    @IBOutlet weak var campoTipo: UIButton!
    @IBOutlet weak var campoRiesgo: UIButton!
    @IBOutlet weak var campoFechaInicio: UIButton!
    @IBOutlet weak var campoFechaFin: UIButton!
    @IBOutlet weak var campoGerencia: UIButton!
    @IBOutlet weak var campoSuperintendencia: UIButton!
    @IBOutlet weak var campoObservadoPor: UILabel!
    
    var alFiltrar: ((_ data: [String:String]) -> Void)?
    
    var data: [String:String] = [:]
    var chosenFechaInicio = Date()
    var chosenFechaFin = Date()
    var chosenPersona: Persona = Persona()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campoCodigo.delegate = self
        // datePicker.datePicker.locale = Locale.init(identifier: "Es-es")
        data["Lugar"] = "1"
        data["CodUbicacion"] = "10"
        Utils.setButtonStyle(to: campoArea)
        Utils.setButtonStyle(to: campoSuperintendencia)
        Utils.setButtonStyle(to: campoGerencia)
        Utils.setButtonStyle(to: campoFechaFin)
        Utils.setButtonStyle(to: campoFechaInicio)
        Utils.setButtonStyle(to: campoTipo)
        Utils.setButtonStyle(to: campoRiesgo)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func editCodigo(_ sender: Any) {
        data["CodObservacion"] = campoCodigo.text!
        print(data)
    }
    
    
    func savePersona(_ persona: Persona) {
        chosenPersona = persona
        campoObservadoPor.text = persona.Nombres
        data["ObservadoPor"] = persona.CodPersona
    }
    
    @IBAction func clickEnArea(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
            self.data["CodAreaHSEC"] = Utils.maestroCodTipo["AREA"]?[index] ?? ""
        })
        // showDropdown(campoArea, Globals.gArrayObsArea[1], "CodAreaHSEC", Globals.gArrayObsArea[0])
    }
    
    @IBAction func clickEnTipo(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["TPOB"] ?? [], {(index, item) in
            self.data["CodTipo"] = Utils.maestroCodTipo["TPOB"]?[index] ?? ""
        })
        // showDropdown(campoTipo, Globals.gArrayObsTipo[1], "CodTipo", Globals.gArrayObsTipo[0])
    }
    
    @IBAction func clickEnRiesgo(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
            self.data["CodNivelRiesgo"] = Utils.maestroStatic1["NIVELRIESGO"]?[index] ?? ""
        })
        // showDropdown(campoRiesgo, Globals.gArrayRiesgo[1], "CodNivelRiesgo", Globals.gArrayRiesgo[0])
    }
    
    @IBAction func clickEnFechaInicio(_ sender: Any) {
        Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaInicio = newdate
                self.data["FechaInicio"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        //showDatePicker("Fecha Inicio", campoFechaInicio, min: nil, max: chosenFechaFin)
    }
    
    @IBAction func clickEnFechaFin(_ sender: Any) {
        Utils.openDatePicker("Fecha Fin", Date(), chosenFechaInicio, nil, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaFin = newdate
                self.data["FechaFin"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        //showDatePicker("Fecha Fin", campoFechaFin, min: chosenFechaInicio, max: nil)
    }
    
    @IBAction func clickEnGerencia(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
            self.data["Gerencia"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            self.campoSuperintendencia.setTitle("-", for: .normal)
            self.data["Superint"] = ""
        })
        //showDropdown(campoGerencia, Globals.gArrayGerencia[1], "Gerencia", Globals.gArrayGerencia[0])
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        let gerenciaSeleccionada = self.data["Gerencia"] ?? ""
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["SUPE.\(gerenciaSeleccionada)"] ?? [], {(index, item) in
            self.data["Superint"] = Utils.maestroCodTipo["SUPE.\(gerenciaSeleccionada)"]?[index] ?? ""
        })
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        self.alFiltrar?(data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
