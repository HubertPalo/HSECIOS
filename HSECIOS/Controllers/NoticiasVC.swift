import UIKit

class NoticiasVC: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var muro = MuroTVC()
    var params = ["Elemperpage":"10", "Pagenumber": "1"]
    
    override func viewDidAppear(_ animated: Bool) {
        Rest.postDataGeneral(Routes.forMuroSearchN(), params, false, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.addMoreData(arrayMuroElement.Data)
        }, error: nil)
        /*Rest.postData(Routes.forMuroSearchN(), params, false, vcontroller: self, success: {(dict:NSDictionary) in
            self.muro.addMoreData(Dict.toArrayMuroElement(dict))
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Noticias", Images.minero)
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alClickCelda = {(unit:MuroElement) in
            VCHelper.openNotDetalle(self, unit)
        }
        self.muro.alScrollLimiteTop = {() in
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            var params = ["Elemperpage":"\(cantidad)", "Pagenumber": "1"]
            Rest.postDataGeneral(Routes.forMuroSearchN(), self.params, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.addMoreData(arrayMuroElement.Data)
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchN(), self.params, true, vcontroller: self, success: {(dict:NSDictionary) in
                self.muro.addMoreData(Dict.toArrayMuroElement(dict))
            })*/
        }
        self.muro.alScrollLimiteBot = {() in
            var pagina = self.muro.data.count / 10
            if self.muro.data.count % 10 == 0 {
                pagina = pagina + 1
            }
            var params = ["Elemperpage":"10", "Pagenumber": "\(pagina)"]
            Rest.postDataGeneral(Routes.forMuroSearchN(), self.params, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.addMoreData(arrayMuroElement.Data)
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchN(), self.params, true, vcontroller: self, success: {(dict:NSDictionary) in
                self.muro.addMoreData(Dict.toArrayMuroElement(dict))
            })*/
            
        }
        self.tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    @IBAction func ClickTopIzq(_ sender: Any) {
        Utils.openMenuTab()
    }
    
    @IBAction func clickBuscar(_ sender: Any) {
        VCHelper.openFiltroMuro(self, "NOT")
    }
    
}
