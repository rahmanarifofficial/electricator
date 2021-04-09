//
//  LearnMoreViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 09/04/21.
//

import UIKit

class LearnMoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
