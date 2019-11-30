//
//  CalenderController.swift
//  AKDrawer
//
//  Created by macmini3 on 31/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit

//temp commented

public protocol CalendarDateRangePickerViewControllerDelegate {
    func didCancelPickingDateRange()
    func didPickDateRange(startDate: Date!, endDate: Date!)
}

class CalenderController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var calendarView: UICollectionView!
    
    //Kishan
    
    let cellReuseIdentifier = "CalendarDateRangePickerCell"
    let headerReuseIdentifier = "CalendarDateRangePickerHeaderView"
    
    //temp commented
    
    public var delegate: CalendarDateRangePickerViewControllerDelegate!
    
    let itemsPerRow = 7
    var itemHeight = CGFloat()
    let collectionViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    public var minimumDate: Date!
    public var maximumDate: Date!
    
    public var selectedStartDate: Date?
    public var selectedEndDate: Date?
    public var scrollToIndex = IndexPath(item: 0, section: 0)
    
    public var selectedColor = UIColor(red: 66/255.0, green: 150/255.0, blue: 240/255.0, alpha: 1.0)
    public var titleText = "Select Dates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemHeight = calendarView.frame.width / 7
        //Kishan
        
        lblTitle.text = self.titleText
        
//        calendarView?.dataSource = self
//        calendarView?.delegate = self
        calendarView?.backgroundColor = UIColor.white
        
        calendarView?.register(CalendarDateRangePickerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        calendarView?.register(CalendarDateRangePickerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        calendarView?.contentInset = collectionViewInsets
        
        if minimumDate == nil {
            minimumDate = Date()
        }
        if maximumDate == nil {
            maximumDate = Calendar.current.date(byAdding: .year, value: 3, to: minimumDate)
        }
        
        //Kishan
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CalendarDateRangePickerViewController.didTapCancel))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CalendarDateRangePickerViewController.didTapDone))
//        self.navigationItem.rightBarButtonItem?.isEnabled = selectedStartDate != nil && selectedEndDate != nil
        
                    //Kishan
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Kishan
        let startYear = Int(minimumDate!.year)        //Kishan
        let currentYear = Int(Date().year)
        let calculation :Int = ((currentYear! - startYear!) * 12) + Int(Date().month)!
        self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .allowUserInteraction, animations: {
            self.view.transform = .identity
        }, completion: { (bool) in
            self.calendarView.scrollToItem(at: IndexPath(item: 0, section: calculation), at: .centeredVertically, animated: true)
        })
        
    }
    
    override func viewWillLayoutSubviews() {
        backView.layer.cornerRadius = 8.0
        outerView.layer.cornerRadius = 8.0
        outerView.layer.shadowColor = UIColor.lightGray.cgColor
        outerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        outerView.layer.shadowRadius = 8.0
        outerView.layer.shadowOpacity = 0.6
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
        if selectedStartDate == nil || selectedEndDate == nil {
            return
        }
        delegate.didPickDateRange(startDate: selectedStartDate!, endDate: selectedEndDate!)
        hideView()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        hideView()
    }
}

extension CalenderController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let difference = Calendar.current.dateComponents([.month], from: minimumDate, to: maximumDate)
        return difference.month! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let weekdayRowItems = 7
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return weekdayRowItems + blankItems + daysInMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarDateRangePickerCell
        cell.selectedColor = self.selectedColor
        cell.reset()
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        if indexPath.item < 7 {
            cell.label.text = getWeekdayLabel(weekday: indexPath.item + 1)
        } else if indexPath.item < 7 + blankItems {
            cell.label.text = ""
        } else {
            let dayOfMonth = indexPath.item - (7 + blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            cell.date = date
            cell.label.text = "\(dayOfMonth)"
            
            if isBefore(dateA: date, dateB: minimumDate) {
                cell.disable()
            }
            
            if selectedStartDate != nil && selectedEndDate != nil && isBefore(dateA: selectedStartDate!, dateB: date) && isBefore(dateA: date, dateB: selectedEndDate!) {
                // Cell falls within selected range
                if dayOfMonth == 1 {
                    cell.select()
                    //                    cell.highlight()
                    //                    cell.highlightRight()
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    cell.select()
                    //                    cell.highlight()
                    //                    cell.highlightLeft()
                } else {
                    //                    cell.highlight()
                    cell.select()
                    //                    cell.highlight()
                }
            } else if selectedStartDate != nil && areSameDay(dateA: date, dateB: selectedStartDate!) {
                // Cell is selected start date
                cell.select()
                if selectedEndDate != nil {
                    //                    cell.highlightRight()
                }
            } else if selectedEndDate != nil && areSameDay(dateA: date, dateB: selectedEndDate!) {
                cell.select()
                //                cell.highlightLeft()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! CalendarDateRangePickerHeaderView
            headerView.label.text = getMonthLabel(date: getFirstDateForSection(section: indexPath.section))
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
}

extension CalenderController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDateRangePickerCell
        if cell.date == nil {
            return
        }
        if isBefore(dateA: cell.date!, dateB: minimumDate) {
            return
        }
        if selectedStartDate == nil {
            selectedStartDate = cell.date
        } else if selectedEndDate == nil {
            if isBefore(dateA: selectedStartDate!, dateB: cell.date!) {
                selectedEndDate = cell.date
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                // If a cell before the currently selected start date is selected then just set it as the new start date
                selectedStartDate = cell.date
            }
        } else {
            selectedStartDate = cell.date
            selectedEndDate = nil
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = calendarView.frame.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: calendarView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension CalenderController {
    
    // Helper functions
    
    func getFirstDate() -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: minimumDate)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func getFirstDateForSection(section: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate())!
    }
    
    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date!)
    }
    
    func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }
    
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
    
}

extension Date {              //Kishan
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}
