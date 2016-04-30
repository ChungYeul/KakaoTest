//
//  KKOSecondViewController.swift
//  KakaoTest
//
//  Created by In Chung Yeul on 2016. 4. 30..
//  Copyright © 2016년 inchung. All rights reserved.
//

import UIKit
@objc (KKOSecondViewController)
class KKOSecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var arrTitleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "VC02"
        let defaults = NSUserDefaults.standardUserDefaults()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let name = defaults.arrayForKey("TitleList") as? Array<String> {
                self.arrTitleList = name
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitleList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.arrTitleList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! KKOSecondTableViewCell
        cell.lblTitle?.text = row
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.arrTitleList.removeAtIndex(indexPath.row)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(self.arrTitleList, forKey: "TitleList")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let thirdVC = self.storyboard?.instantiateViewControllerWithIdentifier("KKOThirdVC") as? KKOThirdViewController{
            thirdVC.sTitle = self.arrTitleList[indexPath.row]
            //            self.presentViewController(thirdVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}
