import UIKit

class UpsertInsPVCTab1: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertInsVC {
            padre.selectTab(0)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            celda.texto.text = Globals.UICodigo
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Gerencia")
            var dato = Utils.searchMaestroDescripcion("GERE", Globals.UITab1InsGD.Gerencia ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.titleLabel?.numberOfLines = 2
            celda.boton.tag = 1
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Superintendencia"
            // SUPE.\(Globals.UITab1InsGD.Gerencia ?? ""
            var dato = Utils.searchMaestroDescripcion("SUPE.\(Globals.UITab1InsGD.Gerencia ?? "")", Globals.UITab1InsGD.SuperInt ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.titleLabel?.numberOfLines = 2
            celda.boton.tag = 2
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto
            var proveedor = Utils.searchMaestroDescripcion("PROV", Globals.UITab1InsGD.CodContrata ?? "")
            proveedor = proveedor == "" ? "XXXXXXXXXXXXXXXXXX" : proveedor
            celda.texto.text = proveedor
            celda.texto.numberOfLines = 2
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Fecha Programada")
            var dato = Utils.date2str(Globals.UITab1FechaP, "dd 'de' MMMM").uppercased()
            dato = dato == "" ? "SELECCIONAR FECHA" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 3
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Fecha de inspección")
            var dato = Utils.date2str(Globals.UITab1Fecha, "dd 'de' MMMM").uppercased()
            dato = dato == "" ? "SELECCIONAR FECHA" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 4
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Hora"
            var dato = Utils.date2str(Globals.UITab1Hora, "HH:mm:SS")
            dato = dato == "" ? "SELECCIONAR HORA" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 5
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación")
            var dato = Utils.searchMaestroDescripcion("UBIC", Globals.UITab1InsGD.CodUbicacion ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.titleLabel?.numberOfLines = 2
            celda.boton.tag = 6
            return celda
        case 8:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Sub Ubicación"
            // celda.boton.setTitle(tituloBotonSubUbicacion, for: .normal)
            var sububicacionSplits = (Globals.UITab1InsGD.CodSubUbicacion ?? "").components(separatedBy: ".")
            var codigoSubUbicacion = sububicacionSplits.count == 2 ? sububicacionSplits[1] : ""
            var dato = Utils.searchMaestroDescripcion("UBIC.\(Globals.UITab1InsGD.CodUbicacion ?? "")", codigoSubUbicacion)
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.titleLabel?.numberOfLines = 2
            celda.boton.tag = 7
            return celda
        case 9:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Tipo de inspección")
            var dato = Utils.searchMaestroDescripcion("TPIN", Globals.UITab1InsGD.CodTipo ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
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
                Globals.UITab1InsGD.Gerencia = Utils.maestroCodTipo["GERE"]?[index] ?? ""
                Globals.UITab1InsGD.SuperInt = nil
                self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
                // self.data["Gerencia"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            })
        case 2:
            Utils.showDropdown(boton, Utils.maestroDescripcion["SUPE.\(Globals.UITab1InsGD.Gerencia ?? "")"] ?? [], {(index, item) in
                Globals.UITab1InsGD.SuperInt = Utils.maestroCodTipo["SUPE.\(Globals.UITab1InsGD.Gerencia ?? "")"]?[index] ?? ""
                // self.data["Superintendencia"] = Utils.maestroCodTipo["SUPE.\(self.data["Gerencia"] ?? "")"]?[index] ?? ""
                // print(self.data)
            })
        case 3:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Fecha Programada", Date(), range.initialDate, range.endDate, chandler: {(date:Date) in
                Globals.UITab1FechaP = date
                // self.data["FechaProgramada"] = Utils.date2str(date)
                boton.setTitle(Utils.date2str(date), for: .normal)
                // print(self.data)
            })
        case 4:
            let range = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Fecha de Inspección", Date(), range.initialDate, range.endDate, chandler: {(date:Date) in
                Globals.UITab1Fecha = date
                boton.setTitle(Utils.date2str(date), for: .normal)
                if Globals.UITab1Hora == nil {
                    Globals.UITab1Hora = "2000-01-01T00:00:00".toDate()
                    self.tableView.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
                }
            })
        case 5:
            if Globals.UITab1Fecha != nil {
                Utils.openHourPicker("Hora Inspección", chandler: {(date:Date) in
                    Globals.UITab1Hora = date
                    // self.data["HoraInspeccion"] = Utils.date2str(date,"HH:mm")
                    boton.setTitle(Utils.date2str(date, "HH:mm:SS"), for: .normal)
                    //print(self.data)
                })
            }
        case 6:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC"] ?? [], {(index, item) in
                Globals.UITab1InsGD.CodUbicacion = Utils.maestroCodTipo["UBIC"]?[index] ?? ""
                Globals.UITab1InsGD.CodSubUbicacion = nil
                self.tableView.reloadRows(at: [IndexPath.init(row: 8, section: 0)], with: .automatic)
            })
        case 7:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(Globals.UITab1InsGD.CodUbicacion ?? "")"] ?? [], {(index, item) in
                Globals.UITab1InsGD.CodSubUbicacion = (Globals.UITab1InsGD.CodUbicacion!) + "." + Utils.maestroCodTipo["UBIC.\(Globals.UITab1InsGD.CodUbicacion!)"]![index]
            })
        case 8:
            Utils.showDropdown(boton, Utils.maestroDescripcion["TPIN"] ?? [], {(index, item) in
                Globals.UITab1InsGD.CodTipo = Utils.maestroCodTipo["TPIN"]?[index] ?? ""
            })
        default:
            break
        }
    }
    
    @IBAction func clickBotonContrata(_ sender: Any) {
        VCHelper.openFiltroContrata(self, {(nombre, codigo) in
            Globals.UITab1InsGD.CodContrata = codigo
            self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .automatic)
            /*self.data["Contrata"] = codigo
            self.contrata = nombre
            
            print(self.data)*/
        })
    }
    
}
