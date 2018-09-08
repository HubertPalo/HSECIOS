import UIKit
import AVKit

class FacDetalleTVC: UITableViewController {
    
    var detalles = FacilitoGD()
    var historialAtencion = [HistorialAtencionElement]()
    
    let sec0TextoIzq = ["Código Obs", "Observado Por", "Tipo Observación", "Estado", "Gerencia", "Superintendencia", "Ubicación Exacta", "Observación", "Acción a tomar", "Fecha Creación"]
    var sec0TextoDer = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    var HAModo = ""
    var HACodigo = ""
    var HAUnit = HistorialAtencionElement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Rep. Facilito/Detalle", Images.facilito)
    }
    
    func cleanData() {
        self.detalles = FacilitoGD()
        Globals.GaleriaMultimedia = []
        Globals.GaleriaModo = "GET"
        self.historialAtencion = []
        self.tableView.reloadData()
    }
    
    func loadFacilito(_ codigo: String) {
        Globals.GaleriaModo = "GET"
        self.HACodigo = codigo
        // self.facilito = facilito
        Rest.getDataGeneral(Routes.forFacilitoDetalle(codigo/*facilito.CodObsFacilito ?? ""*/), true, success: {(resultValue:Any?,data:Data?) in
            self.detalles = Dict.dataToUnit(data!)!
            self.sec0TextoDer[0] = self.detalles.CodObsFacilito ?? ""
            self.sec0TextoDer[1] = self.detalles.Persona ?? ""
            self.sec0TextoDer[2] = Utils.searchMaestroStatic("TIPOFACILITO", self.detalles.Tipo ?? "")
            self.sec0TextoDer[3] = Utils.searchMaestroStatic("ESTADOFACILITO", self.detalles.Estado ?? "")
            self.sec0TextoDer[4] = Utils.searchMaestroDescripcion("GERE", self.detalles.CodPosicionGer ?? "")
            self.sec0TextoDer[5] = Utils.searchMaestroDescripcion("SUPE.\(self.detalles.CodPosicionGer ?? "")", self.detalles.CodPosicionSup ?? "")
            self.sec0TextoDer[6] = self.detalles.UbicacionExacta ?? ""
            self.sec0TextoDer[7] = self.detalles.Observacion ?? ""
            self.sec0TextoDer[8] = self.detalles.Accion ?? ""
            self.sec0TextoDer[9] = Utils.str2date2str(self.detalles.FecCreacion ?? "")
            self.tableView.reloadData()
            // self.tableView.reloadSections([0], with: .none)
        }, error: nil)
        /*Rest.getData(Routes.forFacilitoDetalle(facilito.CodObsFacilito ?? ""), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.detalles = Dict.toFacilitoDetalle(dict)
            self.sec0TextoDer[0] = self.detalles.CodObsFacilito
            self.sec0TextoDer[1] = self.detalles.Persona
            self.sec0TextoDer[2] = Utils.searchMaestroStatic("TIPOFACILITO", self.detalles.Tipo)
            self.sec0TextoDer[3] = Utils.searchMaestroStatic("ESTADOFACILITO", self.detalles.Estado)
            self.sec0TextoDer[4] = Utils.searchMaestroDescripcion("GERE", self.detalles.CodPosicionGer)
            self.sec0TextoDer[5] = Utils.searchMaestroDescripcion("SUPE.\(self.detalles.CodPosicionGer)", self.detalles.CodPosicionSup)
            self.sec0TextoDer[6] = self.detalles.UbicacionExacta
            self.sec0TextoDer[7] = self.detalles.Observacion
            self.sec0TextoDer[8] = self.detalles.Accion
            self.sec0TextoDer[9] = Utils.str2date2str(self.detalles.FecCreacion)
            self.tableView.reloadSections([0], with: .automatic)
        })*/
        Rest.getDataGeneral(Routes.forMultimedia("\(/*facilito.CodObsFacilito!*/codigo)-1"), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
            Globals.GaleriaMultimedia = Utils.separateMultimedia(arrayMultimedia.Data).fotovideos
            for media in Globals.GaleriaMultimedia {
                Images.downloadImage("\(media.Correlativo!)", {() in
                    media.imagen = Images.imagenes["P-\(media.Correlativo!)"]
                    // self.tableView.reloadSections([1], with: .automatic)
                    self.tableView.reloadData()
                })
            }
        }, error: nil)
        /*Rest.getData(Routes.forMultimedia("\(facilito.CodObsFacilito)-1"), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.multimedia = Dict.toArrayMultimedia(dict)
            self.tableView.reloadSections([1], with: .automatic)
        })*/
        Rest.getDataGeneral(Routes.forFacilitoHistorialAtencion(/*facilito.CodObsFacilito ?? ""*/codigo), true, success: {(resultValue:Any?,data:Data?) in
            var arrayHistorialAtencion: ArrayGeneral<HistorialAtencionElement> = Dict.dataToArray(data!)
            self.historialAtencion = arrayHistorialAtencion.Data// Dict.dataToUnit(data!)!
            print(resultValue)
            self.tableView.reloadData()
            // self.tableView.reloadSections([2], with: .automatic)
        }, error: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || (section == 1 && Globals.GaleriaMultimedia.count == 0){
            return CGFloat.leastNonzeroMagnitude
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! FacDetalleTVCell1
            header.titulo.text = "Galería Imágenes"
            header.view.isHidden = true
            return header.contentView
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! FacDetalleTVCell1
            header.titulo.text = "Historial de Atención"
            // header.view.isHidden = self.facilito.Editable == "1"
            return header.contentView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.sec0TextoIzq.count
        case 1:
            return Globals.GaleriaMultimedia.count/2 + Globals.GaleriaMultimedia.count%2
        case 2:
            return self.historialAtencion.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! FacDetalleTVCell2
            celda.textoIzq.text = self.sec0TextoIzq[indexPath.row]
            celda.textoDer.text = self.sec0TextoDer[indexPath.row]
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! CeldaGaleria
            let unit1 = Globals.GaleriaMultimedia[indexPath.row * 2]
            let unit2: FotoVideo? = (indexPath.row * 2 + 1 == Globals.GaleriaMultimedia.count) ? nil : Globals.GaleriaMultimedia[indexPath.row * 2 + 1]
            celda.imagen1.image = unit1.imagen
            celda.imagen2.image = unit2 == nil ? nil : unit2!.imagen
            celda.play1.isHidden = unit1.TipoArchivo != "TP02"
            celda.play2.isHidden = unit2 == nil || unit2!.TipoArchivo != "TP02"
            celda.botonX1.tag = indexPath.row * 2
            celda.botonX2.tag = (indexPath.row * 2) + 1
            celda.boton1.tag = indexPath.row * 2
            celda.boton2.tag = (indexPath.row * 2) + 1
            celda.viewX1.isHidden = Globals.GaleriaModo == "GET"
            celda.viewX2.isHidden = unit2 == nil || Globals.GaleriaModo == "GET"
            celda.imagen2.isHidden = unit2 == nil
            celda.boton2.isEnabled = unit2 != nil
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! FacDetalleTVCell4
            let unit = self.historialAtencion[indexPath.row]
            celda.botonEditar.tag = indexPath.row
            celda.viewEditar.isHidden = unit.CodObsFacilito != "1"
            celda.persona.text = unit.Persona
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.estado.text = Utils.searchMaestroStatic("ESTADOFACILITO", unit.Estado ?? "")
            celda.comentario.text = unit.Comentario
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            self.HAModo = "GET"
            self.HACodigo = self.detalles.CodObsFacilito ?? ""
            self.HAUnit = self.historialAtencion[indexPath.row]
            self.performSegue(withIdentifier: "toRegistroAtencion", sender: self)
        default:
            break
        }
    }
    
    @IBAction func clickAbrirMenuAtencion(_ sender: Any) {
        let indice = (sender as! UIButton).tag
        self.presentAlert("HISTORIAL DE ATENCIÓN", nil, .actionSheet, nil, nil, ["Editar Atención de Observación", "Eliminar Atención de Observación", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(alertEditar) in
            self.HAModo = "PUT"
            // self.HACodigo = self.detalles.CodObsFacilito ?? ""
            self.HAUnit = self.historialAtencion[indice].copy()
            self.HAUnit.CodObsFacilito = self.HACodigo
            self.HAUnit.Persona = nil
            self.HAUnit.UrlObs = nil
            self.HAUnit.Fecha = nil
            self.performSegue(withIdentifier: "toRegistroAtencion", sender: self)
            }, {(alertEliminar) in
                self.presentAlert("¿Desea eliminar el Registro de Atención?", self.historialAtencion[indice].Comentario, .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .destructive], actionHandlers: [{(alertAceptar) in
                    Rest.getDataGeneral("\(Config.urlBase)/ObsFacilito/DeleteHistorial/\(self.historialAtencion[indice].Correlativo!)", true, success: {(resultValue:Any?,data:Data?) in
                        let respuesta = resultValue as! String
                        if respuesta == "-1" {
                            self.presentAlert("Ocurrió un error al intentar eliminar el Registro de Atención", nil, .alert, 2, nil, [], [], actionHandlers: [])
                        } else {
                            self.presentAlert("Registro de Atención eliminado exitosamente", nil, .alert, 2, nil, [], [], actionHandlers: [])
                        }
                        
                    }, error: {(error) in
                        
                    })
                    }, nil])
            }, nil])
        /*Utils.openSheetMenu(self, "HISTORIAL DE ATENCIÓN", nil, ["Editar Atención de Observación", "Eliminar Atención de Observación", "Cancelar"], [.default, .destructive, .cancel], [{(alertAction) in
            self.HAModo = "PUT"
            self.HACodigo = self.detalles.CodObsFacilito ?? ""
            self.HAUnit = self.historialAtencion[indice]
            self.performSegue(withIdentifier: "toHistorialAtencion", sender: self)
            }, {(alertAction) in
                Alerts.presentAlert("esta seguro?", "Esta acción no se podrá deshacer", duration: 2, imagen: nil, viewController: self)
            }, nil])*/
    }
    
    @IBAction func clickAgregarAtencion(_ sender: Any) {
        self.HAModo = "ADD"
        self.HAUnit = HistorialAtencionElement()
        self.HAUnit.CodObsFacilito = self.HACodigo
        self.HAUnit.Correlativo = -1 // antes era -1
        self.performSegue(withIdentifier: "toRegistroAtencion", sender: self)
    }
    
    @IBAction func clickImagen(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let indice = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indice]
        switch unit.TipoArchivo ?? "" {
        case "TP01":
            var imagenes = [FotoVideo]()
            var indiceGaleria = 0
            var contador = 0
            for media in Globals.GaleriaMultimedia {
                if media.TipoArchivo == "TP01" {
                    let newMedia = media.copy()
                    imagenes.append(newMedia)
                    if media.Descripcion == unit.Descripcion {
                        indiceGaleria = contador
                    }
                    contador = contador + 1
                }
            }
            self.showGaleria(imagenes, indiceGaleria)
            break
        case "TP02":
            unit.asset!.fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
            break
        default:
            self.presentAlert("Error", "Tipo de archivo desconocido", .alert, 2, nil, [], [], actionHandlers: [])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FacDetalleAtencionVC {
            let destino = segue.destination as! FacDetalleAtencionVC
            destino.modo = self.HAModo
            destino.codigo = self.HACodigo
            destino.atencion = self.HAUnit
        }
    }
    
}

class FacDetalleTVCell1: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var view: UIView!
}

class FacDetalleTVCell2: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class FacDetalleTVCell3: UITableViewCell {
    
}

class FacDetalleTVCell4: UITableViewCell {
    
    @IBOutlet weak var persona: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
    @IBOutlet weak var comentario: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var botonEditar: UIButton!
    
    @IBOutlet weak var viewEditar: UIView!
}
