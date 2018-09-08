import UIKit
import DropDown
import DatePickerDialog

class FiltroInspeccionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    var alFiltrar: ((_ data:[String:String]) -> Void)?
    var dataAFiltrar = InspeccionGD()
    var shouldReset = false
    var chosenFechaInicio: Date?
    var chosenFechaFin: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReset {
            self.shouldReset = false
            self.dataAFiltrar = InspeccionGD()
            self.dataAFiltrar.Elemperpage = 1
            self.dataAFiltrar.Pagenumber = 10
            self.chosenFechaInicio = nil
            self.chosenFechaFin = nil
            self.tabla.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.setTitleAndImage("Inspecciones/Filtro", Images.inspeccion)
        self.dataAFiltrar.Elemperpage = 1
        self.dataAFiltrar.Pagenumber = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataAFiltrar.CodInspeccion = textField.text
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
            celda.texto.text = "Fecha inicio"
            celda.boton.setTitle(self.chosenFechaInicio?.toString("YYYY-MM-dd") ?? "- SELECCIONE -", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Fecha fin"
            celda.boton.setTitle(self.chosenFechaFin?.toString("YYYY-MM-dd") ?? "- SELECCIONE -", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Gerencia"
            var dato = Utils.searchMaestroDescripcion("GERE", self.dataAFiltrar.Gerencia ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Superintendencia"
            var dato = Utils.searchMaestroDescripcion("GERE.\(self.dataAFiltrar.Gerencia ?? "")", self.dataAFiltrar.SuperInt ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Ubicación"
            var dato = Utils.searchMaestroDescripcion("AREA", self.dataAFiltrar.CodUbicacion ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Sub Ubicación"
            celda.boton.setTitle("asd", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto1Boton
            celda.texto1.text = "Contrata"
            celda.texto2.text = "XXXXXXXX"
            celda.boton.tag = 0
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto1Boton
            celda.texto1.text = "Observado por"
            celda.texto2.text = "XXXXXXXX"
            celda.boton.tag = 1
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 1:
            Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaInicio = date
                self.dataAFiltrar.Fecha = Utils.date2str(date, "YYYY-MM-dd")
            })
        case 2:
            Utils.openDatePicker("Fecha Fin", Date(), chosenFechaInicio, nil, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaFin = date
                self.dataAFiltrar.FechaP = Utils.date2str(date, "YYYY-MM-dd")
            })
        case 3:
            Utils.showDropdown(boton, Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
                self.dataAFiltrar.Gerencia = Utils.maestroCodTipo["GERE"]?[index] ?? ""
                self.dataAFiltrar.SuperInt = nil
                self.tabla.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
            })
        case 4:
            Utils.showDropdown(boton, Utils.maestroDescripcion["SUPE.\(self.dataAFiltrar.Gerencia ?? "")"] ?? [], {(index, item) in
                self.dataAFiltrar.SuperInt = Utils.maestroCodTipo["SUPE.\(self.dataAFiltrar.Gerencia ?? "")"]?[index] ?? ""
            })
        case 5:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC"] ?? [], {(indice,item) in
                self.dataAFiltrar.CodUbicacion = Utils.maestroCodTipo["UBIC"]?[indice]
                self.dataAFiltrar.CodSubUbicacion = nil
                self.tabla.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
            })
            // break
            /*Utils.showDropdown((sender as! UIButton), Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
                self.dataAFiltrar.CodNivelRiesgo = Utils.maestroStatic1["NIVELRIESGO"]?[index]
            })
            Utils.showDropdown(boton, Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
                self.dataAFiltrar.CodAreaHSEC = Utils.maestroCodTipo["AREA"]?[index]
            })*/
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(self.dataAFiltrar.CodUbicacion ?? "")"] ?? [], {(indice,item) in
                self.dataAFiltrar.CodSubUbicacion = Utils.maestroCodTipo["UBIC.\(self.dataAFiltrar.CodUbicacion ?? "")"]?[indice]
            })
            /*Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["TPOB"] ?? [], {(index, item) in
                self.dataAFiltrar.CodTipo = Utils.maestroCodTipo["TPOB"]?[index]
            })*/
        default:
            break
        }
    }
    
    @IBAction func clickContrataObservado(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            VCHelper.openFiltroContrata(self, {(data1,data2) in
                
            })
        case 1:
            VCHelper.openFiltroPersona(self, {(persona) in
                
            })
        default:
            break
        }
    }
    
    /*@IBAction func clickEnFechaInicio(_ sender: Any) {
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
    }*/
    
    @IBAction func clickBuscar(_ sender: Any) {
        self.view.endEditing(true)
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
