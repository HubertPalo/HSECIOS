import UIKit

class UpsertObsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    
    @IBOutlet weak var tabsInfBar: UIView!
    
    var idPost = 0
    var oldSegmentIndex = 0
    var shouldReset = false
    var afterSuccess: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        if self.shouldReset {
            self.shouldReset = false
            self.selectTab(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBarView.isHidden = true
       self.tabs.customize(self.tabsInfBar)
        self.automaticallyAdjustsScrollViewInsets = false
        Utils.setTitleAndImage(self, "Nueva Observación", Images.observacion)
    }
    
    func focusScroll() {
        let height = tabs.frame.height
        let width = tabs.frame.width
        let singleTabWidth = width/CGFloat(tabs.numberOfSegments)
        let rect = CGRect.init(
            x: singleTabWidth*CGFloat(tabs.selectedSegmentIndex),
            y: CGFloat(0),
            width: singleTabWidth,
            height: height)
        tabsScroll.scrollRectToVisible(rect, animated: true)
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        Tabs.indexAddObs = index
        let slider = self.childViewControllers[0] as! UpsertObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forAddObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
    @IBAction func clickCancelarDescarga(_ sender: Any) {
        self.botonCancelarDescarga.isEnabled = false
        Rest.requestFlags.remove(self.idPost)
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        self.presentarAlertaDatosSinGuardar {
            if self.navigationController!.viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                Utils.openMenuTab()
            }
        }
        /*self.presentarAlertaDatosSinGuardar({() in
            if self.navigationController!.viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                Utils.openMenuTab()
            }
        })*/
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        let respuestaTab1 = Globals.UOTab1GetData()
        let respuestaTab2 = Globals.UOTab2GetData()
        let respuestaTab3 = Globals.UOTab3GetData()
        let respuestaTab4 = Globals.UOTab4GetData()
        print(respuestaTab4)
        var titulo = ""
        var mensaje = ""
        if !respuestaTab1.success {
            titulo = "Pestaña 1"
            mensaje = "El campo \(respuestaTab1.data) no puede estar vacío"
        }
        if !respuestaTab2.success {
            titulo = "Pestaña 2"
            mensaje = "El campo \(respuestaTab2.data) no puede estar vacío"
        }
        if titulo != "" {
            self.botonTopDer.isEnabled = true
            self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            return
        }
        
        self.idPost = Rest.generateId()
        self.progressBar.progress = 0.0
        self.viewCancelarDescarga.isHidden = false
        
        self.progressBarView.isHidden = false
        self.botonTopDer.isEnabled = false
        self.botonCancelarDescarga.isEnabled = true
        Utils.InteraccionHabilitada = false
        (Tabs.forAddObs[0] as! UpsertObsPVCTab1).tableView.reloadData()
        (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tableView.reloadData()
        
        if Globals.UOModo == "ADD" {
            Rest.postMultipartFormData("\(Config.urlBase)/Observaciones/Insertar", params: [["1", respuestaTab1.data], ["2", respuestaTab2.data], ["3", respuestaTab4.toAdd]], respuestaTab3.data, respuestaTab3.names, respuestaTab3.fileNames, respuestaTab3.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                self.botonCancelarDescarga.isEnabled = false
                Utils.InteraccionHabilitada = true
                let respuesta = resultValue as! String
                if respuesta == "-1" {
                    self.presentAlert("Ocurrió un error mientras se procesaba su solicitud", "Por favor, inténtelo nuevamente", .alert, nil, nil, ["Aceptar"], [UIAlertActionStyle.default], actionHandlers: [{(alertAction) in
                        print(respuesta)
                        }])
                    return
                }
                var respuestaSplits = respuesta.components(separatedBy: ";")
                print(respuestaSplits)
                if respuestaSplits.count != 4 {
                    self.presentAlert("Error de interpretación", "La aplicación no pudo entender la respuesta brindada por el servidor", .alert, nil, nil, ["Aceptar"], [.default], actionHandlers: [nil])
                    return
                }
                self.presentAlert("¿Desea finalizar?", "Los datos fueron guardados correctamente", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .destructive], actionHandlers: [{(alertAceptar) in
                    self.afterSuccess?()
                    self.navigationController?.popViewController(animated: true)
                    }, {(alertcancelar) in
                        Globals.UOModo = "PUT"
                        Globals.GaleriaModo = "PUT"
                        Globals.UOCodigo = respuestaSplits[0]
                        Globals.UOTab1ObsGD.CodObservacion = respuestaSplits[0]
                        Globals.UOTab2ObsDetalle.CodObservacion = respuestaSplits[0]
                        Utils.setTitleAndImage(self, "Editar Observación", Images.observacion)
                        if respuestaSplits[0] == "1" {
                            Globals.UOTab1String = String.init(data: Dict.unitToData(Globals.UOTab1ObsGD)!, encoding: .utf8)!
                        }
                        if respuestaSplits[1] == "1" {
                            Globals.UOTab2String = String.init(data: Dict.unitToData(Globals.UOTab2ObsDetalle)!, encoding: .utf8)!
                        }
                        let planSplits = respuestaSplits[2].components(separatedBy: ",")
                        for nuevoPlan in planSplits {
                            let codAccion = nuevoPlan.components(separatedBy: ":")
                            for plan in Globals.UOTab4Planes {
                                if plan.CodAccion == codAccion[0] {
                                    plan.CodAccion = codAccion[1]
                                }
                            }
                        }
                        let files = respuestaSplits[3].components(separatedBy: ",")
                        for file in files {
                            let nameCorrelativo = file.components(separatedBy: ":")
                            let name = nameCorrelativo[0]
                            let correlativo = nameCorrelativo[1]
                            for unit in Globals.GaleriaMultimedia {
                                if unit.Correlativo == nil && name == (unit.Descripcion ?? "") {
                                    unit.Correlativo = Int(correlativo)
                                }
                            }
                            for unit in Globals.GaleriaDocumentos {
                                if unit.Correlativo == nil && name == (unit.Descripcion ?? "") {
                                    unit.Correlativo = Int(correlativo)
                                }
                            }
                        }
                    }])
            }, progress: {(progreso:Double) in
                self.progressBar.progress = Float(progreso)
                self.progressBarText.text = "\(Int(progreso * 100))%"
                self.viewCancelarDescarga.isHidden = progreso > 0.9
            }, error: {(error:String) in
                Utils.InteraccionHabilitada = true
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                let (titulo, mensaje) = Utils.procesarMensajeError(error)
                self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            })
        } else if Globals.UOModo == "PUT" {
            Rest.postMultipartFormData("\(Config.urlBase)/Observaciones/Actualizar", params: [["1", respuestaTab1.data], ["2", respuestaTab2.data], ["3", respuestaTab4.toDel], ["4", respuestaTab3.toDel], ["5", Globals.UOCodigo]], respuestaTab3.data, respuestaTab3.names, respuestaTab3.fileNames, respuestaTab3.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                self.botonCancelarDescarga.isEnabled = false
                Utils.InteraccionHabilitada = true
                let respuesta = resultValue as! String
                if respuesta == "-1" {
                    self.presentAlert("Ocurrió un error mientras se procesaba su solicitud", "Por favor, inténtelo nuevamente", .alert, nil, nil, ["Aceptar"], [UIAlertActionStyle.default], actionHandlers: [nil])
                    return
                }
                var respuestaSplits = respuesta.components(separatedBy: ";")
                print(respuestaSplits)
                if respuestaSplits.count != 5 {
                    self.presentAlert("Error de interpretación", "La aplicación no pudo entender la respuesta brindada por el servidor", .alert, nil, nil, ["Aceptar"], [.default], actionHandlers: [nil])
                    return
                }
                self.presentAlert("¿Desea finalizar?", "Los datos fueron guardados correctamente", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .destructive], actionHandlers: [{(alertAceptar) in
                    self.navigationController?.popViewController(animated: true)
                    }, {(alertCancelar) in
                        if respuestaSplits[0] == "1" {
                            Globals.UOTab1String = String.init(data: Dict.unitToData(Globals.UOTab1ObsGD)!, encoding: .utf8)!
                        }
                        if respuestaSplits[1] == "1" {
                            Globals.UOTab2String = String.init(data: Dict.unitToData(Globals.UOTab2ObsDetalle)!, encoding: .utf8)!
                        }
                        if respuestaSplits[4] != "-" {
                            let files = respuestaSplits[4].components(separatedBy: ",")
                            for file in files {
                                let nameCorrelativo = file.components(separatedBy: ":")
                                let name = nameCorrelativo[0]
                                let correlativo = nameCorrelativo[1]
                                for unit in Globals.GaleriaMultimedia {
                                    if unit.Correlativo == nil && name == (unit.Descripcion ?? "") {
                                        unit.Correlativo = Int(correlativo)
                                    }
                                }
                                for unit in Globals.GaleriaDocumentos {
                                    if unit.Correlativo == nil && name == (unit.Descripcion ?? "") {
                                        unit.Correlativo = Int(correlativo)
                                    }
                                }
                            }
                        }
                    }])
            }, progress: {(progreso:Double) in
                self.progressBar.progress = Float(progreso)
                self.progressBarText.text = "\(Int(progreso * 100))%"
                self.viewCancelarDescarga.isHidden = progreso > 0.9
            }, error: {(error:String) in
                Utils.InteraccionHabilitada = true
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                let (titulo, mensaje) = Utils.procesarMensajeError(error)
                self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            })
        }
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! UpsertObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forAddObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
}
