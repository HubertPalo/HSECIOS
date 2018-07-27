import UIKit

class UpsertInsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    
    var oldSegmentIndex = 0
    var idPost = -1
    var data: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBarView.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        Utils.setTitleAndImage(self, "Nueva inspección", Images.inspeccion)
        /*self.tabsScroll.contentSize = self.tabs.bounds.size
        Tabs.focusScroll(self.tabs, self.tabsScroll)*/
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
        // focusScroll()
        slider.setViewControllers([Tabs.forAddIns[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        // self.botonTopDer.isEnabled = false
        let respuestaTab1 = Globals.UITab1GetData()
        let respuestaTab2 = Globals.UITab2GetData()
        let respuestaTab3 = Globals.UITab3GetData()
        if !respuestaTab1.success {
            self.presentAlert("Pestaña 1", "El campo \(respuestaTab1.data) no puede estar vacío", .alert, 2, nil, [], [], actionHandlers: [])
        } else if respuestaTab2.respuesta != "" {
            self.presentAlert("Pestaña 2", respuestaTab2.respuesta, .alert, 2, nil, [], [], actionHandlers: [])
        } else {
            switch Globals.UIModo {
            case "ADD":
                self.idPost = Rest.generateId()
                self.progressBar.progress = 0.0
                self.progressBarView.isHidden = false
                self.botonCancelarDescarga.isEnabled = true
                Rest.postMultipartFormData(Routes.forADDInspeccion(), params: [["1", respuestaTab1.data], ["2", respuestaTab2.responsables], ["3", respuestaTab2.atendidos], ["4", respuestaTab3.observaciones], ["5", respuestaTab3.planes]], respuestaTab3.data, respuestaTab3.names, respuestaTab3.fileNames, respuestaTab3.mimeTypes, true, self.idPost, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                }, progress: {(progreso:Double) in
                    print(progreso)
                    self.progressBar.progress = Float(progreso)
                }, error: {(error) in
                    self.progressBarView.isHidden = true
                    self.botonTopDer.isEnabled = true
                    var newError = error
                    if newError == "Error" {
                        newError = "El proceso fue cancelado debido a razones desconocidas"
                        self.presentAlert("Error", newError, .alert, nil, nil, ["Aceptar"], [.default], actionHandlers: [nil])
                        /*Alerts.presentAlertWithAccept("Error", newError, imagen: nil, viewController: self, acccept: {
                        })*/
                    } else {
                        print(error)
                    }
                    self.progressBar.isHidden = true
                })
                break
            case "PUT":
                self.idPost = Rest.generateId()
                self.progressBar.progress = 0.0
                self.progressBarView.isHidden = false
                self.botonCancelarDescarga.isEnabled = true
                Rest.postMultipartFormData(Routes.forPUTInspeccion(), params: [["1", respuestaTab1.data], ["2", respuestaTab2.responsables], ["3", respuestaTab2.atendidos], ["4", respuestaTab3.obsToDel]], [], [], [], [], true, self.idPost, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                }, progress: {(progreso:Double) in
                    print(progreso)
                    self.progressBar.progress = Float(progreso)
                }, error: {(error) in
                    self.progressBarView.isHidden = true
                    self.botonTopDer.isEnabled = true
                    var newError = error
                    if newError == "Error" {
                        newError = "El proceso fue cancelado debido a razones desconocidas"
                        self.presentAlert("Error", newError, .alert, nil, nil, ["Aceptar"], [.default], actionHandlers: [nil])
                        /*Alerts.presentAlertWithAccept("Error", newError, imagen: nil, viewController: self, acccept: {
                         })*/
                    } else {
                        print(error)
                    }
                    self.progressBar.isHidden = true
                })
                break
            default:
                break
            }
        }
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        } else {
            Utils.openMenuTab()
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
