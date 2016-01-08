import UIKit
import CoreData

class CategorieOverviewController: UITableViewController
{
    private var model = CategorieModel()
    //private var categorien: [AnyObject] = ["Winkelen", "Uitgaan", "School", "Sporten", "Reizen"]
    private let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        getDataFromDatabase()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return model.categorien.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("previewCategorieCell", forIndexPath: indexPath) as! PreviewCategorieCell
        
        let categorie = model.categorien[indexPath.row]
        cell.CategorieLabel.text = ("\(categorie)")
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                tableView.beginUpdates()
                //let deleteObject = model.categorien[indexPath.row]
                //appDel.delete(model.categorien[indexPath.row])
                
                model.categorien.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView.endUpdates()
            }
    }
    
    
    @IBAction func addNewCategorie(sender: AnyObject){
        let alert = UIAlertController(title: "Nieuwe Categorie",
            message: "Een nieuwe categorie toevoegen",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.putDataInDatabase(textField!.text!)
                self.model.categorien.append(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
        
    }
    
    private func putDataInDatabase(categorie : String){
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let newCategorie = NSEntityDescription.insertNewObjectForEntityForName("Categorien", inManagedObjectContext: context)
        
        newCategorie.setValue(categorie, forKey: "categorie" )
        
        do{
            try context.save()
        }catch{
            print("There was an error saving data")
        }

        
    }
    
    private func getDataFromDatabase(){
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

}