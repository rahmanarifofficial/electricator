//
//  RepeatDayViewController.swift
//  Electricator
//
//  Created by Andrean Lay on 07/04/21.
//

import UIKit

protocol RepeatDataDelegate {
    func passData(data: [String])
}

class RepeatDayCell: UITableViewCell {
    @IBOutlet weak var repeatDayLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
}

class RepeatDayViewController: UITableViewController {
    var delegate: RepeatDataDelegate?
    var repeatDay = [
        ("Sunday", false),
        ("Monday", false),
        ("Tuesday", false),
        ("Wednesday", false),
        ("Thursday", false),
        ("Friday", false),
        ("Saturday", false)
    ]
    var abbreviatedDay = [
        "Sunday": "SUN",
        "Monday": "MON",
        "Tuesday": "TUE",
        "Wednesday": "WED",
        "Thursday": "THU",
        "Friday": "FRI",
        "Saturday": "SAT"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    
    func setupNavBar() {
        title = "Repeat"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        var convertedData = [String]()
        
        for (day, repeated) in repeatDay {
            if repeated {
                convertedData.append(abbreviatedDay[day]!)
            }
        }
        
        delegate?.passData(data: convertedData)
        self.dismiss(animated: true, completion: nil)
    }
}

extension RepeatDayViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatDay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatDayCell") as! RepeatDayCell
        
        let day = repeatDay[indexPath.row].0
        cell.repeatDayLabel.text = "Every \(day)"
        cell.checkMark.isHidden = !repeatDay[indexPath.row].1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repeatDay[indexPath.row].1.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
