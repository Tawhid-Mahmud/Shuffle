//
//  CurrentLocationViewController.swift
//  Shuffle
//
//  Created by Mohammad Mahmud on 4/7/21.
//

import UIKit
import CoreLocation
import AddressBookUI
import AVFoundation
import AudioToolbox


class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet weak var Zipcode: UITextField!
    var my_zip: String = ""
    
    //variables to pass data to resultviewController
    var business_name = String()
    var store_image_url = ""
    var store_rating = Double()
    var store_price = String()
    var store_city = String()
    var store_address = String()
    var store_state = String()
    var store_zipcode = String()
    var store_latitude: Double = 0.0
    var store_longitude: Double = 0.0
    
    //animation variable to change color of the button
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "ENTER ZIP CODE"
        Zipcode.delegate = self
        dismissKey()
    }
    

    //Source: Course text book
    //Done button will hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        my_zip = Zipcode.text!
        Zipcode.resignFirstResponder()
        
        Geocoding(address: my_zip)
        return true
    }
    
   
    //Start button will perform a segue to the secondViewController
    //animation will change the color of the button
    @IBAction func START(_ sender: UIButton) {
        //source: stack over flow
        //Plays the tweet sound when you click the button
        Geocoding(address: my_zip)
        AudioServicesPlaySystemSound(SystemSoundID(1016))
        if my_zip.isEmpty {
            let Red = Int.random(in: 0...255)
            let Green = Int.random(in: 0...255)
            let Blue = Int.random(in: 0...255)
            
            print("Input field is empty")
            dismiss(animated: true, completion: nil)
            
            
            UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                sender.tintColor = UIColor(red: Red, green: Green, blue: Blue)
            } completion: { finished in
                //sender.tintColor = UIColor(red: Red, green: Green, blue: Blue)
            }
            return
        }
        //Animate the button
        UIView.animate(withDuration: 0.1, delay: 0, options: []) {
            switch self.currentAnimation{
            case 0:
                sender.tintColor = UIColor.blue
                break
            case 1:
                sender.tintColor = UIColor.purple
                break
            default:
                sender.tintColor = UIColor.cyan
                break
            }
        } completion: { finished in
            //print("done")
        }
        
        currentAnimation += 1
        if currentAnimation == 2 {
            currentAnimation = 0
        }

        performSegue(withIdentifier: "ResultsViewSegue", sender: self)
        
    }
    
    
    //MARK - Sending data to another view controller usingn segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! SecondViewController
        secondController.name = business_name
        secondController.show_image = store_image_url
        secondController.show_rating = store_rating
        secondController.show_price = store_price
        secondController.show_city = store_city
        secondController.show_state = store_state
        secondController.show_address = store_address
        secondController.show_zipcode = store_zipcode
        secondController.show_latitude = store_latitude
        secondController.show_longitude = store_longitude
    }
    
    //Geocoding using a zipcode
    //Zip code to coordinates
    //Source: Apple documentation
    func Geocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { [self] (placemarks, error) in
            if error != nil {
                print("ERROR")
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                //Use the coordinates to make the api call
                parse(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                
            }
        })
    }
    
    
    //Source: stack over flow
    //uses the coordinates from the Geocoding to parse the api call
    func parse( latitude: Double, longitude: Double){
        let apikey = "IZ3OhPGovChfl-Z25-75DCak4RcOLm48S5YUmUggaTZRD6ScVNBbSR7mxJs8lyNfYmhckHsQoUVZKElQB8tChEIIFlxJ0-NpeVg1QFrkPWOhQsleGChIb8vagWKhYHYx"
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)")
        
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            do {
                //JSON decoder
                let product = try JSONDecoder().decode(Response.self, from: data!)
                print("\n")
                for stores in product.businesses {
                    let randomName = product.businesses.randomElement()!
                    let rating = (stores.rating)
                    
                    
                    if rating >= 4 && stores.price != nil{
                        self.business_name = randomName.name
                        self.store_rating = randomName.rating
                        self.store_image_url = randomName.image_url
                        self.store_city = randomName.location.city
                        self.store_address = randomName.location.address1
                        self.store_state = randomName.location.state
                        self.store_zipcode = randomName.location.zip_code
                        self.store_latitude = randomName.coordinates.latitude
                        self.store_longitude = randomName.coordinates.longitude
                        
                        return
                    }else {
                        print("")
                    }
                    
                }
            } catch {
                //print(myException)
                print("caught")
            }
            }.resume()
        
        

}
}

//Source: article from medium.com
//When you tap anywhere away from the keyboard, it will hide the keyboard
extension CurrentLocationViewController {
func dismissKey(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(CurrentLocationViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}
    
@objc func dismissKeyboard(){
    view.endEditing(true)
    
    my_zip = Zipcode.text!
    Zipcode.resignFirstResponder()
    Geocoding(address: my_zip)
}
    
}

//Source: article from medium.com
//Use Color codes to change a UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid input")
        assert(green >= 0 && green <= 255, "Invalid input")
        assert(blue >= 0 && blue <= 255, "Invalid input")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
