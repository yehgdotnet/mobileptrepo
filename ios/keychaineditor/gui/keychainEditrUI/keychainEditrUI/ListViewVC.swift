//
//  ListViewVC.swift
//  keychainEditrUI
//
//  Created by Srikant Viswanath on 2/16/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import UIKit


class ListViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataSentToDetailVC: [Dictionary<String, String>]!
    var keyChainMasterData = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCellId") as? ListViewCell{
            cell.configureListCell(keyChainMasterData[indexPath.row])
            return cell
        }else{
            return ListViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyChainMasterData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dataSentToDetailVC = dictToDetailArray(keyChainMasterData[indexPath.row])
        performSegueWithIdentifier("listToDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToDetail"){
            let detailVC = segue.destinationViewController as! DetailViewVC
            detailVC.dataSentFromListView = dataSentToDetailVC
        }
    }
    
    func dictToDetailArray(dataDict: Dictionary<String, String>) -> [Dictionary<String, String>]{
        var dataArray = [Dictionary<String, String>]()
        for dataKey in ORDER_OF_KEYS{
            if let value = dataDict[dataKey]{
                dataArray.append([dataKey: value])
            }
        }
        return dataArray
    }
    

}
