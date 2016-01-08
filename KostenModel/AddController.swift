import UIKit
import CoreData

class AddController: UITableViewController, UIPickerViewDataSource,UIPickerViewDelegate
{
    @IBOutlet weak var opbrengstSwitch: UISwitch!
    @IBOutlet weak var naamField: UITextField!
    @IBOutlet weak var beschrijvingField: UITextField!
    @IBOutlet weak var bedragField: UITextField!
    @IBOutlet weak var datumField: UIDatePicker!
    @IBOutlet weak var categoriePicker: UIPickerView!
    
    var kost: Kost?
    
    private var model = CategorieModel()
    private var pickerData: [String] = [String]()
    private var dateFormatter = NSDateFormatter()
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDatabase()
        pickerData = model.categorien as! [String]
        
        checkCategorienEmpty()
        
        self.categoriePicker.delegate = self
        self.categoriePicker.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndex = row
    }
    
    
    @IBAction func save(){
        let formatter = NSNumberFormatter()
        
        let opbrengst: Bool
        let naam = naamField.text!
        let beschrijving = beschrijvingField.text!
        let bedrag = bedragField.text!
        
        if naam.isEmpty || beschrijving.isEmpty || bedrag.isEmpty{
            let alert = UIAlertController(title: "Melding", message: "Niet alle velden zijn ingevuld!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Oke", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let doubleBedrag = formatter.numberFromString(bedrag)!
        
        
        if(opbrengstSwitch.on){
            opbrengst = true
        }else{
            opbrengst = false
        }
        
        kost = Kost(opbrengst: opbrengst ,naam: naam,beschrijving: beschrijving , bedrag: doubleBedrag, datum: datumField.date, categorie: pickerData[selectedIndex] )
        performSegueWithIdentifier("added", sender: self)
    }
    
    private func getDataFromDatabase(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let request = NSFetchRequest(entityName: "Categorien")
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0{
                for item in results as! [NSManagedObject]{
                    let categorie: String = item.valueForKey("categorie") as! String
                    model.categorien.append(categorie)
                    
                }
            }
        }catch{
            
        }
    }
    
    private func checkCategorienEmpty(){
        if(model.categorien.isEmpty){
            let alert = UIAlertController(title: "Melding", message: "Je hebt nog geen categorieën toegevoegd.\n wilt u een categorie toevoegen? ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "nee", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "ja", style: UIAlertActionStyle.Default,handler:  { action in self.performSegueWithIdentifier("addCategorie", sender: self)}))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

}