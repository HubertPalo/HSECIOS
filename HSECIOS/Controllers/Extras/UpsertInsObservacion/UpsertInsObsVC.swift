import UIKit

class UpsertInsObsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    @IBOutlet weak var tabsInfBar: UIView!
    
    var oldSegmentIndex = 0
    var idPost = -1
    var shouldReset = false
    
    var alAgregarObservacion: ((_ obsDetalle: InsObservacionGD, _ multimedia: [FotoVideo], _ documentos: [DocumentoGeneral], _ planes: [PlanAccionDetalle])-> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        if self.shouldReset {
            self.shouldReset = false
            self.progressBarView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabs.customize(self.tabsInfBar)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! UpsertInsObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        // focusScroll()
        slider.setViewControllers([Tabs.forAddInsObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickTab(_ sender: Any) {
        let slider = self.childViewControllers[0] as! UpsertInsObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        slider.setViewControllers([Tabs.forAddInsObs[self.tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        self.presentarAlertaDatosSinGuardar {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        self.botonTopDer.isEnabled = false
        Utils.InteraccionHabilitada = false
        let respuestaTab1 = Globals.UIOTab1GetData()
        let respuestaTab2 = Globals.GaleriaGetData()
        let respuestaTab3 = Globals.UIOTab3GetData()
        
        if !respuestaTab1.success {
            self.presentAlert("Pestaña 1", "El campo \(respuestaTab1.data) no puede estar vacío", .alert, 1, nil, [], [], actionHandlers: [])
            self.botonTopDer.isEnabled = true
            return
        }
        print(respuestaTab1.data)
        if Globals.UIModo == "ADD" {
            Utils.InteraccionHabilitada = true
            self.alAgregarObservacion?(Globals.UIOTab1ObsDetalle, Globals.GaleriaMultimedia, Globals.GaleriaDocumentos, Globals.UIOTab3Planes)
            self.botonTopDer.isEnabled = true
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            return
        }
        if Globals.UIModo == "PUT" {
            self.idPost = Rest.generateId()
            self.progressBar.progress = 0.0
            self.progressBarView.isHidden = false
            self.botonCancelarDescarga.isEnabled = true
            
            if Globals.UIOModo == "ADD" {
                Rest.postMultipartFormData(Routes.forADDInsObservacion(), params: [["1", respuestaTab1.data], ["2", respuestaTab3.toAdd]], respuestaTab2.data, respuestaTab2.names, respuestaTab2.fileNames, respuestaTab2.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                    self.progressBarView.isHidden = true
                    self.botonTopDer.isEnabled = true
                    self.botonCancelarDescarga.isEnabled = false
                    Utils.InteraccionHabilitada = true
                    
                    print(resultValue)
                    self.botonTopDer.isEnabled = true
                    Utils.InteraccionHabilitada = true
                    
                    let respuesta = resultValue as! String
                    if respuesta == "-1" {
                        self.presentError("")
                        return
                    }
                    let respuestaSplits = respuesta.components(separatedBy: ";")
                    if respuestaSplits.count != 3 {
                        self.presentError("Error de intepretacion")
                        return
                    }
                    if respuestaSplits[0] == "-1" {
                        self.presentError("asd")
                        return
                    }
                    
                    self.presentarAlertaDeseaFinalizar({(actionAceptar) in
                        self.alAgregarObservacion?(Globals.UIOTab1ObsDetalle, [], [], [])
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        return
                    }, {(actionCancelar) in
                        let cabeceraSplits = respuestaSplits[0].components(separatedBy: ":")
                        Globals.UIOModo = "PUT"
                        Globals.UIOTab1ObsDetalle.NroDetInspeccion = Int(cabeceraSplits[0])
                        (Tabs.forAddInsObs[0] as! UpsertInsObsPVCTab1).tableView.reloadData()
                        Globals.UIOCorrelativo = Int(cabeceraSplits[1])
                        Globals.UIOTab1ObsDetalle.Correlativo = Int(cabeceraSplits[1])
                    })
                }, progress: {(progreso:Double) in
                    self.progressBar.progress = Float(progreso)
                    self.progressBarText.text = "\(Int(progreso * 100))%"
                    self.viewCancelarDescarga.isHidden = progreso > 0.9
                }, error: {(error) in
                    print(error)
                    self.botonTopDer.isEnabled = true
                })
            } else {
                Rest.postMultipartFormData(Routes.forPUTInsObservacion(), params: [["1", respuestaTab1.data], ["2", respuestaTab3.toDel], ["3", respuestaTab2.toDel], ["4", Globals.UICodigo], ["5", "\(Globals.UIOTab1ObsDetalle.NroDetInspeccion!)"]], respuestaTab2.data, respuestaTab2.names, respuestaTab2.fileNames, respuestaTab2.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
                    self.progressBarView.isHidden = true
                    self.botonTopDer.isEnabled = true
                    self.botonCancelarDescarga.isEnabled = false
                    Utils.InteraccionHabilitada = true
                    print(resultValue)
                    self.botonTopDer.isEnabled = true
                    Utils.InteraccionHabilitada = true
                    
                    let respuesta = resultValue as! String
                    if respuesta == "-1" {
                        self.presentError("")
                        return
                    }
                    let respuestaSplits = respuesta.components(separatedBy: ";")
                    if respuestaSplits.count != 4 {
                        self.presentError("Error de intepretacion")
                        return
                    }
                    if respuestaSplits[0] == "-1" {
                        self.presentError("asd")
                        return
                    }
                    
                    
                    self.presentarAlertaDeseaFinalizar({(actionAceptar) in
                        self.alAgregarObservacion?(Globals.UIOTab1ObsDetalle, [], [], [])
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        return
                    }, {(actionCancelar) in
                        if respuestaSplits[3] != "0" && respuestaSplits[3] != "-" && respuestaSplits[3] != "-1" {
                            let fileSplits = respuestaSplits[3].components(separatedBy: ",")
                            for media in fileSplits {
                                let mediaDescCorr = media.components(separatedBy: ":")
                                let mediaDesc = mediaDescCorr[0]
                                let mediaCorr = mediaDescCorr[1]
                                for unit in Globals.GaleriaMultimedia {
                                    if unit.Descripcion == mediaDesc {
                                        unit.Correlativo = Int(mediaCorr)
                                    }
                                }
                            }
                            
                        }
                        
                        /*let cabeceraSplits = respuestaSplits[0].components(separatedBy: ":")
                        Globals.UIOTab1ObsDetalle.NroDetInspeccion = Int(cabeceraSplits[0])
                        (Tabs.forAddInsObs[0] as! UpsertInsObsPVCTab1).tableView.reloadData()
                        Globals.UIOCorrelativo = Int(cabeceraSplits[1])
                        Globals.UIOTab1ObsDetalle.Correlativo = Int(cabeceraSplits[1])*/
                    })
                }, progress: {(progreso:Double) in
                    self.progressBar.progress = Float(progreso)
                    self.progressBarText.text = "\(Int(progreso * 100))%"
                    self.viewCancelarDescarga.isHidden = progreso > 0.9
                }, error: {(error) in
                    print(error)
                    self.botonTopDer.isEnabled = true
                })
            }
        }
        
    }
    
}
