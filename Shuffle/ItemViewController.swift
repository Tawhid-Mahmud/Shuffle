//
//  ItemsViewController.swift
//  Shuffle
//
//  Created by Mohammad Mahmud on 5/17/21.
//

import UIKit
import CoreData

//Source: Course Text book
class ItemsViewController: UITableViewController, UITabBarControllerDelegate{
    
    let cellID = "CustomCell"
    var nameArray: [String]=[]
    var imageArray: [String] = []
    var addressArray: [String] = []
    var cityArray: [String] = []
    var stateArray: [String] = []
    
    @objc func refresh(sender:AnyObject)
    {

        nameArray = []
        imageArray = []
        addressArray = []
        cityArray = []
        stateArray = []
        fetchData()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
        print("Done Reloading")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        self.tabBarController?.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    //Uses a custom cell to pupulate the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableViewCell
    
        let storeName = self.nameArray[indexPath.row]
        let storeImage = self.imageArray[indexPath.row]
        let storeAddress = self.addressArray[indexPath.row]
        let storeState = self.stateArray[indexPath.row]
        let storeCity = self.cityArray[indexPath.row]
        cell.cell_name?.text = storeName
        
        let url = NSURL(string: storeImage)!
        if let data = try? Data(contentsOf: url as URL){
            cell.cell_image?.image = UIImage(data: data)
            //cell.cell_image.backgroundColor = .red
        }
        cell.cell_address?.text = storeAddress
        cell.cell_state?.text = storeState
        cell.cell_zipcode?.text = storeCity

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        //Source: YouTube
        //Fetch information from the CoreData
        fetchData()
    }
    func fetchData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Businesses")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                nameArray.append(data.value(forKey: "name") as! String)
                imageArray.append(data.value(forKey: "image") as! String)
                addressArray.append(data.value(forKey: "address") as! String)
                stateArray.append(data.value(forKey: "state") as! String)
                cityArray.append(data.value(forKey: "city") as! String)
                
          }
        } catch {
            print("Failed")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Item Count", nameArray.count)
        
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
        
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Businesses")
            request.returnsObjectsAsFaults = false
            //remove the table view row
            nameArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            //remove the core data
            if let result = try? context.fetch(request){
                context.delete(result[indexPath.row] as! NSManagedObject)
                do {
                    try? context.save()
                }
            }
        }
    }
    

    
}
