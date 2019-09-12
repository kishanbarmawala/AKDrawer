//
//  DateSelectionController.swift
//  AKDrawer
//
//  Created by Kishan Barmawala on 11/09/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class DateSelectionController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnCalender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCalender.layer.cornerRadius = btnCalender.bounds.height / 2
    }
    
    @IBAction func calenderTapped(_ sender: UIButton) {
        
        let CalenderVC = self.storyboard!.instantiateViewController(withIdentifier: "CALENDER") as! CalenderController
        
        CalenderVC.delegate = self
        CalenderVC.minimumDate = Date.specificDate(date: "01/01/2001", format: "dd/MM/yyyy")
        CalenderVC.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        
        CalenderVC.selectedStartDate = Date()
        CalenderVC.selectedEndDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        CalenderVC.selectedColor = #colorLiteral(red: 0.4, green: 0.6, blue: 1, alpha: 1)
        CalenderVC.titleText = "Select Date Range"
        
        CalenderVC.view.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(CalenderVC.view)
        self.addChild(CalenderVC)
        didMove(toParent: CalenderVC)
        
    }

}

extension DateSelectionController : CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        print("Cancel Tapped!")
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        if startDate != nil && endDate != nil {
            // For Start & End Date
            lblDate.text = "\(dateFormatter.string(from: startDate) + " to " + dateFormatter.string(from: endDate))"
        } else {
            // For Single Date
            lblDate.text = "\(dateFormatter.string(from: startDate))"
        }
        
        
    }
    
}
