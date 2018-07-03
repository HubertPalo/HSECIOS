import UIKit
import DKImagePickerController

class MuroVC: UIViewController {
    
    var observaciones: [MuroElement] = []
    var muro = MuroTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "HSEC", Images.minero)
        self.muro = self.childViewControllers[0] as! MuroTVC
        getDataForTable()
        self.muro.alScrollLimiteTop = {() in
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            Rest.getDataGeneral(Routes.forMuro(1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                // let elementos: [MuroElement] = Dict.toArrayMuroElement(dict)
                Images.downloadAllImagesIn(arrayMuroElement.Data, {
                    self.muro.addMoreData(arrayMuroElement.Data)
                })
            }, error: nil)
            /*Rest.getData(Routes.forMuro(1, cantidad), true, vcontroller: self, success: { (dict:NSDictionary) in
                let elementos: [MuroElement] = Dict.toArrayMuroElement(dict)
                Images.downloadAllImagesIn(elementos, {
                    self.muro.addMoreData(elementos)
                })
            })*/
        }
        self.muro.alScrollLimiteBot = {() in
            var pagina = self.muro.data.count / 10
            if self.muro.data.count % 10 == 0 {
                pagina = pagina + 1
            }
            Rest.getDataGeneral(Routes.forMuro(pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                // let elementos: [MuroElement] = Dict.toArrayMuroElement(dict)
                Images.downloadAllImagesIn(arrayMuroElement.Data, {
                    self.muro.addMoreData(arrayMuroElement.Data)
                })
            }, error: nil)
            /*Rest.getData(Routes.forMuro(pagina, 10), true, vcontroller: self, success: { (dict:NSDictionary) in
                let elementos: [MuroElement] = Dict.toArrayMuroElement(dict)
                Images.downloadAllImagesIn(elementos, {
                    self.muro.addMoreData(elementos)
                })
            })*/
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
            // print("click en comentarios")
            // print(unit.Obs)
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
    }
    
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
        /*Rest.getData(Routes.forMuro(1,10), true, vcontroller: self, success: { (dict:NSDictionary) in
            let hijo = self.childViewControllers[0] as! MuroTVC
            hijo.data = Dict.toArrayMuroElement(dict)
            Images.downloadAllImagesIn(hijo.data, {
                hijo.tableView.reloadData()
            })
        }*/
    }
    
    /*func success(_ dict: NSDictionary){
        let units: [MuroElement] = Dict.toArrayMuroElement(dict)
    }
    
    func successGettingData(_ data: [MuroElement]) {
        observaciones = data
        //tabla.reloadData()
        let hijo = self.childViewControllers[0] as! MuroTVC
        hijo.data = data
        hijo.tableView.reloadData()
    }*/
    
    /*
    // Actualizar o cargar mas al llegar a los extremos
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            // Actualizar, al llegar al extremo superior
            HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            print(maximumOffset - currentOffset)
            if maximumOffset - currentOffset <= -10 {
                // Actualizar con mas celdas, al llegar al extremo inferior
                elementos = elementos + 5
                HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
            }
        }
    }
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
        VCHelper.openUpsertObservacion(self, "ADD", "")
    }
}
