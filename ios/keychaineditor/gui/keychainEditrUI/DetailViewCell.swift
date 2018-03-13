//
//  DetailViewCell.swift
//  keychainEditrUI
//
//  Created by Srikant Viswanath on 3/19/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var keyLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(singleDataDict: Dictionary<String, String>){
        if !singleDataDict.isEmpty{
            for (key, value) in singleDataDict{
                keyLbl.text = key + ":"
                valueLbl.text = value
            }
        }
    }


}
