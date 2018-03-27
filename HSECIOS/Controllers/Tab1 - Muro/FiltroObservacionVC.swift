import UIKit
import DropDown
import DatePickerDialog

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
    
    let dropdown = DropDown()
    let datePicker = DatePickerDialog()
    
    var data: [String:String] = [:]
    var chosenFechaInicio = Date()
    var chosenFechaFin = Date()
    var chosenPersona: Persona = Persona()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campoCodigo.delegate = self
        datePicker.datePicker.locale = Locale.init(identifier: "Es-es")
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
    
    func showDropdown(_ boton: UIButton, _ dropDatasource: [String], _ labelDict: String, _ resultDatasource: [String]) {
        self.view.endEditing(true)
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = dropDatasource
        dropdown.selectionAction = { (index, item) in
            boton.setTitle(item, for: .normal)
            self.data[labelDict] = resultDatasource[index]
            if boton == self.campoGerencia {
                self.campoSuperintendencia.setTitle("-", for: .normal)
                self.data["Superint"] = ""
            }
            print(index)
            print(item)
            print(self.data)
        }
        dropdown.show()
    }
    
    func showDatePicker(_ title: String, _ boton: UIButton, min: Date?, max: Date?) {
        datePicker.show(title, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", defaultDate: Date(), minimumDate: min, maximumDate: max, datePickerMode: .date, callback: { (date) in
            if let newdate = date {
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                switch title {
                case "Fecha Inicio":
                    self.chosenFechaInicio = newdate
                    self.data["FechaInicio"] = Utils.date2str(newdate, "YYYY-MM-dd")
                    break
                case "Fecha Fin":
                    self.chosenFechaFin = newdate
                    self.data["FechaFin"] = Utils.date2str(newdate, "YYYY-MM-dd")
                    break
                default:
                    break
                }
            }
        })
    }
    
    func savePersona(_ persona: Persona) {
        chosenPersona = persona
        campoObservadoPor.text = persona.Nombres
        data["ObservadoPor"] = persona.CodPersona
    }
    
    @IBAction func clickEnArea(_ sender: Any) {
        showDropdown(campoArea, Globals.gArrayObsArea[1], "CodAreaHSEC", Globals.gArrayObsArea[0])
    }
    
    @IBAction func clickEnTipo(_ sender: Any) {
        showDropdown(campoTipo, Globals.gArrayObsTipo[1], "CodTipo", Globals.gArrayObsTipo[0])
    }
    
    @IBAction func clickEnRiesgo(_ sender: Any) {
        showDropdown(campoRiesgo, Globals.gArrayRiesgo[1], "CodNivelRiesgo", Globals.gArrayRiesgo[0])
    }
    
    @IBAction func clickEnFechaInicio(_ sender: Any) {
        showDatePicker("Fecha Inicio", campoFechaInicio, min: nil, max: chosenFechaFin)
    }
    
    @IBAction func clickEnFechaFin(_ sender: Any) {
        showDatePicker("Fecha Fin", campoFechaFin, min: chosenFechaInicio, max: nil)
    }
    
    @IBAction func clickEnGerencia(_ sender: Any) {
        showDropdown(campoGerencia, Globals.gArrayGerencia[1], "Gerencia", Globals.gArrayGerencia[0])
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        var arrayForLabel:[String] = []
        var arrayForValue:[String] = []
       
        if let gerencia = self.data["Gerencia"] {
            if let array = Globals.gArraySuperintendencia[gerencia] {
                arrayForLabel = array[1]
                arrayForValue = array[0]
            }
        }
        showDropdown(campoSuperintendencia, arrayForLabel, "Superint", arrayForValue)
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        Helper.postData(Routes.forMuroSearchO(), data, true, vcontroller: self, success: {(dict: NSDictionary) in
            let data = Dict.toArrayMuroElement(dict)
            let vcs = self.navigationController!.viewControllers
            let previous = vcs[vcs.count - 2] as! MuroSearchVC
            previous.saveData(data)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            print(data)
        })
        //HMuro.filtrarData("Observaciones", data, vcontroller: self, success: successFiltro(_:), error: errorFiltro(_:))
    }
    
    func successFiltro(_ data: [MuroElement]) {
        let vcs = self.navigationController!.viewControllers
        let previous = vcs[vcs.count - 2] as! MuroSearchVC
        previous.saveData(data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print(data)
    }
    func errorFiltro(_ error: String) {
        print(error)
    }
}
