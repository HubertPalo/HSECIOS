import UIKit

class UpsertObsPVCTab1: UITableViewController, UITextFieldDelegate {
    
    var modo = "ADD"
    var codigo = ""
    
    var obsGD = ObservacionGD()
    
    var codUbicacion = ""
    var codSubUbicacion = ""
    var codUbiEspecifica = ""
    var fecha = Date()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadModo(_ modo: String, _ codigo: String) {
        self.modo = modo
        self.codigo = codigo
        switch modo {
        case "ADD":
            self.obsGD.CodTipo = "TO01"
            self.obsGD.CodObservadoPor = Utils.userData.CodPersona
            self.obsGD.ObservadoPor = Utils.userData.Nombres
            self.obsGD.CodUbicacion = ""
            self.codUbicacion = ""
            self.codSubUbicacion = ""
            self.codUbiEspecifica = ""
            self.fecha = Date()
            self.tableView.reloadData()
        case "PUT":
            Rest.getDataGeneral(Routes.forObservaciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
                self.obsGD = Dict.dataToUnit(data!)!
                self.fecha = Utils.str2date(self.obsGD.Fecha ?? "") ?? Date()
                if self.obsGD.CodUbicacion != "" {
                    let splits = (self.obsGD.CodUbicacion ?? "").components(separatedBy: ".")
                    self.codUbicacion = splits[0]
                    if splits.count > 1 {
                        self.codSubUbicacion = splits[1]
                    }
                    if splits.count > 2 {
                        self.codUbiEspecifica = splits[2]
                    }
                } else {
                    self.codUbicacion = ""
                    self.codSubUbicacion = ""
                    self.codUbiEspecifica = ""
                }
                self.tableView.reloadData()
            }, error: nil)
            break
        default:
            break
        }
    }
    
    func getData() -> String {
        self.obsGD.Fecha = Utils.date2str(self.fecha, "YYYY-MM-dd")
        var ubicacion = ""
        if self.codUbicacion != "" {
            ubicacion.append(self.codUbicacion)
        }
        if self.codSubUbicacion != "" {
            ubicacion.append(".\(self.codSubUbicacion)")
        }
        if self.codUbiEspecifica != "" {
            ubicacion.append(".\(self.codUbiEspecifica)")
        }
        self.obsGD.CodUbicacion = ubicacion
        let showData = self.obsGD
        showData.ObservadoPor = nil
        return String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.obsGD.Lugar = textField.text
        print("ended: \(self.obsGD.Lugar)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            celda.texto.text = self.modo == "ADD" ? "OBS000000XYZ" : self.obsGD.CodObservacion
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto
            celda.texto.text = self.obsGD.ObservadoPor
            celda.texto.numberOfLines = 2
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Tipo:"
            celda.boton.tag = 0
            celda.boton.setTitle(Utils.searchMaestroDescripcion("TPOB", self.obsGD.CodTipo ?? ""), for: .normal)
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Área", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 1
            var dato = Utils.searchMaestroDescripcion("AREA", self.obsGD.CodAreaHSEC ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Nivel de Riesgo:", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 2
            var dato = Utils.searchMaestroStatic("NIVELRIESGO", self.obsGD.CodNivelRiesgo ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Fecha:"
            celda.boton.tag = 3
            celda.boton.setTitle((Utils.date2str(self.fecha, "dd 'de' MMMM") ?? "").uppercased(), for: .normal)
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación:", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 4
            var dato = Utils.searchMaestroDescripcion("UBIC", self.codUbicacion)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Sub Ubicación:"
            celda.boton.tag = 5
            var dato = Utils.searchMaestroDescripcion("UBIC.\(self.codUbicacion)", self.codSubUbicacion)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Ubicación Específica:"
            celda.boton.tag = 6
            var dato = Utils.searchMaestroDescripcion("UBIC.\(self.codUbicacion).\(self.codSubUbicacion)", self.codUbiEspecifica)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 9:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
            celda.texto.text = "Lugar:"
            celda.inputTexto.text = self.obsGD.Lugar
            celda.inputTexto.delegate = self
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickObservadoPor(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona) in
            self.obsGD.ObservadoPor = persona.Nombres
            self.obsGD.CodObservadoPor = persona.CodPersona
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        })
    }
    
    @IBAction func clickBotonDerecha(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            Utils.showDropdown(boton, ["Comportamiento", "Condición"], {(index, item) in
                let realValues = ["TO01", "TO02"]
                self.obsGD.CodTipo = realValues[index]
                (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tipo = realValues[index]
                (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tableView.reloadData()
            })
        case 1:
            Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["AREA"] ?? []
                self.obsGD.CodAreaHSEC = realValues[index]
            })
        case 2:
            Utils.showDropdown(sender as! UIButton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
                let realValues = Utils.maestroStatic1["NIVELRIESGO"] ?? []
                self.obsGD.CodNivelRiesgo = realValues[index]
            })
        case 3:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Seleccione Fecha", Date(), range.initialDate, Date(), chandler: {(date) in
                self.fecha = date
                self.tableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
            })
        case 4:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC"] ?? []
                self.codUbicacion = realValues[index]
                self.codSubUbicacion = ""
                self.codUbiEspecifica = ""
                self.tableView.reloadRows(at: [IndexPath.init(row: 7, section: 0), IndexPath.init(row: 8, section: 0)], with: .none)
            })
        case 5:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(self.codUbicacion)"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC.\(self.codUbicacion)"] ?? []
                self.codSubUbicacion = realValues[index]
                self.codUbiEspecifica = ""
                self.tableView.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: .none)
            })
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(self.codUbicacion).\(self.codSubUbicacion)"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC.\(self.codUbicacion).\(self.codSubUbicacion)"] ?? []
                self.codUbiEspecifica = realValues[index]
            })
        default:
            break
        }
    }
    
    /*@IBAction func clickObservadoPor(_ sender: Any) {
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
    }*/
    
    
    
}

