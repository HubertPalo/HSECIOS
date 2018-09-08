import UIKit
import MBProgressHUD

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var menuDistanceToLeft: NSLayoutConstraint!
    
    @IBOutlet weak var tabContainer: UIView!
    @IBOutlet weak var contactenosContainer: UIView!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var upsertFacilitoContainer: UIView!
    @IBOutlet weak var agregarObservacionContainer: UIView!
    @IBOutlet weak var agregarInspeccionContainer: UIView!
    @IBOutlet weak var noticiasContainer: UIView!
    @IBOutlet weak var planesAccionContainer: UIView!
    @IBOutlet weak var feedbackContainer: UIView!
    @IBOutlet weak var configuracionContainer: UIView!
    @IBOutlet weak var capacitacionesContainer: UIView!
    
    @IBOutlet weak var botonCerrarSesion: UIButton!
    
    @IBOutlet weak var botonFichaPersonal: UIButton!
    
    @IBOutlet weak var usuario: UILabel!
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var progressHUD: MBProgressHUD?
    
    let menuHeaders = ["General", "Más Opciones"]
    let menuLabels = [["Ingresar reporte facilito", "Ingresar observación", "Ingresar inspección", "Control de Capacitaciones", "Noticias", "Planes de acción pendientes", "Aprobación (SISAP)"], ["Feedback", "Contáctenos", "Configuración"]]
    let menuIconNames = [["facilito", "observacion", "inspeccion", "cursos", "noticia", "planesPendientes", "sisap"], ["feedback", "contactenos", "configuracion"]]
    
    let maxWidth = Utils.widthDevice * 0.75
    let midWidth = Utils.widthDevice * 0.75 * 0.5
    let minWidth = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.actualView = self
        self.progressIndicator.transform = self.progressIndicator.transform.scaledBy(x: 2.0, y: 2.0)
        self.progressIndicator.isHidden = true
        Utils.progressIndicator = self.progressIndicator
        Utils.menuVC = self
        self.usuario.text = " \(Utils.userData.Nombres ?? "")"
        
        self.menuDistanceToLeft.constant = maxWidth * -1
        
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.tabla.rowHeight = 40
        self.rightView.isHidden = true
        self.tabContainer.isHidden = false
        self.upsertFacilitoContainer.isHidden = true
        self.contactenosContainer.isHidden = true
        self.agregarObservacionContainer.isHidden = true
        self.agregarInspeccionContainer.isHidden = true
        self.noticiasContainer.isHidden = true
        self.planesAccionContainer.isHidden = true
        self.feedbackContainer.isHidden = true
        self.configuracionContainer.isHidden = true
        self.capacitacionesContainer.isHidden = true
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragging(recognizer:)))
        self.view.addGestureRecognizer(recognizer)
        
        self.botonCerrarSesion.titleLabel?.numberOfLines = 2
        self.botonFichaPersonal.titleLabel?.numberOfLines = 2
    }
    
    func navigateTo(_ to: Int){
        tabContainer.isHidden = to != 0
        upsertFacilitoContainer.isHidden = to != 1
        contactenosContainer.isHidden = to != 2
        self.menuDistanceToLeft.constant = -1 * maxWidth
        self.rightView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleDragging(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .changed) && Utils.InteraccionHabilitada {
            let point = recognizer.velocity(in: recognizer.view?.superview)
            if point.x > 0 &&  self.menuDistanceToLeft.constant < 0 {
                self.menuDistanceToLeft.constant = self.menuDistanceToLeft.constant + midWidth
                self.rightView.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            } else if point.x < 0 &&  -1 * self.menuDistanceToLeft.constant < CGFloat(maxWidth) {
                self.menuDistanceToLeft.constant = self.menuDistanceToLeft.constant - midWidth
                self.rightView.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        if recognizer.state == .ended && Utils.InteraccionHabilitada {
            if -1 * self.menuDistanceToLeft.constant > maxWidth/2 {
                self.menuDistanceToLeft.constant = -1 * maxWidth
                self.rightView.isHidden = true
            } else {
                self.menuDistanceToLeft.constant = CGFloat(minWidth)
                self.rightView.isHidden = false
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuLabels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabels[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! MenuVHeaderCell
        header.header.text = menuHeaders[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MenuVCell
        celda.icono.image = UIImage.init(named: menuIconNames[indexPath.section][indexPath.row])?.withRenderingMode(.alwaysTemplate)
        celda.icono.tintColor = UIColor.lightGray
        celda.titulo.text = menuLabels[indexPath.section][indexPath.row]
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabContainer.isHidden = true
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                Globals.UFLoadModo("ADD", "")
                Globals.UFModo = "ADD"
                Globals.UFCodigo = ""
                Globals.UFDetalle = FacilitoGD()
                upsertFacilitoContainer.isHidden = false
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
                break
            case 1:
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = false
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
                break
            case 2:
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = false
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
            case 3:
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = false
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
                Utils.menuCapRecibidas.initialLoad()
            case 4:
                let noticiasNC = self.childViewControllers[5] as! UINavigationController
                noticiasNC.popToRootViewController(animated: true)
                let noticiasVC = noticiasNC.childViewControllers[0] as! NoticiasVC
                noticiasVC.loadNoticias()
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = false
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
            case 5:
                let planesNC = self.childViewControllers[6] as! UINavigationController
                planesNC.popToRootViewController(animated: true)
                let planesVC = planesNC.childViewControllers[0] as! PlanesAccionVC
                planesVC.initialLoad()
                Utils.menuPlanesPendientes.initialLoad()
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = false
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
            case 6:
                let sisapApp = "Sisap://true"
                let appUrl = URL(string:sisapApp)!
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
                tabContainer.isHidden = false
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                tabContainer.isHidden = true
                
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = false
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = true
            case 1:
                tabContainer.isHidden = true
                
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = false
                configuracionContainer.isHidden = true
            case 2:
                tabContainer.isHidden = true
                
                upsertFacilitoContainer.isHidden = true
                agregarObservacionContainer.isHidden = true
                agregarInspeccionContainer.isHidden = true
                capacitacionesContainer.isHidden = true
                noticiasContainer.isHidden = true
                planesAccionContainer.isHidden = true
                
                feedbackContainer.isHidden = true
                contactenosContainer.isHidden = true
                configuracionContainer.isHidden = false
            default:
                break
            }
        default:
            break
        }
        
        
        
        /*agregarObservacionContainer.isHidden = !(indexPath.section == 0 && indexPath.row == 2)
        agregarInspeccionContainer.isHidden = !(indexPath.section == 0 && indexPath.row == 3)
        noticiasContainer.isHidden = !(indexPath.section == 0 && indexPath.row == 4)
        planesAccionContainer.isHidden = !(indexPath.section == 0 && indexPath.row == 5)
        capacitacionesContainer.isHidden = !(indexPath.section == 0 && indexPath.row == 6)
        
        feedbackContainer.isHidden = !(indexPath.section == 1 && indexPath.row == 0)
        contactenosContainer.isHidden = !(indexPath.section == 1 && indexPath.row == 1)
        configuracionContainer.isHidden = !(indexPath.section == 1 && indexPath.row == 2)
        */
        self.menuDistanceToLeft.constant = -1 * maxWidth
        self.rightView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        /*if indexPath.section == 0 && indexPath.row == 1 {
            self.presentAlert("Alerta", "Funcionalidad en desarrollo", .alert, 2, nil, [], [], actionHandlers: [])
            // Alerts.presentAlert("Alerta", "Funcionalidad en desarrollo", imagen: nil, viewController: self)
        }*/
        /*if indexPath.section == 0 && indexPath.row == 5 {
            
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            
        }*/
    }
    // Tabla
    
    func showTabIndexAt(_ index: Int) {
        tabContainer.isHidden = false
        upsertFacilitoContainer.isHidden = true
        agregarObservacionContainer.isHidden = true
        agregarInspeccionContainer.isHidden = true
        noticiasContainer.isHidden = true
        planesAccionContainer.isHidden = true
        feedbackContainer.isHidden = true
        contactenosContainer.isHidden = true
        configuracionContainer.isHidden = true
        capacitacionesContainer.isHidden = true
        let tabBC = self.childViewControllers[0] as! UITabBarController
        tabBC.selectedIndex = (index < 0 || index > 4) ? 0 : index
    }
    
    /*func bloquear() {
        // progressHUD?.show(animated: true)
        self.progressIndicator.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func desbloquear() {
        // progressHUD?.hide(animated: true)
        self.progressIndicator.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }*/
    
    func showMenuTab() {
        tabContainer.isHidden = false
        upsertFacilitoContainer.isHidden = true
        agregarObservacionContainer.isHidden = true
        agregarInspeccionContainer.isHidden = true
        noticiasContainer.isHidden = true
        planesAccionContainer.isHidden = true
        feedbackContainer.isHidden = true
        contactenosContainer.isHidden = true
        hideMenu()
    }
    
    func showMenu() {
        self.menuDistanceToLeft.constant = CGFloat(minWidth)
        self.rightView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideMenu() {
        self.menuDistanceToLeft.constant = -1 * maxWidth
        self.rightView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showFichaFor(_ dni: String) {
        tabContainer.isHidden = false
        upsertFacilitoContainer.isHidden = true
        agregarObservacionContainer.isHidden = true
        agregarInspeccionContainer.isHidden = true
        noticiasContainer.isHidden = true
        planesAccionContainer.isHidden = true
        feedbackContainer.isHidden = true
        contactenosContainer.isHidden = true
        let tabBC = self.childViewControllers[0] as! UITabBarController
        tabBC.selectedIndex = 1
        ((tabBC.viewControllers![1] as! UINavigationController).viewControllers[0] as! FichaPersonalVC).loadDataFromDNI(codigo: dni)
    }
    
    @IBAction func clickInferior(_ sender: Any) {
        switch (sender as! UIButton).tag {
        case 1:
            Config.loginSaveFlag = false
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        case 2:
            upsertFacilitoContainer.isHidden = true
            agregarObservacionContainer.isHidden = true
            agregarInspeccionContainer.isHidden = true
            tabContainer.isHidden = false
            let tabBC = self.childViewControllers[0] as! UITabBarController
            tabBC.selectedIndex = 1
            noticiasContainer.isHidden = true
            planesAccionContainer.isHidden = true
            feedbackContainer.isHidden = true
            contactenosContainer.isHidden = true
            configuracionContainer.isHidden = true
            hideMenu()
        default:
            break
        }
    }
    
    
}

class MenuVCell: UITableViewCell {
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var titulo: UILabel!
}

class MenuVHeaderCell: UITableViewCell {
    @IBOutlet weak var header: UILabel!
}

