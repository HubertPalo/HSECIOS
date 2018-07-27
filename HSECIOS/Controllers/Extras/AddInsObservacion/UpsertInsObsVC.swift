import UIKit

class UpsertInsObsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    
    var oldSegmentIndex = 0
    var idPost = -1
    
    var alAgregarObservacion: ((_ obsDetalle: InsObservacionGD, _ multimedia: [FotoVideo], _ documentos: [DocumentoGeneral], _ planes: [PlanAccionDetalle])-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.botonTopDer.isEnabled = false
        let respuestaTab1 = Globals.UIOTab1GetData()
        let respuestaTab3 = Globals.UIOTab3GetData()
        
        // let respuestaTab2 = Globals.UIOTab3GetData()
        if respuestaTab1.success {
            print(respuestaTab1.data)
            if Globals.UIModo == "ADD" {
                self.alAgregarObservacion?(Globals.UIOTab1ObsDetalle, Globals.GaleriaMultimedia, Globals.GaleriaDocumentos, Globals.UIOTab3Planes)
                self.botonTopDer.isEnabled = true
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.idPost = Rest.generateId()
                self.progressBar.progress = 0.0
                self.progressBarView.isHidden = false
                self.botonCancelarDescarga.isEnabled = true
                
                Rest.postMultipartFormData(Routes.forADDInsObservacion(), params: [["1", respuestaTab1.data], ["2", respuestaTab3.toAdd]], [], [], [], [], true, self.idPost, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    self.botonTopDer.isEnabled = true
                }, progress: {(progreso:Double) in
                    
                }, error: {(error) in
                    self.botonTopDer.isEnabled = true
                })
            }
        } else {
            self.presentAlert("Pestaña 1", "El campo \(respuestaTab1.data) no puede estar vacío", .alert, 1, nil, [], [], actionHandlers: [])
            self.botonTopDer.isEnabled = true
        }
    }
    
}
