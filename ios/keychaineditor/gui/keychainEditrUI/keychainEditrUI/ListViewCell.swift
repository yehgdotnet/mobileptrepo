//
//  ListViewCell.swift
//  keychainEditrUI
//
//  Created by Srikant Viswanath on 2/16/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureListCell(listContentsDict: Dictionary<String, String>){
        if let accName = listContentsDict["Account"], svcName = listContentsDict["Service"]{
            accountName.text = accName
            serviceName.text = svcName
        }else{
            print("Either kSecAttrAccount or kSecAttrService keys not present while configuring list view cell")
        }
        
    }

   

}
