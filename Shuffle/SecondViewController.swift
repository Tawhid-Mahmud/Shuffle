//
//  SecondViewController.swift
//  Shuffle
//
//  Created by Mohammad Mahmud on 4/7/21.
//

import UIKit
import MapKit
import CoreData
import AVFoundation
import AudioToolbox

class SecondViewController: UIViewController {
    var name = ""
    var show_image = ""
    var show_rating = Double()
    var show_price = ""
    var show_city = String()
    var show_address = String()
    var show_state = String()
    var show_zipcode = String()
    var show_latitude: Double = 0.0
    var show_longitude: Double = 0.0
    
    //Outlets for SecondViewController
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var URL_image: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var currentAnimation = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let converted_rating: String = String(format: "%.1f", show_rating)
        
        businessName.text = name
        rating.text = converted_rating
        city.text = show_city
        address.text = show_address
        state.text = show_state
        zipcode.text = show_zipcode
        
        currentAnimation += 1
        if currentAnimation > 5 {
            currentAnimation = 0
        }
        
        // using mapkit to pin the store location
        // Source: youTube
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: show_latitude, longitude: show_longitude)
        annotation.title = name
        mapView.addAnnotation(annotation)
            
        // Zoom in the location that is pinned
        // Source: youTube
        let regin = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(regin, animated: true)
        //viewing image from the url
        //let url = URL(string: show_image)!
        let url = NSURL(string: show_image)!
        if let data = try? Data(contentsOf: url as URL){
            URL_image.image = UIImage(data: data)
        }

    
    }
    
    
    
    //Source: stack over flow
    //Saves the data in the device
    //Uses Core Data
    @IBAction func SaveData(_ sender: UIButton) {
        AudioServicesPlaySystemSound(SystemSoundID(1022))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Businesses", in: context)
        let newBusiness = NSManagedObject(entity: entity!, insertInto: context)
        
        
        if name.isEmpty && show_image.isEmpty {
            print("Invalid")
            UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                sender.backgroundColor = .red
            } completion: { finished in }
            dismiss(animated: true, completion: nil)
        } else {
            newBusiness.setValue(name, forKey: "name")
            newBusiness.setValue(show_image, forKey: "image")
            newBusiness.setValue(show_rating, forKey: "rating")
            newBusiness.setValue(show_price, forKey: "price")
            newBusiness.setValue(show_address, forKey: "address")
            newBusiness.setValue(show_city, forKey: "city")
            newBusiness.setValue(show_state, forKey: "state")
            newBusiness.setValue(show_latitude, forKey: "latitude")
            newBusiness.setValue(show_longitude, forKey: "longitude")
            newBusiness.setValue(show_zipcode, forKey: "zipcode")
            
            do {
                try context.save()
                UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                    sender.backgroundColor = .systemGreen
                } completion: { finished in }
                //performSegue(withIdentifier: "Segue", sender: self)
                print("Data is saved in your device")
              } catch {
               print("Failed saving")
            }
        }
        
        
    }
    
}

