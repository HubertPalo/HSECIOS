import UIKit
import DKImagePickerController

class MuroVC: UIViewController {
    
    var observaciones: [MuroElement] = []
    var muro = MuroTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "HSEC", Images.minero)
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {() in
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            Rest.getDataGeneral(Routes.forMuro(1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data = arrayMuroElement.Data
                self.muro.tableView.reloadData()
                for unit in arrayMuroElement.Data {
                    if (unit.UrlPrew ?? "") != "" {
                        Images.downloadImage(unit.UrlPrew!, {() in
                            self.muro.tableView.reloadData()
                        })
                    }
                    if (unit.UrlObs ?? "") != "" {
                        Images.downloadAvatar(unit.UrlObs!, {() in
                            self.muro.tableView.reloadData()
                        })
                    }
                }
            }, error: nil)
        }
        self.muro.alScrollLimiteBot = {() in
            var pagina = self.muro.data.count / 10
            if self.muro.data.count % 10 == 0 {
                pagina = pagina + 1
            }
            Rest.getDataGeneral(Routes.forMuro(pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data.append(contentsOf: arrayMuroElement.Data)
                self.muro.tableView.reloadData()
                for unit in arrayMuroElement.Data {
                    if (unit.UrlPrew ?? "") != "" {
                        Images.downloadImage(unit.UrlPrew!, {() in
                            self.muro.tableView.reloadData()
                        })
                    }
                    if (unit.UrlObs ?? "") != "" {
                        Images.downloadAvatar(unit.UrlObs!, {() in
                            self.muro.tableView.reloadData()
                        })
                    }
                }
            }, error: nil)

        }
        self.muro.alClickCelda = {(unit:MuroElement) in
            if (unit.Codigo ?? "").starts(with: "OBS") {
                Tabs.indexObsDetalle = 1
                VCHelper.openObsDetalle(self, unit)
            } else if (unit.Codigo ?? "").starts(with: "INS") {
                Tabs.indexInsDetalle = 1
                VCHelper.openInsDetalle(self, unit)
            } else if (unit.Codigo ?? "").starts(with: "NOT") {
                VCHelper.openNotDetalle(self, unit)
            } else if (unit.Codigo ?? "").starts(with: "OBF") {
                Alerts.presentError(type: "Falta implementar :v", viewController: self)
            }
        }
        self.muro.alClickEditar = nil
        self.muro.alClickComentarios = {(unit:MuroElement) in
            if (unit.Codigo ?? "").starts(with: "OBS") {
                Tabs.indexObsDetalle = 3
                self.performSegue(withIdentifier: "toDetalleObs", sender: self)
            } else if (unit.Codigo ?? "").starts(with: "INS") {
                self.performSegue(withIdentifier: "toDetalleIns", sender: self)
            } else if (unit.Codigo ?? "").starts(with: "NOT") {
                Tabs.indexInsDetalle = 3
                self.performSegue(withIdentifier: "toDetalleNot", sender: self)
            } else if (unit.Codigo ?? "").starts(with: "OBF") {
                Alerts.presentError(type: "Falta implementar :v", viewController: self)
            }
        }
        Rest.getDataGeneral(Routes.forMuro(1,10), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.data = arrayMuroElement.Data
            for unit in arrayMuroElement.Data {
                if (unit.UrlObs ?? "") != "" {
                    Images.downloadAvatar(unit.UrlObs!, {() in
                        self.muro.tableView.reloadData()
                    })
                }
                if (unit.UrlPrew ?? "") != "" {
                    Images.downloadImage(unit.UrlPrew!, {() in
                        self.muro.tableView.reloadData()
                    })
                }
            }
        }, error: nil)
    }
    /*
    func getDataForTable() {
        Rest.getDataGeneral(Routes.forMuro(1,10), true, success: {(resultValue:Any?,data:Data?) in
            let hijo = self.childViewControllers[0] as! MuroTVC
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            // hijo.data = Dict.toArrayMuroElement(dict)
            hijo.data = arrayMuroElement.Data
            Images.downloadAllImagesIn(hijo.data, {
                hijo.tableView.reloadData()
            })
        }, error: nil)
    }*/
    
    
    @IBAction func clickSearch(_ sender: Any) {
        VCHelper.openFiltroMuro(self, "MURO")
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
    @IBAction func clickAddFacilito(_ sender: Any) {
        VCHelper.openUpsertFacilito(self, "ADD", "")
    }
    
    @IBAction func clickAddObservacion(_ sender: Any) {
        VCHelper.upsertObservacion(self, "ADD", "")
    }
    
    @IBAction func clickAddInspeccion(_ sender: Any) {
        VCHelper.upsertInspeccion(self, "ADD", "")
    }
}
