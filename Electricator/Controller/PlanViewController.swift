//
//  ViewController.swift
//  Electricator
//
//  Created by Arif Rahman on 31/03/21.
//

import UIKit

class PlanViewController: UIViewController {
    
    @IBOutlet weak var applianceTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView(){
        /*if dataIsExist() {
            emptyView.isHidden = true
            applianceTableView.isHidden = false
        }else{*/
            emptyView.isHidden = false
            applianceTableView.isHidden = true
        //}
    }
    
    private func dataIsExist() -> Bool {
        let a = CoreDataManager.manager.fetchAppliances()
        if a.isEmpty {
            return false
        }else{
            return true
        }
    }
}

