//
//  ViewController.swift
//  keychainEditrUI
//
//  Created by Nitin Jami on 2/16/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import UIKit

class FilterToDumpVC: UIViewController {
    
    @IBOutlet weak var accNameField: UITextField!
    @IBOutlet weak var svcNameField: UITextField!
    var dataSentToListView: [Dictionary<String, String>]!
    
    @IBAction func addKeyChainItem(sender: AnyObject){
        let keychain = Keychain()
        keychain.addItem()
    }
    
    @IBAction func onDump(sender: AnyObject) {
        let keyChain = Keychain()
        let masterData = keyChain.fetchItemsAll()
        if (accNameField.text == "" && svcNameField.text == ""){
            dataSentToListView = masterData.items
        }else{
            dataSentToListView = filterMasterData(["Account": accNameField.text!, "Service": svcNameField.text!], masterData: masterData.items)
        }
        performSegueWithIdentifier("dumpToList", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    
    func filterMasterData(keysDict: Dictionary<String, String>, masterData:[Dictionary<String, String>]) -> [Dictionary<String, String>]{
        var filteredData = masterData
        for (key, value) in keysDict{
            if(value != ""){
                filteredData = filteredData.filter {
                    return $0[key]?.rangeOfString(value, options: .CaseInsensitiveSearch) != nil
                }
            }
        }
        return filteredData
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "dumpToList"){
            let listVC = segue.destinationViewController as! ListViewVC
            listVC.keyChainMasterData = dataSentToListView
        }
    }

}

