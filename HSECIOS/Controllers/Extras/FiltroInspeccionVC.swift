import UIKit
import DropDown
import DatePickerDialog

class FiltroInspeccionVC: UIViewController {
    
    @IBOutlet weak var campoCodigo: UITextField!
    @IBOutlet weak var campoFechaInicio: UIButton!
    @IBOutlet weak var campoFechaFin: UIButton!
    @IBOutlet weak var campoGerencia: UIButton!
    @IBOutlet weak var campoSuperintendencia: UIButton!
    @IBOutlet weak var campoUbicacion: UIButton!
    @IBOutlet weak var campoSubUbicacion: UIButton!
    @IBOutlet weak var campoObservadoPor: UILabel!
    
    var alFiltrar: ((_ data:[String:String]) -> Void)?
    var data: [String:String] = [:]
    
    var chosenFechaInicio = Date()
    var chosenFechaFin = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data["Elemperpage"] = "10"
        data["Pagenumber"] = "1"
    }
    
    
    func savePersona(_ persona: Persona){
        campoObservadoPor.text = persona.Nombres
        data["CodTipo"] = persona.CodPersona
        print(data)
    }
    
    /*func showDropdown(_ boton: UIButton, _ dropDatasource: [String], _ labelDict: String, _ resultDatasource: [String]) {
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
            if boton == self.campoUbicacion {
                self.campoSubUbicacion.setTitle("-", for: .normal)
                self.data["CodSubUbicacion"] = ""
            }
            print(index)
            print(item)
            print(self.data)
        }
        dropdown.show()
    }*/
    
    /*func showDatePicker(_ title: String, _ boton: UIButton, min: Date?, max: Date?) {
        datePicker.show(title, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", defaultDate: Date(), minimumDate: min, maximumDate: max, datePickerMode: .date, callback: { (date) in
            if let newdate = date {
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                switch title {
                case "Fecha Inicio":
                    self.chosenFechaInicio = newdate
                    self.data["FechaP"] = Utils.date2str(newdate, "YYYY-MM-dd")
                    break
                case "Fecha Fin":
                    self.chosenFechaFin = newdate
                    self.data["Fecha"] = Utils.date2str(newdate, "YYYY-MM-dd")
                    break
                default:
                    break
                }
                
            }
        })
    }*/
    
    @IBAction func editCodigo(_ sender: Any) {
        data["CodInspeccion"] = campoCodigo.text!
    }
    
    @IBAction func clickEnFechaInicio(_ sender: Any) {
        Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaInicio = newdate
                self.data["FechaP"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        // showDatePicker("Fecha Inicio", campoFechaInicio, min: nil, max: chosenFechaFin)
    }
    
    @IBAction func clickEnFechaFin(_ sender: Any) {
        Utils.openDatePicker("Fecha Fin", Date(), nil, chosenFechaFin, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaInicio = newdate
                self.data["Fecha"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        // showDatePicker("Fecha Fin", campoFechaFin, min: chosenFechaInicio, max: nil)
    }
    
    @IBAction func clickEnGerencia(_ sender: Any) {
        // let boton = sender as! UIButton
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
            self.data["Gerencia"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            self.campoSuperintendencia.setTitle("-", for: .normal)
            self.data["Superint"] = ""
        })
        // showDropdown(campoGerencia, Globals.gArrayGerencia[1], "Gerencia", Globals.gArrayGerencia[0])
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        let gerenciaSeleccionada = self.data["Gerencia"] ?? ""
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["SUPE.\(gerenciaSeleccionada)"] ?? [], {(index, item) in
            self.data["Superint"] = Utils.maestroCodTipo["SUPE.\(gerenciaSeleccionada)"]?[index] ?? ""
        })
        /*var arrayForLabel:[String] = []
        var arrayForValue:[String] = []
        
        if let gerencia = self.data["Gerencia"] {
            if let array = Globals.gArraySuperintendencia[gerencia] {
                arrayForLabel = array[1]
                arrayForValue = array[0]
            }
        }
        showDropdown(campoSuperintendencia, arrayForLabel, "Superint", arrayForValue)*/
    }
    
    @IBAction func clickEnUbicacion(_ sender: Any) {
        /*dropdown.selectionAction = { (index, item) in
            boton.setTitle(item, for: .normal)
            self.data[labelDict] = resultDatasource[index]
            if boton == self.campoGerencia {
                self.campoSuperintendencia.setTitle("-", for: .normal)
                self.data["Superint"] = ""
            }
            if boton == self.campoUbicacion {
                self.campoSubUbicacion.setTitle("-", for: .normal)
                self.data["CodSubUbicacion"] = ""
            }
            print(index)
            print(item)
            print(self.data)
        }*/
        // showDropdown(campoUbicacion, Globals.gArrayUbicaciones[1], "CodUbicacion", Globals.gArrayUbicaciones[0])
    }
    
    @IBAction func clickEnSubUbicacion(_ sender: Any) {
        /*var arrayForLabel:[String] = []
        var arrayForValue:[String] = []
        
        if let ubicacion = self.data["CodUbicacion"] {
            if let array = Globals.gArraySubUbicaciones[ubicacion] {
                arrayForLabel = array[1]
                arrayForValue = array[0]
            }
        }
        showDropdown(campoSubUbicacion, arrayForLabel, "CodSubUbicacion", arrayForValue)*/
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        print(data)
        /*Rest.postData(Routes.forMuroSearchI(), data, true, vcontroller: self, success: {(dict: NSDictionary) in
            let data: [MuroElement] = Dict.toArrayMuroElement(dict)
            let vcs = self.navigationController!.viewControllers
            let previous = vcs[vcs.count - 2] as! MuroSearchVC
            previous.saveData(data)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            print(data)
        })*/
        
        
        // HMuro.filtrarData("Inspecciones", self.data, vcontroller: self, success: successFiltro(_:), error: errorFiltro(_:))
    }
    /*func successFiltro(_ data: [MuroElement]) {
        let vcs = self.navigationController!.viewControllers
        let previous = vcs[vcs.count - 2] as! MuroSearchVC
        previous.saveData(data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print(data)
    }
    func errorFiltro(_ error: String) {
        print(error)
    }*/
    
    
}
