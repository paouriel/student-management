import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    var studentID: String! = ""
    var firstname: String! = ""
    var lastname: String! = ""
    
    @IBAction func checkEditStudent(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Editing student...", message: "Enter Student ID:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Student ID"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.studentID = alert?.textFields?[0].text // Force unwrapping because we know it exists.
            
            let num = Int(self.studentID)
            if(num != nil) {
                if(self.studentID != "") {
                    print("pasok")
                    self.editFromEntity()
                    self.loadFromEntity()
                } else {
                    print("error")
                    self.showDialog(title: "Error", message: "Error has occurred when adding student.")
                }
            } else {
                self.showDialog(title: "Error", message: "Invalid student ID!")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addStudent(_ sender: Any) {
        let alert = UIAlertController(title: "Adding student...", message: "Fill up necessary fields", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Student ID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.studentID = alert?.textFields?[0].text // Force unwrapping because we know it exists.
            self.firstname = alert?.textFields?[1].text
            self.lastname = alert?.textFields?[2].text
            
            let num = Int(self.studentID)
            if(num != nil) {
                if(self.studentID != "" && self.firstname != "" && self.lastname != "") {
                    print("pasok")
                    self.saveToEntity()
                    self.showDialog(title: "Success", message: "Student successfully added.")
                    self.loadFromEntity()
                } else {
                    print("error")
                    self.showDialog(title: "Error", message: "Error has occurred when adding student.")
                }
            } else {
                self.showDialog(title: "Error", message: "Invalid student ID!")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteStudent(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Deleting student...", message: "Enter Student ID:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Student ID"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.studentID = alert?.textFields?[0].text // Force unwrapping because we know it exists.
            
            let num = Int(self.studentID)
            if(num != nil) {
                if(self.studentID != "") {
                    print("pasok")
                    self.deleteFromEntity()
                    self.loadFromEntity()
                } else {
                    print("error")
                    self.showDialog(title: "Error", message: "Error has occurred when deleting student.")
                }
            } else {
                self.showDialog(title: "Error", message: "Invalid student ID!")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchStudent(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Searching student...", message: "Enter Student ID:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Student ID"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            self.studentID = alert?.textFields?[0].text // Force unwrapping because we know it exists.
            
            let num = Int(self.studentID)
            if(num != nil) {
                if(self.studentID != "") {
                    print("pasok")
                    self.searchFromEntity()
                } else {
                    print("error")
                }
            } else {
                self.showDialog(title: "Error", message: "Invalid student ID!")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshList(_ sender: Any) {
        loadFromEntity()
        showDialog(title: "Alert", message: "List has been refreshed.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        loadFromEntity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveToEntity() {
        if(checkAddIfExisting()) {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context)
            //add
            newUser.setValue(studentID, forKey: "student_id")
            newUser.setValue(firstname, forKey: "firstname")
            newUser.setValue(lastname, forKey: "lastname")
            
            //save
            do {
                try context.save()
                print("Saved")
            } catch {
                print("There was an error")
            }
        }
    }
    
    @IBOutlet weak var labelSID: UILabel!
    @IBOutlet weak var labelFN: UILabel!
    @IBOutlet weak var labelLN: UILabel!
    
    func loadFromEntity() {
        self.automaticallyAdjustsScrollViewInsets = true
        
        var displaySID: String = ""
        var displayFN: String = ""
        var displayLN: String = ""
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        request.returnsObjectsAsFaults = false
        
        do {
        
            let results = try context.fetch(request)
            if results.count > 0 {
                resetLabels()
                for result in results as! [NSManagedObject] {
                    
                    if let tempsid = result.value(forKey: "student_id") as? String {
                        displaySID += tempsid+"\n"
                    }
                    if let tempfn = result.value(forKey: "firstname") as? String {
                        displayFN += tempfn+"\n"
                    }
                    if let templn = result.value(forKey: "lastname") as? String {
                        displayLN += templn+"\n"
                    }
                    
                    dynamicHeight(results: results.count)
                }
                
                labelSID.numberOfLines = 0
                labelSID.textAlignment = .left
                labelSID.text = displaySID

                labelFN.numberOfLines = 0
                labelFN.textAlignment = .left
                labelFN.text = displayFN
                
                labelLN.numberOfLines = 0
                labelLN.textAlignment = .left
                labelLN.text = displayLN

                print("IDs: "+displaySID)
                print("FNs: "+displayFN)
                print("LNs: "+displayLN)
                
                scrollView.isUserInteractionEnabled = true
            }
            
        } catch {
            print("Cannot fetch results")
        }
    }
    
    func deleteFromEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        request.predicate = NSPredicate(format: "student_id = %@", studentID); request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let studentid = result.value(forKey: "student_id") as? String {
                        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to delete this student?", preferredStyle: .alert)
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak alert] (_) in
                            self.context.delete(result);
                            do {
                                
                                try self.context.save()
                                self.showDialog(title: "Deletion", message: "Student "+studentid+" has been deleted from the list.")
                                self.loadFromEntity()
                            } catch {
                                print("Delete failed")
                                self.showDialog(title: "Error", message: "Error deleting student.")
                            }
                        }))
                        
                        // 4. Present the alert.
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                print("No results")
                showDialog(title: "Invalid Request", message: "No student found with Student ID #"+studentID)
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func editFromEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        request.predicate = NSPredicate(format: "student_id = %@", studentID);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count == 1 {
                let objectUpdate = results[0] as! NSManagedObject
                let studentid = objectUpdate.value(forKey: "student_id") as? String
                let firstname = objectUpdate.value(forKey: "firstname") as? String
                let lastname = objectUpdate.value(forKey: "lastname") as? String
                
                let alert = UIAlertController(title: "Updating student...", message: "Student #"+studentid!+"\n\nUpdate info:", preferredStyle: .alert)
                
                alert.addTextField { (textField) in
                    textField.text = firstname
                }
                alert.addTextField { (textField) in
                    textField.text = lastname
                }
                
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
                    do {
                        let tempUpdFN = alert?.textFields?[0].text
                        let tempUpdLN = alert?.textFields?[1].text
                        
                        
                        if(firstname == tempUpdFN && lastname == tempUpdLN ) {
                            self.showDialog(title: "Alert", message: "No changes has been done.")
                        } else {
                            objectUpdate.setValue(tempUpdFN, forKey: "firstname")
                            objectUpdate.setValue(tempUpdLN, forKey: "lastname")
                            try self.context.save()
                            
                            self.showDialog(title: "Updated", message: "Student #"+studentid!+" has been successfully updated.")
                        }
                        
                        self.loadFromEntity()
                    } catch {
                        print("Update failed")
                        self.showDialog(title: "Error", message: "Error updating student.")
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            } else {
                showDialog(title: "Error", message: "No student found.")
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func checkAddIfExisting() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        var flag: Bool! = false
        
        request.predicate = NSPredicate(format: "student_id = %@", studentID);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                showDialog(title: "Error", message: "Student #"+studentID+" is already in the list.")
                flag = false
            } else {
                flag = true
            }
        } catch {
            print("error")
        }
        
        return flag
    }
    
    func searchFromEntity() {
        self.automaticallyAdjustsScrollViewInsets = true
        
        var displaySID: String = ""
        var displayFN: String = ""
        var displayLN: String = ""
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        request.predicate = NSPredicate(format: "student_id = %@", studentID); request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                resetLabels()
                for result in results as! [NSManagedObject] {
                    if let tempSID = result.value(forKey: "student_id") as? String {
                        displaySID += tempSID+"\n"
                    }
                    
                    if let tempFN = result.value(forKey: "firstname") as? String {
                        displayFN += tempFN+"\n"
                    }
                    
                    if let tempLN = result.value(forKey: "lastname") as? String {
                        displayLN += tempLN+"\n"
                    }
                }
                
                let tempSIDRect: CGRect = labelSID.frame
                labelSID.frame = CGRect(x: tempSIDRect.origin.x, y: tempSIDRect.origin.y, width: 95, height: 56)
                
                let tempFNRect: CGRect = labelFN.frame
                labelFN.frame = CGRect(x: tempFNRect.origin.x, y: tempFNRect.origin.y, width: 95, height: 56)
                
                let tempLNRect: CGRect = labelLN.frame
                labelLN.frame = CGRect(x: tempLNRect.origin.x, y: tempLNRect.origin.y, width: 95, height: 56)
                
                labelSID.numberOfLines = 0
                labelSID.textAlignment = .left
                labelSID.text = displaySID
                
                labelFN.numberOfLines = 0
                labelFN.textAlignment = .left
                labelFN.text = displayFN
                
                labelLN.numberOfLines = 0
                labelLN.textAlignment = .left
                labelLN.text = displayLN
                
                print("IDs: "+displaySID)
                print("FNs: "+displayFN)
                print("LNs: "+displayLN)
                
                showDialog(title: "Alert", message: "Student "+studentID+" has been found.")
                scrollView.isUserInteractionEnabled = true

            } else {
                print("No results")
                showDialog(title: "Invalid Request", message: "No student found with Student ID #"+studentID)
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func resetLabels() {
        let tempSIDRect: CGRect = labelSID.frame
        labelSID.frame = CGRect(x: tempSIDRect.origin.x, y: tempSIDRect.origin.y, width: 95, height: 35)
        
        let tempFNRect: CGRect = labelFN.frame
        labelFN.frame = CGRect(x: tempFNRect.origin.x, y: tempFNRect.origin.y, width: 95, height: 35)
        
        let tempLNRect: CGRect = labelLN.frame
        labelLN.frame = CGRect(x: tempLNRect.origin.x, y: tempLNRect.origin.y, width: 95, height: 35)
    }
    
    func dynamicHeight(results: Int) {
        if(results > 1) {
            let tempSIDRect: CGRect = labelSID.frame
            labelSID.frame = CGRect(x: tempSIDRect.origin.x, y: tempSIDRect.origin.y, width: 95, height: tempSIDRect.height+14)
            
            let tempFNRect: CGRect = labelFN.frame
            labelFN.frame = CGRect(x: tempFNRect.origin.x, y: tempFNRect.origin.y, width: 95, height: tempFNRect.height+14)
            
            let tempLNRect: CGRect = labelLN.frame
            labelLN.frame = CGRect(x: tempLNRect.origin.x, y: tempLNRect.origin.y, width: 95, height: tempLNRect.height+14)
        }
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

