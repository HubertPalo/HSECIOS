import UIKit

class FiltroObservacionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    var alFiltrar: ((_ data: [String:String]) -> Void)?
    var dataAFiltrar = ObservacionGD()
    var shouldReset = false
    var chosenFechaInicio: Date?
    var chosenFechaFin: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReset {
            self.shouldReset = false
            self.dataAFiltrar = ObservacionGD()
            self.dataAFiltrar.Lugar = "1"
            self.dataAFiltrar.CodUbicacion = "10"
            self.chosenFechaInicio = nil
            self.chosenFechaFin = nil
            self.tabla.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.setTitleAndImage("Observaciones/Filtro", Images.observacion)
        self.dataAFiltrar.Lugar = "1"
        self.dataAFiltrar.CodUbicacion = "10"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataAFiltrar.CodObservacion = textField.text
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
            celda.texto.text = "Área"
            var dato = Utils.searchMaestroDescripcion("AREA", self.dataAFiltrar.CodAreaHSEC ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Tipo"
            var dato = Utils.searchMaestroDescripcion("TPOB", self.dataAFiltrar.CodTipo ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Nivel de riesgo"
            var dato = Utils.searchMaestroStatic("NIVELRIESGO", self.dataAFiltrar.CodNivelRiesgo ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Fecha inicio"
            celda.boton.setTitle(self.chosenFechaInicio?.toString("YYYY-MM-dd") ?? "SELECCIONE FECHA", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Fecha fin"
            celda.boton.setTitle(self.chosenFechaFin?.toString("YYYY-MM-dd") ?? "SELECCIONE FECHA", for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Gerencia"
            var dato = Utils.searchMaestroDescripcion("GERE", self.dataAFiltrar.Gerencia ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Superintendencia"
            var dato = Utils.searchMaestroDescripcion("GERE.\(self.dataAFiltrar.Gerencia ?? "")", self.dataAFiltrar.Superint ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = indexPath.row
            celda.boton.titleLabel?.lineBreakMode = .byWordWrapping
            celda.boton.titleLabel?.numberOfLines = 2
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto
            var dato = self.dataAFiltrar.ObservadoPor ?? ""
            dato = dato == "" ? "XXXXXXXXXXXXXX" : dato
            celda.texto.text = dato
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 1:
            var data = ["- SELECCIONE -"]
            data.append(contentsOf: Utils.maestroDescripcion["AREA"] ?? [])
            Utils.showDropdown(boton, data, {(indice,item) in
                if indice == 0 {
                    self.dataAFiltrar.CodAreaHSEC = nil
                    return
                }
                self.dataAFiltrar.CodAreaHSEC = Utils.maestroCodTipo["AREA"]?[indice - 1]
            })
        case 2:
            var data = ["- SELECCIONE -"]
            data.append(contentsOf: Utils.maestroDescripcion["TPOB"] ?? [])
            Utils.showDropdown(boton, data, {(indice,item) in
                if indice == 0 {
                    self.dataAFiltrar.CodTipo = nil
                    return
                }
                self.dataAFiltrar.CodTipo = Utils.maestroCodTipo["TPOB"]?[indice - 1]
            })
        case 3:
            var data = ["- SELECCIONE -"]
            data.append(contentsOf: Utils.maestroStatic2["NIVELRIESGO"] ?? [])
            Utils.showDropdown(boton, data, {(indice,item) in
                if indice == 0 {
                    self.dataAFiltrar.CodNivelRiesgo = nil
                    return
                }
                self.dataAFiltrar.CodNivelRiesgo = Utils.maestroStatic1["NIVELRIESGO"]?[indice - 1]
            })
        case 4:
            // var data = ["- SELECCIONE -"]
            Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaInicio = date
                self.dataAFiltrar.FechaInicio = Utils.date2str(date, "YYYY-MM-dd")
            })
        case 5:
            Utils.openDatePicker("Fecha Fin", Date(), chosenFechaInicio, nil, chandler: {(date) in
                boton.setTitle(Utils.date2str(date), for: .normal)
                self.chosenFechaFin = date
                self.dataAFiltrar.FechaFin = Utils.date2str(date, "YYYY-MM-dd")
            })
        case 6:
            var data = ["- SELECCIONE -"]
            data.append(contentsOf: Utils.maestroDescripcion["GERE"] ?? [])
            Utils.showDropdown(boton, data, {(indice,item) in
                if indice == 0 {
                    self.dataAFiltrar.Gerencia = nil
                    self.dataAFiltrar.Superint = nil
                    self.tabla.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
                    return
                }
                self.dataAFiltrar.Gerencia = Utils.maestroCodTipo["GERE"]?[indice - 1] ?? ""
                self.dataAFiltrar.Superint = nil
                self.tabla.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
            })
        case 7:
            var data = ["- SELECCIONE -"]
            data.append(contentsOf: Utils.maestroDescripcion["SUPE.\(self.dataAFiltrar.Gerencia ?? "")"] ?? [])
            Utils.showDropdown(boton, data, {(indice,item) in
                if indice == 0 {
                    self.dataAFiltrar.Superint = nil
                    return
                }
                self.dataAFiltrar.Superint = Utils.maestroCodTipo["SUPE.\(self.dataAFiltrar.Gerencia ?? "")"]?[indice - 1] ?? ""
            })
        default:
            break
        }
    }
    
    /*@IBAction func clickEnArea(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
            self.data["CodAreaHSEC"] = Utils.maestroCodTipo["AREA"]?[index] ?? ""
        })
        // showDropdown(campoArea, Globals.gArrayObsArea[1], "CodAreaHSEC", Globals.gArrayObsArea[0])
    }*/
    
    /*@IBAction func clickEnTipo(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["TPOB"] ?? [], {(index, item) in
            self.data["CodTipo"] = Utils.maestroCodTipo["TPOB"]?[index] ?? ""
        })
        // showDropdown(campoTipo, Globals.gArrayObsTipo[1], "CodTipo", Globals.gArrayObsTipo[0])
    }*/
    
    /*@IBAction func clickEnRiesgo(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
            self.data["CodNivelRiesgo"] = Utils.maestroStatic1["NIVELRIESGO"]?[index] ?? ""
        })
        // showDropdown(campoRiesgo, Globals.gArrayRiesgo[1], "CodNivelRiesgo", Globals.gArrayRiesgo[0])
    }*/
    
    /*@IBAction func clickEnFechaInicio(_ sender: Any) {
        Utils.openDatePicker("Fecha Inicio", Date(), nil, chosenFechaFin, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaInicio = newdate
                self.data["FechaInicio"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        //showDatePicker("Fecha Inicio", campoFechaInicio, min: nil, max: chosenFechaFin)
    }*/
    
    /*@IBAction func clickEnFechaFin(_ sender: Any) {
        Utils.openDatePicker("Fecha Fin", Date(), chosenFechaInicio, nil, chandler: {(date:Date?) in
            if let newdate = date {
                let boton = sender as! UIButton
                boton.setTitle(Utils.date2str(newdate), for: .normal)
                self.chosenFechaFin = newdate
                self.data["FechaFin"] = Utils.date2str(newdate, "YYYY-MM-dd")
            }
        })
        //showDatePicker("Fecha Fin", campoFechaFin, min: chosenFechaInicio, max: nil)
    }*/
    
    /*@IBAction func clickEnGerencia(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
            self.data["Gerencia"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            self.campoSuperintendencia.setTitle("-", for: .normal)
            self.data["Superint"] = ""
        })
        //showDropdown(campoGerencia, Globals.gArrayGerencia[1], "Gerencia", Globals.gArrayGerencia[0])
    }*/
    
    /*@IBAction func clickEnSuperintendencia(_ sender: Any) {
        let gerenciaSeleccionada = self.data["Gerencia"] ?? ""
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["SUPE.\(gerenciaSeleccionada)"] ?? [], {(index, item) in
            self.data["Superint"] = Utils.maestroCodTipo["SUPE.\(gerenciaSeleccionada)"]?[index] ?? ""
        })
    }*/
    
    @IBAction func clickObservadoPor(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona) in
            self.dataAFiltrar.CodObservadoPor = persona.CodPersona
            self.dataAFiltrar.ObservadoPor = persona.Nombres
            self.tabla.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: .none)
        })
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        self.view.endEditing(true)
        if self.dataAFiltrar.CodObservacion?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.dataAFiltrar.CodObservacion = nil
        }
        let data = Dict.unitToParams(self.dataAFiltrar)
        self.alFiltrar?(data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
