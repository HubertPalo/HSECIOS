import UIKit
import DropDown
import DatePickerDialog

class FiltroFacilitoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    var alFiltrar: ((_ data:[String:String]) -> Void)?
    var dataAFiltrar = FacilitoGD()
    var shouldReset = false
    var chosenFechaInicio: Date?
    var chosenFechaFin: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReset {
            self.shouldReset = false
            self.dataAFiltrar = FacilitoGD()
            self.dataAFiltrar.Observacion = "1"
            self.dataAFiltrar.Accion = "10"
            self.chosenFechaInicio = nil
            self.chosenFechaFin = nil
            self.tabla.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.setTitleAndImage("Reportes facilito/Filtro", Images.facilito)
        self.dataAFiltrar.Observacion = "1"
        self.dataAFiltrar.Accion = "10"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataAFiltrar.CodObsFacilito = textField.text
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1TextField
            celda.cajaTexto.delegate = self
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Tipo"
            var dato = Utils.searchMaestroStatic("TIPOFACILITO", self.dataAFiltrar.Tipo ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Estado"
            var dato = Utils.searchMaestroStatic("ESTADOFACILITO", self.dataAFiltrar.Estado ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto1Boton
            var dato = self.dataAFiltrar.RespAuxiliarDesc
            dato = dato == "" ? "XXXXXXXXXX" : dato
            celda.texto1.text = "Responsable"
            celda.texto2.text = dato
            celda.boton.tag = 0
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto1Boton
            var dato = self.dataAFiltrar.PersonaDesc
            dato = dato == "" ? "XXXXXXXXXX" : dato
            celda.texto1.text = "Creador"
            celda.texto2.text = dato
            celda.boton.tag = 1
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Gerencia"
            var dato = Utils.searchMaestroDescripcion("GERE", self.dataAFiltrar.CodPosicionGer ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Superintendencia"
            var dato = Utils.searchMaestroDescripcion("GERE.\(self.dataAFiltrar.CodPosicionGer ?? "")", self.dataAFiltrar.CodPosicionSup ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Fecha inicio"
            celda.boton.setTitle(self.chosenFechaInicio?.toString("YYYY-MM-dd") ?? "- SELECCIONE -", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Fecha fin"
            celda.boton.setTitle(self.chosenFechaFin?.toString("YYYY-MM-dd") ?? "- SELECCIONE -", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        
        case 1:
            Utils.showDropdown(boton, Utils.maestroStatic2["TIPOFACILITO"] ?? [], {(indice,item) in
                self.dataAFiltrar.Tipo = Utils.maestroStatic1["TIPOFACILITO"]?[indice]
                // self.dataAFiltrar.CodSubUbicacion = nil
                // self.tabla.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
            })
            // break
            /*Utils.showDropdown((sender as! UIButton), Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
             self.dataAFiltrar.CodNivelRiesgo = Utils.maestroStatic1["NIVELRIESGO"]?[index]
             })
             Utils.showDropdown(boton, Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
             self.dataAFiltrar.CodAreaHSEC = Utils.maestroCodTipo["AREA"]?[index]
             })*/
        case 2:
            Utils.showDropdown(boton, Utils.maestroStatic2["ESTADOFACILITO"] ?? [], {(indice,item) in
                self.dataAFiltrar.Tipo = Utils.maestroStatic1["ESTADOFACILITO"]?[indice]
                // self.dataAFiltrar.CodSubUbicacion = nil
                // self.tabla.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
            })
            /*Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(self.dataAFiltrar.CodUbicacion ?? "")"] ?? [], {(indice,item) in
                self.dataAFiltrar.CodSubUbicacion = Utils.maestroCodTipo["UBIC.\(self.dataAFiltrar.CodUbicacion ?? "")"]?[indice]
            })*/
        case 5:
            Utils.showDropdown(boton, Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
                self.dataAFiltrar.CodPosicionGer = Utils.maestroCodTipo["GERE"]?[index] ?? ""
                self.dataAFiltrar.CodPosicionSup = nil
                self.tabla.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
            })
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["SUPE.\(self.dataAFiltrar.CodPosicionGer ?? "")"] ?? [], {(index, item) in
                self.dataAFiltrar.CodPosicionSup = Utils.maestroCodTipo["SUPE.\(self.dataAFiltrar.CodPosicionGer ?? "")"]?[index] ?? ""
            })
        case 7:
            Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaInicio = date
                self.dataAFiltrar.FecCreacion = Utils.date2str(date, "YYYY-MM-dd")
            })
        case 8:
            Utils.openDatePicker("Fecha Fin", Date(), chosenFechaInicio, nil, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaFin = date
                self.dataAFiltrar.FechaFin = Utils.date2str(date, "YYYY-MM-dd")
            })
        default:
            break
        }
    }
    
    @IBAction func clickResponsableCreador(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            VCHelper.openFiltroPersona(self, {(persona) in
                self.dataAFiltrar.RespAuxiliarDesc = persona.Nombres
                self.dataAFiltrar.RespAuxiliar = persona.CodPersona
            })
        case 1:
            VCHelper.openFiltroPersona(self, {(persona) in
                self.dataAFiltrar.PersonaDesc = persona.Nombres
                self.dataAFiltrar.Persona = persona.CodPersona
            })
        default:
            break
        }
    }
    
    @IBAction func clickBuscar(_ sender: Any) {
        self.view.endEditing(true)
        self.dataAFiltrar.PersonaDesc = nil
        self.dataAFiltrar.RespAuxiliarDesc = nil
        let data = Dict.unitToParams(self.dataAFiltrar)
        self.alFiltrar?(data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        // print(data)
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
