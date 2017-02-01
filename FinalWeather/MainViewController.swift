//
//  MainViewController.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit
import SnapKit



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // Cell identifier
    let CellIdentifier: String = "CellIdentifier"

    
    // UI elements
    let header = UIView()
    let backgroundImageView = UIImageView()
    let tableView = UITableView()
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    let currentWindLabel = UILabel()
    let currentWindIcon = UIImageView()
    let currentHumidityLabel = UILabel()
    let currentHumidityIcon = UIImageView()
    let currentWeatherIcon = UIImageView()
    let temperatureLabel = UILabel()
    let minMaxTemperature = UILabel()
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for network changes
        SSASwiftReachability.sharedManager?.startMonitoring()
        
        // Listen For Network Reachability Changes
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged(notification:)), name:   NSNotification.Name(rawValue: SSAReachabilityDidChangeNotification), object: nil)
        
        // Listent to rotations
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateToOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        
        // Set the UI as soon as the View controller is loaded
        setUI()
        
        // Retrieve the data from the API
        getData()
        
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
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: UI
    fileprivate func setUI() {
        
        
        // Set the background image view
        backgroundImageView.image = UIImage(named: HomeStylesheet.TodayComponent.Global().backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        
        
        // Set the tableview that will hold all the data
        tableView.backgroundColor = GeneralStylesheet.Colours().tableViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        tableView.separatorColor = GeneralStylesheet.Colours().tableViewSeparators
        
        
        // Add the elements to the UI
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        
        
        // Create the header view
        // The header view is the view that will be showing the current day forecast
        createHeaderView()
        
        
        // Add a Blur view as the background view of the tableview
        // This blur effect will fade in/out depending on scroll value
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        tableView.backgroundView = blurView
        tableView.backgroundView?.alpha = 0
        backgroundImageView.alpha = 0.6
        
        
        // Set the UI Styles once the UI is in place
        setUIStyles()
        
        
        // TODO: Remove
        setData()
        
    }
    
    
    //    Set general styles for the view
    fileprivate func setUIStyles() {
        
        view.backgroundColor = GeneralStylesheet.Colours().background
        
    }
    
    
    //    Create the header view
    fileprivate func createHeaderView() {
        
        
        header.frame = HomeStylesheet.TodayComponent.Header().frame
        
        // TODO: Set the backgroundColor depending on time of day
        // header.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        
        
        // Set the elements' styles
        currentWeatherIcon.contentMode = .scaleAspectFit
        currentWindIcon.contentMode = .scaleAspectFit
        currentHumidityIcon.contentMode = .scaleAspectFit
        currentWindIcon.image = HomeStylesheet.TodayComponent.Header().windIcon
        currentHumidityIcon.image = HomeStylesheet.TodayComponent.Header().humidityIcon
        
        
        // Make all images white
        currentWindIcon.image? = (currentWindIcon.image?.withRenderingMode(.alwaysTemplate))!
        currentWindIcon.tintColor = GeneralStylesheet.Colours().iconColour
        currentHumidityIcon.image? = (currentHumidityIcon.image?.withRenderingMode(.alwaysTemplate))!
        currentHumidityIcon.tintColor = GeneralStylesheet.Colours().iconColour
        
        
        // Add the elements to the header
        header.addSubview(dateLabel)
        header.addSubview(locationLabel)
        header.addSubview(currentWindIcon)
        header.addSubview(currentWindLabel)
        header.addSubview(currentHumidityIcon)
        header.addSubview(currentHumidityLabel)
        header.addSubview(currentWeatherIcon)
        header.addSubview(temperatureLabel)
        header.addSubview(minMaxTemperature)

    }
    
    
    
    // Set constraints
    fileprivate func setConstraints() {
        
        
        // Place the elements in the header
        // Relative to each other
        // Using SnapKit http://snapkit.io/docs/
        
        
        // Change values depending on orientation
        var dateLabelTop: CGFloat = 40
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            dateLabelTop = 20
        }
        
        
        // Set the table header's elemenst constraints
        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(header).offset(dateLabelTop)
            make.left.equalTo(header).offset(20)
            make.right.equalTo(header).offset(-20)
        }
        
        locationLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(header).offset(20)
            make.right.equalTo(header).offset(-20)
        }
        
        currentWeatherIcon.snp.remakeConstraints { (make) in
            make.top.lessThanOrEqualTo(locationLabel.snp.bottom).offset(60)
            make.right.equalTo(header).offset(-20)
            make.left.greaterThanOrEqualTo(currentHumidityLabel.snp.right).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(currentWeatherIcon.snp.height)
        }
        
        currentWindIcon.snp.remakeConstraints { (make) in
            make.left.equalTo(header).offset(20)
            make.height.equalTo(10)
            make.width.equalTo(10)
            make.centerY.equalTo(currentWindLabel)
        }
        
        currentWindLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(currentWeatherIcon)
            make.left.equalTo(currentWindIcon.snp.right).offset(8)
        }
        
        currentHumidityIcon.snp.remakeConstraints { (make) in
            make.left.equalTo(currentWindLabel.snp.right).offset(20)
            make.height.equalTo(10)
            make.width.equalTo(7)
            make.centerY.equalTo(currentHumidityLabel)
        }
        
        currentHumidityLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(currentWeatherIcon)
            make.left.equalTo(currentHumidityIcon.snp.right).offset(8)
        }
        
        temperatureLabel.snp.remakeConstraints { (make) in
            make.top.greaterThanOrEqualTo(currentWeatherIcon.snp.bottom)
            make.centerX.equalTo(header)
            make.centerY.equalTo(header)
        }
        
        minMaxTemperature.snp.remakeConstraints { (make) in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.left.equalTo(header).offset(20)
            make.right.equalTo(header).offset(-20)
        }
        
    }
    
    
    
    // Set Cell UI
    fileprivate func setCellUI(_ cell: UITableViewCell) -> UITableViewCell {
        
        cell.backgroundColor = HomeStylesheet.TodayComponent.TableView.Cells().backgroundColour
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.blue
        cell.detailTextLabel?.textColor = UIColor.orange
        
        return cell
        
    }
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Network status change
    func reachabilityStatusChanged(notification: NSNotification) {
        if let info = notification.userInfo {
            if let s = info[SSAReachabilityNotificationStatusItem] {
                if let reachabilityStatus = (s as AnyObject).description {
                    log.info("reachabilityStatus \(reachabilityStatus)")
                }
            }
        }
    }
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Data
    fileprivate func getData() {
        
        API.getCurrentWeather { (model, success) in
            
            if success {
                log.info("Retrieved data")
            }
            else {
                log.error("Failed to retrieve data")
            }
            
        }
        
    }
    
    
    fileprivate func setData() {
        
        
        dateLabel.attributedText = Typography.dateLabelTypography().string("Wednesday, February 1")
        locationLabel.attributedText = Typography.locationLabelTypography().string("Lyon")
        
        currentWindLabel.attributedText = Typography.dateLabelTypography().string("30km/h")
        currentHumidityLabel.attributedText = Typography.dateLabelTypography().string("80%")
        
        temperatureLabel.attributedText = Typography.currentTemperatureLabelTypography().string("12°")
        
        minMaxTemperature.attributedText = Typography.dateLabelTypography().string("14°/11°")
            
            
        // Set weather icon
        currentWeatherIcon.image = UIImage(named: "01d")
        currentWeatherIcon.image? = (currentWeatherIcon.image?.withRenderingMode(.alwaysTemplate))!
        currentWeatherIcon.tintColor = GeneralStylesheet.Colours().iconColour
        
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Orientation change
    @objc fileprivate func didRotateToOrientation() {
        
        tableView.frame = HomeStylesheet.TodayComponent.Header().frame
        header.frame = HomeStylesheet.TodayComponent.Header().frame
        tableView.tableHeaderView = header
        setConstraints()
    }

}

