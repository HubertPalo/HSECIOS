import UIKit

class AddInspeccionPVCTab1: UITableViewController {
    
    var data: [String:String] = [:]
    var contrata = "XXXXXXXXXXXXXXXXXX"
    
    var parcialUbicacion = ""
    var parcialSubUbicacion = ""
    
    
    var tituloBotonSubUbicacion = "- SELECCIONE -"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? AddInspeccionVC {
            padre.selectTab(0)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "celda1")!
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Gerencia")
            celda.boton.setTitle("- SELECCIONE -", for: .normal)
            celda.boton.tag = 1
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Superintendencia"
            celda.boton.setTitle("- SELECCIONE -", for: .normal)
            celda.boton.tag = 2
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto
            celda.texto.text = contrata
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Fecha Programada")
            celda.boton.setTitle("SELECCIONAR FECHA", for: .normal)
            celda.boton.tag = 3
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Fecha de inspección")
            celda.boton.setTitle("SELECCIONAR FECHA", for: .normal)
            celda.boton.tag = 4
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Hora"
            celda.boton.setTitle("SELECCIONAR HORA", for: .normal)
            celda.boton.tag = 5
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación")
            celda.boton.setTitle("- SELECCIONE -", for: .normal)
            celda.boton.tag = 6
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Sub Ubicación"
            celda.boton.setTitle(tituloBotonSubUbicacion, for: .normal)
            celda.boton.tag = 7
            return celda
        case 9:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Tipo de inspección")
            celda.boton.setTitle("- SELECCIONE -", for: .normal)
            celda.boton.tag = 8
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 1:
            Utils.showDropdown(boton, Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
                self.data["Gerencia"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
                print(self.data)
            })
        case 2:
            // let gerenciaSeleccionada = "SUPE.\(self.data["Gerencia"] ?? "")"
            Utils.showDropdown(boton, Utils.maestroDescripcion["SUPE.\(self.data["Gerencia"] ?? "")"] ?? [], {(index, item) in
                self.data["Superintendencia"] = Utils.maestroCodTipo["SUPE.\(self.data["Gerencia"] ?? "")"]?[index] ?? ""
                print(self.data)
            })
        case 3:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Fecha Programada", Date(), range.initialDate, range.endDate, chandler: {(date:Date) in
                self.data["FechaProgramada"] = Utils.date2str(date)
                boton.setTitle(Utils.date2str(date), for: .normal)
                print(self.data)
            })
        case 4:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Fecha de Inspección", Date(), range.initialDate, range.endDate, chandler: {(date:Date) in
                self.data["FechaInspeccion"] = Utils.date2str(date)
                boton.setTitle(Utils.date2str(date), for: .normal)
                print(self.data)
            })
        case 5:
            if self.data["FechaInspeccion"] != nil {
                Utils.openHourPicker("Hora Inspección", chandler: {(date:Date) in
                    self.data["HoraInspeccion"] = Utils.date2str(date,"HH:mm")
                    boton.setTitle(Utils.date2str(date, "HH:mm"), for: .normal)
                    print(self.data)
                })
            }
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC"] ?? [], {(index, item) in
                self.data["Ubicacion"] = Utils.maestroCodTipo["UBIC"]?[index] ?? ""
                self.data["SubUbicacion"] = nil
                self.tituloBotonSubUbicacion = "- SELECCIONE -"
                self.tableView.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: .automatic)
                print(self.data)
            })
        case 7:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(self.data["Ubicacion"] ?? "")"] ?? [], {(index, item) in
                self.data["SubUbicacion"] = Utils.maestroCodTipo["UBIC.\(self.data["Ubicacion"] ?? "")"]?[index] ?? ""
                print(self.data)
            })
        case 8:
            Utils.showDropdown(boton, Utils.maestroDescripcion["TPIN"] ?? [], {(index, item) in
                self.data["TipoInspeccion"] = Utils.maestroCodTipo["TPIN"]?[index] ?? ""
                print(self.data)
            })
        default:
            break
        }
    }
    
    @IBAction func clickBotonContrata(_ sender: Any) {
        VCHelper.openFiltroContrata(self, {(nombre, codigo) in
            self.data["Contrata"] = codigo
            self.contrata = nombre
            self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .automatic)
            print(self.data)
        })
    }
    
}
