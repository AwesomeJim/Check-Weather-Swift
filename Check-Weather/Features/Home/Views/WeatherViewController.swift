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
        setupMainSwiftUIHosting()
        
    }
    
    private func setupMainSwiftUIHosting() {
        // 1. Create the master view
        let swiftUIView = WeatherMainView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // 2. Add the hosting controller to the current view controller
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. Pin the hosting controller's view directly to the root view
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        // Ensure the background color is clear or the desired background color
        // (The SwiftUI view will now control the scrolling and spacing perfectly)
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
        
        viewModel.locationRequested
            .sink { [weak self] in
                // The doorbell rang! Go get the location.
                self?.locationManager.requestLocation()
            }
            .store(in: &cancellables)
        
        viewModel.didTapForecastItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherData in
                // 2. Perform the UIKit Segue!
                self?.performSegue(withIdentifier: "showDetails", sender: weatherData)
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


