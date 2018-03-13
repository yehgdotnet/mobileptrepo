//
//  DetailViewVC.swift
//  keychainEditrUI
//
//  Created by Srikant Viswanath on 2/17/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import UIKit
let ORDER_OF_KEYS = [
    "Account", "Service", "Access Group", "Protection", "Creation Time", "Modification Time", "Data", "User Preference"
]

class DetailViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var dataSentFromListView: [Dictionary<String, String>]!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBAction func deleteThisItem(sender: AnyObject){
        let deleteAlert = UIAlertController(
            title: "Delete?", message: "Sure to delete item with Account: \(dataSentFromListView[0]["Account"]!)",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default){(action: UIAlertAction!) in
            let keyChain = Keychain()
            keyChain.removeItem(account: self.dataSentFromListView[0]["Account"]!, service: self.dataSentFromListView[1]["Service"]!)
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default){(action: UIAlertAction!) in self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
        presentViewController(deleteAlert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let detailCell = detailTableView.dequeueReusableCellWithIdentifier("DetailViewCell") as? DetailViewCell{
            detailCell.configureCell(dataSentFromListView[indexPath.row])
            return detailCell
        }else{
            return DetailViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSentFromListView.count
    }
    
    //func tableView


}
