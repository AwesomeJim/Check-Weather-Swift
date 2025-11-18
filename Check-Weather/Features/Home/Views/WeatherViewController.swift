//
//  ViewController.swift
//  Clima
//
//  Created by Awesome Jimon 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
internal import Combine
import SwiftUI

class WeatherViewController: UIViewController {
    
    
    
    @IBOutlet weak var currentWeatherContainerView: UIView!
    
    @IBOutlet weak var  searchBarContainerView: UIView!
    
    @IBOutlet weak var  forecastContainerView: UIView!
    
    @IBOutlet weak var  hourlyforecastContainerView: UIView!
    
    @IBOutlet weak var hourlyForecastContainerView: UIView!
    
    
    // MARK: Properties
    var weatherForecastList:[WeatherItemModel] = []
    
    let locationManager = CLLocationManager()
    
    // 2. Add properties for the VM and subscriptions
    private var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate = self
        
        // Request for Location Permiti
        locationManager.requestWhenInUseAuthorization()
        
        //request for a 1 time location
        locationManager.requestLocation()
        
        let networkService = NetworkService()
        viewModel = WeatherViewModel(networkService: networkService)
        setupBindings()
        setupSearchBarHosting()
        setupSwiftUIHosting()
        setupForecastHosting()
        setupHourlyHosting()
        
    }
    
    private func setupHourlyHosting() {
        let swiftUIView = HourlyForecastView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        // This tells the hosting view to demand its full size
        hostingController.view.setContentHuggingPriority(.required, for: .vertical)
        hostingController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        hourlyForecastContainerView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: hourlyForecastContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: hourlyForecastContainerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: hourlyForecastContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: hourlyForecastContainerView.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        hostingController.view.backgroundColor = .clear
    }
    
    private func setupForecastHosting() {
        let swiftUIView = DayForecastView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        // This tells the hosting view to demand its full size
        hostingController.view.setContentHuggingPriority(.required, for: .vertical)
        hostingController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        
        forecastContainerView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: forecastContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: forecastContainerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: forecastContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: forecastContainerView.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        hostingController.view.backgroundColor = .clear
    }
    
    private func setupSearchBarHosting() {
        
        // 1. Create your new SwiftUI view, passing in the
        //    ViewModel this ViewController already owns.
        let swiftUIView = SearchBarView(viewModel: viewModel)
        
        // 2. Create the "Bridge" controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 3. Add the hosting controller as a child
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        // This tells the hosting view to demand its full size
        hostingController.view.setContentHuggingPriority(.required, for: .vertical)
        hostingController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // 4. Add the hosting controller's view to your container
        searchBarContainerView.addSubview(hostingController.view)
        
        // 5. Pin it to the edges of the container
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor)
        ])
        
        // 6. Complete the bridge
        hostingController.didMove(toParent: self)
        
        // 7. Make the hosting controller's background clear
        //    so we can see the view controller's background
        hostingController.view.backgroundColor = .clear
    }
    
    private func setupSwiftUIHosting() {
        
        // 1. Create your new SwiftUI view, passing in the
        //    ViewModel this ViewController already owns.
        let swiftUIView = CurrentWeatherView(viewModel: viewModel)
        
        // 2. Create the "Bridge" controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 3. Add the hosting controller as a child
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // This tells the hosting view to demand its full size
        hostingController.view.setContentHuggingPriority(.required, for: .vertical)
        hostingController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // 4. Add the hosting controller's view to your container
        currentWeatherContainerView.addSubview(hostingController.view)
        
        // 5. Pin it to the edges of the container
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: currentWeatherContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: currentWeatherContainerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: currentWeatherContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: currentWeatherContainerView.trailingAnchor)
        ])
        
        // 6. Complete the bridge
        hostingController.didMove(toParent: self)
        
        // 7. Make the hosting controller's background clear
        //    so we can see the view controller's background
        hostingController.view.backgroundColor = .clear
    }
    
    
    private func setupBindings() {
        // This is how you "subscribe" to a @Published property
        // We use [weak self] to prevent a memory leak
        // BINDING 1: Listen for changes to isLoading
        viewModel.$isLoading
            .receive(on: DispatchQueue.main) // Ensure UI work is on the main thread
            .sink { [weak self] isLoading in
                if isLoading {
                    AppUtils.logInfo("Test: ViewModel is now loading...")
                    
                } else {
                    AppUtils.logInfo("Test: ViewModel finished loading.")
                    
                }
            }
            .store(in: &cancellables) // Saves the subscription
        
        
        // BINDING 3: Listen for any errors
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let message = message else { return }
                
                AppUtils.logError("Test: ViewModel reported an error: \(message)")
                // Show an alert to the user
                self?.presentErrorAlert(error: message)
                self?.viewModel.errorMessage = nil // Clear the error after showing
            }
            .store(in: &cancellables)
        
        //        viewModel.$forecast
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] forecast in
        //                if !forecast.isEmpty {
        //                    AppUtils.logInfo("Test: ViewModel forecast Data : \(forecast.count)")
        //                    self?.weatherForecastList.removeAll()
        //                    self?.weatherForecastList.append(contentsOf: forecast)
        //
        //                }
        //            }
        //            .store(in: &cancellables)
        //
        //
        //        // This binding listens for the icons to be downloaded.
        //        viewModel.$forecastIcons
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] icons in
        //                // As icons stream in, the dictionary is updated.
        //                // Just reload the table to show them.
        //                if !icons.isEmpty {
        //
        //                }
        //            }
        //            .store(in: &cancellables)
        
        viewModel.locationRequested
            .sink { [weak self] in
                // The doorbell rang! Go get the location.
                self?.locationManager.requestLocation()
            }
            .store(in: &cancellables)
    }
    
    
    //-----------------------------------------------------------------
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetails" {
            let detailVC = segue.destination as! DetailsViewController
            detailVC.dataModel = sender as? WeatherItemModel
        }
    }
    
    //
    func makeApiCall(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.fetchWeather(for: trimmed)
    }
    
    //
    func fetchWeatherForecast(_ cityName:String){
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.fetchWeather(for: trimmed)
    }
    
}

// MARK: - Location Manger Extention

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print(lat)
            print(long)
            print("Test: Fetching weather for current location...")
            viewModel.fetchWeather(lat: location.coordinate.latitude,lon: location.coordinate.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// -------------------------------------------------------------------------
// MARK: - Table View Data Source extention

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherForecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastListCell
        let forecastItem = viewModel.dailyForecast[indexPath.row]
        cell.dateLabel.text = AppUtils.formatDate(forecastItem.locationDate)
        
        // Set the name and image
        cell.weatherDescriptionLabel.text = forecastItem.locationWeather.weatherCondition
        //let iconName = forecastItem.locationWeather.weatherConditionSfIcon
        //
        // 2. Get the icon path (e.g., "10d")
        let iconPath = forecastItem.locationWeather.weatherConditionIcon
        
        // 3. Look up the downloaded image in the VM's dictionary
        let iconImage = viewModel.forecastIcons[iconPath]
        cell.weatherConditionIcon.image = iconImage
        
        let miniTemp = WeatherUtils.formatTemperature(temperature: forecastItem.locationWeather.weatherTempMin)
        let highTemp = WeatherUtils.formatTemperature(temperature: forecastItem.locationWeather.weatherTempMax)
        
        cell.weatherTempMiniLabel.text = miniTemp
        cell.weatherTemp.text = highTemp
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherData = self.weatherForecastList[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "showDetails", sender: weatherData)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

