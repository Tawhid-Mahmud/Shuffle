//
//  CustomCell.swift
//  Shuffle
//
//  Created by Mohammad Mahmud on 5/20/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_image: UIImageView!
    
    @IBOutlet weak var cell_name: UILabel!
    @IBOutlet weak var cell_address: UILabel!
    @IBOutlet weak var cell_zipcode: UILabel!
    @IBOutlet weak var cell_state: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

}
