//
//  MainViewController.swift
//  FinalWeather
//
//  Created by Benjamin Horner on 31/01/2017.
//  Copyright © 2017 Benjamin Horner. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyUserDefaults



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // Cell identifier
    let CellIdentifier: String = "CellIdentifier"
    
    
    // This flag is used to call for new Data
    // If this hasn't already been done
    // When the network is reachable
    var hasUpdatedData: Bool = false
    
    
    // Data sources
    var hourlyForecast: [WeatherModel] = []
    var weeklyForecast: [WeatherModel] = []

    
    // UI elements
    let header = UIView()
    let backgroundImageView = UIImageView()
    var tableView: UITableView!
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
        
        // Set the Data from cache if it exists
        if let cachedWeather = Defaults[.latestWeather] as? Data {
            let model = NSKeyedUnarchiver.unarchiveObject(with: cachedWeather) as? WeatherModel
            setCurrentWeatherData(model)
        }
        // Or set the default values
        else {
            setCurrentWeatherData(nil)
        }
        
        
        // Fetch the hourly and weekly forecast
        getHourlyForecastData()
        getWeeklyForecastData()
        
    }
    
    
    
    /////////////////////////////////////////////////////////////
    
    //    MARK: TableView datasource and delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if the section is the hourly forecast section
        // count the hourly forecast array data
        if section == 0 {
            let total = hourlyForecast.count
            if total > 0 {
                return total + 1
            }
            return total
        }
        // Else it is the weekly forecast
        // so return the weekly forecast array count
        else {
            let total = weeklyForecast.count
            if total > 0 {
                return total + 1
            }
            return total
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var data: WeatherModel?
        
        // If the section is the hourly forecast
        // Get data from that array
        if indexPath.section == 0 && indexPath.row > 0 {
            data = hourlyForecast[indexPath.row-1]
        }
        // Get the data from the weekly forecast array
        else if indexPath.row > 0 {
            data = weeklyForecast[indexPath.row-1]
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) {
            return setCellUI(cell, data: data, section: indexPath.section)
        }
        else {
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CellIdentifier)
            return setCellUI(cell, data: data, section: indexPath.section)
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
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
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
        var dateLabelTop: CGFloat = 20
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            dateLabelTop = 0
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
    fileprivate func setCellUI(_ cell: UITableViewCell, data: WeatherModel?, section: Int) -> UITableViewCell {
        
        cell.backgroundColor = HomeStylesheet.TodayComponent.TableView.Cells().backgroundColour
        cell.selectionStyle = .none
        
        if data == nil {
            if section == 0 {
                cell.textLabel?.attributedText = Typography.locationLabelTypography().string("Prochaines heures")
            }
            else {
                cell.textLabel?.attributedText = Typography.locationLabelTypography().string("Prochains jours")
            }
            return cell
        }
        
        if let date = data?.date {
            
            var string = FWDate.stringDayFromDate(date)
            
            if section == 0 {
                string = FWDate.stringHourFromDate(date)
            }
            
            if let str = string {
                cell.textLabel?.attributedText = Typography.dateLabelTypography().string(str)
            }
            
        }
        
        if section == 0 {
            if let temp = data?.temperature {
                let tempString = tempToString(temp)
                cell.detailTextLabel?.attributedText = Typography.dateLabelTypography().string("\(tempString)°")
            }
        }
        else {
            if let minTemp = data?.tempMin {
                
                if let maxTemp = data?.tempMax {
                    let minTempString = tempToString(minTemp)
                    let maxTempString = tempToString(maxTemp)
                    cell.detailTextLabel?.attributedText = Typography.dateLabelTypography().string("\(maxTempString)°/\(minTempString)°")

                }
                
            }
        }
        
        
        if let icon = data?.icon {
            cell.imageView?.image = UIImage(named: icon)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.image? = (cell.imageView?.image?.withRenderingMode(.alwaysTemplate))!
            cell.imageView?.tintColor = GeneralStylesheet.Colours().iconColour
        }
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Network status change
    func reachabilityStatusChanged(notification: NSNotification) {
        
        // Ignore if the Data has already been updated
        guard !hasUpdatedData
            else {
                return
        }
        
        if let info = notification.userInfo {
            if let s = info[SSAReachabilityNotificationStatusItem] {
                if let reachabilityStatus = (s as AnyObject).description {
                    if reachabilityStatus == "reachable" {
                        getCurrentWeatherData()
                    }
                    log.info("reachabilityStatus \(reachabilityStatus)")
                }
            }
        }
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Data
    fileprivate func getCurrentWeatherData() {
        
        API.getCurrentWeather { (model, success) in
            
            if success && model != nil {
                log.info("Retrieved data")
                
                self.setCurrentWeatherData(model)
                self.hasUpdatedData = true
                
            }
            else {
                log.error("Failed to retrieve data")
            }
            
        }
        
    }
    
    
    fileprivate func getHourlyForecastData() {
        
        API.getHourlyForecast { (models, success) in
            if success {
                
                log.info("Retrieved data for hourly forecast")
                
                self.hourlyForecast = models
                self.tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.none)
                
            }
            else {
                log.error("Failed to retrieve data for hourly forecast")
            }
        }
        
    }
    
    
    fileprivate func getWeeklyForecastData() {
        
        API.getWeeklyForecast { (models, success) in
            if success {
                log.info("Retrieved data for weekly forecast")
                
                self.weeklyForecast = models
                self.tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.none)
                
            }
            else {
                log.error("Failed to retrieve data for weekly forecast")
            }
        }
        
    }
    
    
    fileprivate func setCurrentWeatherData(_ model: WeatherModel?) {
        
       
        if let date = model?.date {
            if let dateString = FWDate.stringFromDate(date) {
                dateLabel.attributedText = Typography.dateLabelTypography().string(dateString)
            }
        }
        else {
            if let dateString = FWDate.stringFromDate(Date()) {
                dateLabel.attributedText = Typography.dateLabelTypography().string(dateString)
            }
        }
        
        if let location = model?.location {
            locationLabel.attributedText = Typography.locationLabelTypography().string(location)
        }
        else {
            locationLabel.attributedText = Typography.locationLabelTypography().string("- -")
        }
        
        if let speed = model?.windSpeed {
            currentWindLabel.attributedText = Typography.dateLabelTypography().string("\(String(speed))km/h")
        }
        else {
            currentWindLabel.attributedText = Typography.dateLabelTypography().string("0km/h")
        }
        
        if let humidity = model?.humidity {
            currentHumidityLabel.attributedText = Typography.dateLabelTypography().string("\(String(humidity))%")
        }
        else {
            currentHumidityLabel.attributedText = Typography.dateLabelTypography().string("0%")
        }
        
        if let temperature = model?.temperature {
            
            let temperatureRound = tempToString(temperature)
            temperatureLabel.attributedText = Typography.currentTemperatureLabelTypography().string("\(temperatureRound)°")
            
        }
        else {
            temperatureLabel.attributedText = Typography.currentTemperatureLabelTypography().string("0°")
        }
        
        if let tempMin = model?.tempMin {
            if let tempMax = model?.tempMax {
                
                let tempMinRound = tempToString(tempMin)
                let tempMaxRound = tempToString(tempMax)
                minMaxTemperature.attributedText = Typography.dateLabelTypography().string("\(tempMaxRound)°/\(tempMinRound)°")
                
            }
        }
        else {
            minMaxTemperature.attributedText = Typography.dateLabelTypography().string("0°/0°")
        }
            
            
        // Set weather icon
        if let icon = model?.icon {
            currentWeatherIcon.image = UIImage(named: icon)
        }
        currentWeatherIcon.image? = (currentWeatherIcon.image?.withRenderingMode(.alwaysTemplate))!
        currentWeatherIcon.tintColor = GeneralStylesheet.Colours().iconColour
        
    }
    
    
    // Set temperature to String
    fileprivate func tempToString(_ temp: Float) -> String {
        return String(Int(round(temp)))
    }
    
    
    
    /////////////////////////////////////////////////////////////
    
    // MARK: Orientation change
    @objc fileprivate func didRotateToOrientation() {
        
        tableView.frame = HomeStylesheet.TodayComponent.TableView().frame
        header.frame = HomeStylesheet.TodayComponent.Header().frame
        tableView.tableHeaderView = header
        setConstraints()
    }
    
    
    

    /////////////////////////////////////////////////////////////
    
    // MARK: ScrollView delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        <#code#>
    }
}

