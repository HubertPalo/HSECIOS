import UIKit

class UpsertInsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    @IBOutlet weak var TabsInfBar: UIView!
    
    var oldSegmentIndex = 0
    var idPost = -1
    var data: [String:String] = [:]
    var afterSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBarView.isHidden = true
        self.tabs.customize(self.TabsInfBar)
        self.automaticallyAdjustsScrollViewInsets = false
        if Globals.UIModo == "ADD" {
            Utils.setTitleAndImage(self, "Nueva inspección", Images.inspeccion)
        }
        if Globals.UIModo == "PUT" {
            Utils.setTitleAndImage(self, "Editar inspección", Images.inspeccion)
        }
        
    }
    
    func cleanData() {
        switch Globals.UIModo {
        case "ADD":
            Utils.setTitleAndImage(self, "Nueva inspección", Images.inspeccion)
        case "PUT":
            Utils.setTitleAndImage(self, "Editar inspección", Images.inspeccion)
        default:
            break
        }
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! UpsertInsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        slider.setViewControllers([Tabs.forAddIns[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        let respuestaTab1 = Globals.UITab1GetData()
        let respuestaTab2 = Globals.UITab2GetData()
        let respuestaTab3 = Globals.UITab3GetData()
        var titulo = ""
        var mensaje = ""
        if !respuestaTab1.success {
            titulo = "Pestaña 1"
            mensaje = "El campo \(respuestaTab1.data) no puede estar vacío"
        }
        if respuestaTab2.respuesta != "" {
            titulo = "Pestaña 2"
            mensaje = respuestaTab2.respuesta
        }
        if titulo != "" {
            self.botonTopDer.isEnabled = true
            self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            return
        }
        
        self.idPost = Rest.generateId()
        self.progressBar.progress = 0.0
        self.progressBarText.text = "0%"
        self.viewCancelarDescarga.isHidden = false
        
        self.progressBarView.isHidden = false
        self.botonTopDer.isEnabled = false
        self.botonCancelarDescarga.isEnabled = true
        Utils.InteraccionHabilitada = false
        
        if Globals.UIModo == "ADD" {
            Rest.postMultipartFormData(Routes.forADDInspeccion(), params: [["1", respuestaTab1.data], ["2", respuestaTab2.responsables], ["3", respuestaTab2.atendidos], ["4", respuestaTab3.observaciones], ["5", respuestaTab3.planes]], respuestaTab3.data, respuestaTab3.names, respuestaTab3.fileNames, respuestaTab3.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                self.botonCancelarDescarga.isEnabled = false
                Utils.InteraccionHabilitada = true
                print(resultValue)
                let respuesta = resultValue as! String
                if respuesta == "-1" {
                    self.presentError("Ocurrió un error al procesar la solicitud")
                    return
                }
                let respuestaSplits = respuesta.components(separatedBy: ";")
                if respuestaSplits.count != 6 {
                    self.presentError("No se pudo intepretar la respuesta del servidor")
                    return
                }
                self.presentarAlertaDeseaFinalizar({(aceptarAction) in
                    self.afterSuccess?()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }, {(cancelarAction) in
                    // [0] - Codigo Inspeccion
                    // [1] - Personas Equipo Inspeccion
                    // [2] - Personas Atendieron
                    // [3] - Observacion
                    // [4] - Planes
                    // [5] - Archivos
                    
                    Utils.setTitleAndImage(self, "Editar inspección", Images.inspeccion)
                    
                    Globals.UIModo = "PUT"
                    Globals.GaleriaModo = "PUT"
                    Globals.UICodigo = respuestaSplits[0]
                    Globals.UITab1InsGD.CodInspeccion = respuestaSplits[0]
                    (Tabs.forAddIns[0] as! UpsertInsPVCTab1).tableView.reloadData()
                    
                    Globals.UITab2RealizaronOriginalLider = Globals.UITab2RealizaronNuevoLider
                    Globals.UITab2AtendieronOriginal = Globals.UITab2AtendieronNuevo
                    Globals.UITab2RealizaronOriginal = Globals.UITab2RealizaronNuevo
                    
                    if respuestaSplits[3] != "-1" && respuestaSplits[3] != "0" {
                        let observacionesSplits = respuestaSplits[3].components(separatedBy: ",")
                        for observaciones in observacionesSplits {
                            let obsSplits = observaciones.components(separatedBy: ":")
                            let oldCorrelativo = Int(obsSplits[0])
                            let newCorrelativo = Int(obsSplits[1])
                            for observacionDetalle in Globals.UITab3ObsGeneral {
                                if observacionDetalle.Correlativo == oldCorrelativo {
                                    observacionDetalle.Correlativo = newCorrelativo
                                    observacionDetalle.CodInspeccion = respuestaSplits[0]
                                }
                            }
                        }
                    }
                    
                    if respuestaSplits[4] != "-1" {
                        /* let planesSplits = respuestaSplits[4].components(separatedBy: ",")
                        for plan in planesSplits {
                            let planSplits = plan.components(separatedBy: ":")
                            let oldCodAccion = planSplits[0]
                            let newCodAccion = planSplits[1]
                            for planesArray in Globals.UITab3LocalPlanes {
                                for plan in planesArray {
                                    if plan.CodAccion == oldCodAccion {
                                        plan.CodAccion = newCodAccion
                                    }
                                }
                            }
                        } */
                    }
                    
                    
                })
            }, progress: {(progreso:Double) in
                self.progressBar.progress = Float(progreso)
                self.progressBarText.text = "\(Int(progreso * 100))%"
                self.viewCancelarDescarga.isHidden = progreso > 0.9
            }, error: {(error) in
                Utils.InteraccionHabilitada = true
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                let (titulo, mensaje) = Utils.procesarMensajeError(error)
                self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            })
            return
        }
        if Globals.UIModo == "PUT" {
            Rest.postMultipartFormData(Routes.forPUTInspeccion(), params: [["1", respuestaTab1.data], ["2", respuestaTab2.responsables], ["3", respuestaTab2.atendidos], ["4", respuestaTab3.obsToDel]], respuestaTab3.data, respuestaTab3.names, respuestaTab3.fileNames, respuestaTab3.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                self.botonCancelarDescarga.isEnabled = false
                Utils.InteraccionHabilitada = true
                print(resultValue)
                
                
                let respuesta = resultValue as! String
                if respuesta == "-1" {
                    self.presentError("Ocurrió un error al procesar la solicitud")
                    return
                }
                let respuestaSplits = respuesta.components(separatedBy: ";")
                if respuestaSplits.count != 4 {
                    self.presentError("No se pudo intepretar la respuesta del servidor")
                    return
                }
                if respuestaSplits[0] == "-1" {
                    self.presentError("Ocurrió un error al actualizar la cabecera")
                    return
                }
                if respuestaSplits[1] == "-1" {
                    self.presentError("Ocurrió un error al actualizar el Equipo de Inspección")
                    return
                }
                if respuestaSplits[2] == "-1" {
                    self.presentError("Ocurrió un error al actualizar el Equipo que atendió la Inspección")
                    return
                }
                if respuestaSplits[3] == "-1" {
                    self.presentError("Ocurrió un error al eliminar las observaciones solicitadas")
                    return
                }
                self.presentarAlertaDeseaFinalizar({(actionAceptar) in
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }, {(actionCancelar) in
                    print("Al click en cancelar")
                    Globals.UITab2RealizaronOriginalLider = Globals.UITab2RealizaronNuevoLider
                    Globals.UITab2AtendieronOriginal = Globals.UITab2AtendieronNuevo
                    Globals.UITab2RealizaronOriginal = Globals.UITab2RealizaronNuevo
                })
                
            }, progress: {(progreso:Double) in
                self.progressBar.progress = Float(progreso)
                self.progressBarText.text = "\(Int(progreso * 100))%"
                self.viewCancelarDescarga.isHidden = progreso > 0.9
            }, error: {(error) in
                Utils.InteraccionHabilitada = true
                self.progressBarView.isHidden = true
                self.botonTopDer.isEnabled = true
                let (titulo, mensaje) = Utils.procesarMensajeError(error)
                self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
            })
            return
        }
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
    }
    
    
    @IBAction func clickSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! UpsertInsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        slider.setViewControllers([Tabs.forAddIns[self.tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
}
