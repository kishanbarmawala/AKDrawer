//
//  CalenderController.swift
//  AKDrawer
//
//  Created by macmini3 on 31/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

class CalenderController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let testCalendar = Calendar(identifier: .gregorian)
    var selection: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        calendarView.minimumInteritemSpacing = 0
        calendarView.minimumLineSpacing = 0
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.2
        calendarView.addGestureRecognizer(panGensture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: {
            self.view.transform = .identity
        }, completion: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        backView.layer.cornerRadius = 8.0
        outerView.layer.cornerRadius = 8.0
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        outerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        outerView.layer.shadowRadius = 8.0
        outerView.layer.shadowOpacity = 0.6
    }
    
    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let rangeSelectedDates = calendarView.selectedDates
        
        guard let cellState = calendarView.cellStatus(at: point) else { return }
        
        if !rangeSelectedDates.contains(cellState.date) {
            let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)
            calendarView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            let followingDay = testCalendar.date(byAdding: .day, value: 1, to: cellState.date)!
            calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
        }
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        cell.dateLabel.textColor = .white
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.roundCorners([.topLeft,.bottomLeft], radius: 8)
            
        case .middle:
            cell.selectedView.roundCorners([.topLeft,.bottomLeft,.topRight,.bottomRight], radius: 0)
            
        case .right:
            cell.selectedView.roundCorners([.topRight,.bottomRight], radius: 8)
            
        case .full:
            cell.selectedView.roundCorners([.topLeft,.bottomLeft,.topRight,.bottomRight], radius: 0)
            
        default: break
        }
    }
    
    func addAction(completionHandler: ((String) -> ())?) {
        selection = completionHandler
    }
    
    func hideView() {
        
        self.view.transform = .identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            self.view.backgroundColor = .clear
            self.view.transform = CGAffineTransform(scaleX: 0.11, y: 0.1)
        }, completion: { (Bool) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        hideView()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        hideView()
    }
}

extension CalenderController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 01 01")!
        var endDate = Date()
        endDate = formatter.date(from: "2019 12 31")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalenderController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
