//
//  DatePicker.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 4.05.2024.
//

import UIKit

class DatePicker: UIViewController {

    var textField: UITextField!
    var datePicker: UIDatePicker!
    
    var completion : ((String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func dateButton() {
        let targetDate = datePicker.date
    }
}
