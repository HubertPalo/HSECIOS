import UIKit

class UpsertObsPVCTab1: UITableViewController, UITextFieldDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Globals.UOTab1ObsGD.Lugar = textField.text
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            celda.texto.text = Globals.UOModo == "ADD" ? "OBS000000XYZ" : Globals.UOTab1ObsGD.CodObservacion
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto
            celda.texto.text = Globals.UOTab1ObsGD.ObservadoPor
            celda.texto.numberOfLines = 2
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Tipo:"
            celda.boton.tag = 0
            celda.boton.setTitle(Utils.searchMaestroDescripcion("TPOB", Globals.UOTab1ObsGD.CodTipo ?? ""), for: .normal)
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Área", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 1
            var dato = Utils.searchMaestroDescripcion("AREA", Globals.UOTab1ObsGD.CodAreaHSEC ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Nivel de Riesgo:", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 2
            var dato = Utils.searchMaestroStatic("NIVELRIESGO", Globals.UOTab1ObsGD.CodNivelRiesgo ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Fecha:"
            celda.boton.tag = 3
            celda.boton.setTitle((Utils.date2str(Globals.UOTab1Fecha, "dd 'de' MMMM") ?? "").uppercased(), for: .normal)
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación:", "HelveticaNeue-Bold", 13)
            celda.boton.tag = 4
            var dato = Utils.searchMaestroDescripcion("UBIC", Globals.UOTab1CodUbicacion)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Sub Ubicación:"
            celda.boton.tag = 5
            var dato = Utils.searchMaestroDescripcion("UBIC.\(Globals.UOTab1CodUbicacion)", Globals.UOTab1CodSubUbicacion)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
            celda.texto.text = "Ubicación Específica:"
            celda.boton.tag = 6
            var dato = Utils.searchMaestroDescripcion("UBIC.\(Globals.UOTab1CodUbicacion).\(Globals.UOTab1CodSubUbicacion)", Globals.UOTab1CodUbiEspecifica)
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 9:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
            celda.texto.text = "Lugar:"
            celda.inputTexto.text = Globals.UOTab1ObsGD.Lugar
            celda.inputTexto.delegate = self
            celda.inputTexto.isEnabled = Utils.InteraccionHabilitada
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickObservadoPor(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        VCHelper.openFiltroPersona(self, {(persona) in
            Globals.UOTab1ObsGD.ObservadoPor = persona.Nombres
            Globals.UOTab1ObsGD.CodObservadoPor = persona.CodPersona
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        })
    }
    
    @IBAction func clickBotonDerecha(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        self.view.endEditing(true)
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            Utils.showDropdown(boton, ["Comportamiento", "Condición"], {(index, item) in
                let realValues = ["TO01", "TO02"]
                Globals.UOTab1ObsGD.CodTipo = realValues[index]
                Globals.UOTab2ObsDetalle.CodTipo = realValues[index]
                (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tableView.reloadData()
            })
        case 1:
            Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["AREA"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["AREA"] ?? []
                Globals.UOTab1ObsGD.CodAreaHSEC = realValues[index]
            })
        case 2:
            Utils.showDropdown(sender as! UIButton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index, item) in
                let realValues = Utils.maestroStatic1["NIVELRIESGO"] ?? []
                Globals.UOTab1ObsGD.CodNivelRiesgo = realValues[index]
            })
        case 3:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Seleccione Fecha", Date(), range.initialDate, Date(), chandler: {(date) in
                Globals.UOTab1Fecha = date
                self.tableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
            })
        case 4:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC"] ?? []
                Globals.UOTab1CodUbicacion = realValues[index]
                Globals.UOTab1CodSubUbicacion = ""
                Globals.UOTab1CodUbiEspecifica = ""
                self.tableView.reloadRows(at: [IndexPath.init(row: 7, section: 0), IndexPath.init(row: 8, section: 0)], with: .none)
            })
        case 5:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(Globals.UOTab1CodUbicacion)"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC.\(Globals.UOTab1CodUbicacion)"] ?? []
                Globals.UOTab1CodSubUbicacion = realValues[index]
                Globals.UOTab1CodUbiEspecifica = ""
                self.tableView.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: .none)
            })
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(Globals.UOTab1CodUbicacion).\(Globals.UOTab1CodSubUbicacion)"] ?? [], {(index, item) in
                let realValues = Utils.maestroCodTipo["UBIC.\(Globals.UOTab1CodUbicacion).\(Globals.UOTab1CodSubUbicacion)"] ?? []
                Globals.UOTab1CodUbiEspecifica = realValues[index]
            })
        default:
            break
        }
    }
}

