import UIKit

class UpsertInsPVCTab3: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertInsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
        header.texto.text = "Lista de Observaciones"
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.UITab3ObsGeneral.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
        let unit = Globals.UITab3ObsGeneral[indexPath.row]
        celda.texto.text = unit.Observacion
        celda.boton.tag = indexPath.row
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = Globals.UITab3ObsGeneral[indexPath.row]
        if unit.Correlativo != nil {
            VCHelper.upsertInsObservacion(self, "PUT", unit.CodInspeccion ?? "", unit.Correlativo, indexPath.row,  {(observacion:InsObservacionGD,multimedia:[FotoVideo],documentos:[DocumentoGeneral],planes:[PlanAccionDetalle]) in
                Globals.UITab3LocalObsDetalle[indexPath.row] = observacion
                self.tableView.reloadData()
            })
        } else {
            Globals.GaleriaModo = "PUT"
            Globals.UIOTab1ObsDetalle = Globals.UITab3LocalObsDetalle[indexPath.row]
            Globals.GaleriaMultimedia = Globals.UITab3LocalMultimedias[indexPath.row]
            Globals.GaleriaDocumentos = Globals.UITab3LocalDocumentos[indexPath.row]
            Globals.GaleriaNombres.removeAll()
            for multimedia in Globals.GaleriaMultimedia {
                Globals.GaleriaNombres.insert(multimedia.Descripcion ?? "")
            }
            Globals.UIOTab3Planes = Globals.UITab3LocalPlanes[indexPath.row]
            
            VCHelper.upsertInsObservacion(self, "PUT", unit.CodInspeccion ?? "", unit.Correlativo, indexPath.row,  {(observacion:InsObservacionGD,multimedia:[FotoVideo],documentos:[DocumentoGeneral],planes:[PlanAccionDetalle]) in
                unit.Observacion = observacion.Observacion
                Globals.UITab3LocalObsDetalle[indexPath.row] = observacion
                Globals.UITab3LocalMultimedias[indexPath.row] = multimedia
                Globals.UITab3LocalDocumentos[indexPath.row] = documentos
                Globals.UITab3LocalPlanes[indexPath.row] = planes
                self.tableView.reloadData()
            })
        }
        
        
    }
    
    @IBAction func clickAddInsObservacion(_ sender: Any) {
        print(Globals.UICodigo)
        print(Globals.UIOCodigo)
        VCHelper.upsertInsObservacion(self, "ADD", Globals.UICodigo, nil, 0,  {(observacion:InsObservacionGD,multimedia:[FotoVideo],documentos:[DocumentoGeneral],planes:[PlanAccionDetalle]) in
            // Tal vez esto no sirve
            if Globals.UIModo == "ADD" {
                Globals.UITab3LocalObsDetalle.append(observacion)
                var nuevo = InsObservacion()
                nuevo.CodInspeccion = Globals.UITab1InsGD.CodInspeccion
                nuevo.CodNivelRiesgo = observacion.CodNivelRiesgo
                nuevo.Correlativo = nil
                nuevo.Observacion = observacion.Observacion
                Globals.UITab3ObsGeneral.append(nuevo)
                Globals.UITab3LocalMultimedias.append(multimedia)
                Globals.UITab3LocalDocumentos.append(documentos)
                Globals.UITab3LocalPlanes.append(planes)
                self.tableView.reloadData()
            } else {
                if observacion.Correlativo != nil {
                    Globals.UITab3LocalObsDetalle.append(observacion)
                    var nuevo = InsObservacion()
                    nuevo.CodInspeccion = Globals.UITab1InsGD.CodInspeccion
                    nuevo.CodNivelRiesgo = observacion.CodNivelRiesgo
                    nuevo.Correlativo = nil
                    nuevo.Observacion = observacion.Observacion
                    Globals.UITab3ObsGeneral.append(nuevo)
                    Globals.UITab3LocalMultimedias.append(multimedia)
                    Globals.UITab3LocalDocumentos.append(documentos)
                    Globals.UITab3LocalPlanes.append(planes)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func clickEliminarObservacion(_ sender: Any) {
    }
    
    
}
