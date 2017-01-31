//
//  MainViewController.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit
import SnapKit



class MainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    let CellIdentifier: String = "CellIdentifier"
    
    // UI elements
    let tableView = UITableView()
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI as soon as the View controller is loaded
        setUI()
        
    }
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    //    MARK: TableView datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) {
            return setCellUI(cell)
        }
        else {
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CellIdentifier)
            return setCellUI(cell)
        }
        
        
        
    }
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    //    MARK: UI
    fileprivate func setUI() {
        
        // Set the tableview that will hold all the data
        tableView.backgroundColor = GeneralStylesheet.Colours().tableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        tableView.separatorColor = GeneralStylesheet.Colours().tableViewSeparators
        tableView.frame = view.bounds
        
        
        // Create the header view
        // The header view is the view that will be showing the current day forecast
        createHeaderView()
        
        
        // Add the elements to the UI
        view.addSubview(tableView)
        
        
        
        // Set the UI Styles once the UI is in place
        setUIStyles()
        
    }
    
    
    //    Set general styles for the view
    fileprivate func setUIStyles() {
        
        view.backgroundColor = GeneralStylesheet.Colours().background
        
    }
    
    
    //    Create the header view
    fileprivate func createHeaderView() {
        
        // Create and set the header component
        let frame = HomeStylesheet.TodayComponent.Header().frame
        
        let header = UIView(frame: frame)
        header.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        
        
        // Create the elements for the header
        let dateLabel = UILabel()
        let locationLabel = UILabel()
        let windIcon = UIImageView()
        let windSpeedLabel = UILabel()
        let humidityIcon = UIImageView()
        let humidityLabel = UILabel()
        let rainIcon = UIImageView()
        let rainLabel = UILabel()
        
        
        
        // Set the elements' styles
        windIcon.image = UIImage(named: "wind")
        humidityIcon.image = UIImage(named: "humidity")
        rainIcon.image = UIImage(named: "rain")
        
        windIcon.contentMode = .center
        humidityIcon.contentMode = .center
        rainIcon.contentMode = .center
        
        
        // Add the elements to the header
        header.addSubview(dateLabel)
        
        
        // Place the elements in the header
        // Relative to each other
        // Using SnapKit http://snapkit.io/docs/
        dateLabel.backgroundColor = UIColor.red
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(header).offset(20)
            make.left.equalTo(header).offset(20)
            make.bottom.equalTo(header).offset(-20)
            make.right.equalTo(header).offset(-20)
        }
        
        
        // Add the header as the TableView header
        tableView.tableHeaderView = header
    }
    
    
    //    Set Cell UI
    fileprivate func setCellUI(_ cell: UITableViewCell) -> UITableViewCell {
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        cell.textLabel?.textColor = UIColor.blue
        cell.detailTextLabel?.textColor = UIColor.orange
        
        return cell
        
    }
    
    
    
}

