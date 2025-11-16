//
//  CurrentWeatherView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import SwiftUI
import _LocationEssentials

struct CurrentWeatherView: View {
    
    // 1. 'Observes' the ViewModel. It does NOT create it.
    //    The ViewController will pass in the VM it already owns.
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        
        // 2. We put the content in a ZStack to add the
        //    blurred background and rounded corners.
        ZStack {
            // 3. This is the "glassmorphic" background
            //    It's a semi-transparent blur.
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .cornerRadius(20)
            
            // 4. We only show the content if we have weather data
            if let weather = viewModel.currentWeather {
               
                // 5. This is the main UI content, laid out
                //    vertically.
                VStack(alignment: .leading, spacing: 8) {
                    
                    // "Partly cloudy" & Icon
                    HStack {
                        // We use the 'currentIcon' from the VM
                        if let icon = viewModel.currentIcon {
                            Image(uiImage: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        } else {
                            // Placeholder
                            ProgressView()
                                .frame(width: 40, height: 40)
                        }
                        
                        Text(weather.locationWeather.weatherConditionDescription.capitalized)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    
                    // "19°"
                    Text("\(weather.locationWeather.weatherTempIntString)°")
                        .font(.system(size: 80, weight: .thin))
                    
                    // "Feels like 22°"
                    Text("Feels like \(weather.locationWeather.feelsLikeIntString)°")
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    // "High 24° • Low 16°"
                    Text(weather.locationWeather.highLowString)
                        .font(.headline)
                        .fontWeight(.regular)
                }
                .padding(20) // Add padding inside the blurred box
                .foregroundColor(.white) // Make all text white
                
            } else if viewModel.isLoading {
                // Show a loading spinner
                ProgressView()
                    .scaleEffect(1.5)
            } // Check for a specific error message
             else if let errorMessage = viewModel.errorMessage {
                 VStack(spacing: 10) {
                     Image(systemName: "exclamationmark.triangle")
                         .font(.title)
                         .foregroundColor(.yellow)
                     Text(errorMessage.message)
                         .foregroundColor(.white)
                         .multilineTextAlignment(.center)
                     .padding(.horizontal) }
            }else {
                // Fallback for errors or no data
                Text("Failed to load weather")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

// --- Helper View for the Blur Effect ---
// SwiftUI doesn't have a simple .blur() background,
// so this wraps the UIKit 'UIVisualEffectView'
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { uiView.effect = effect }
}

// MARK: - Preview Provider

// 1. Create a Mock Network Service that conforms to your protocol
struct MockNetworkService: NetworkServiceProtocol {
    
    // Create static mock data
    static let mockWeather = WeatherItemModel(
        locationName: "Cupertino",
        locationId: 192710,
        locationDate: 1763305036,
        locationCoordinates: Coordinates(longitude: 36.8333, latitude: -1.1667),
        locationWeather: WeatherStatus(
            weatherConditionId: 803,
            weatherConditionIcon: "04d",
            weatherConditionDescription: "broken clouds",
            weatherTemp: 19.5,
            weatherfeelsLike: 18.9,
            weatherTempMin: 16.0,
            weatherTempMax: 24.0,
            weatherPressure: 1012,
            weatherHumidity: 60,
            weatherWind: Wind(speed: 2.5, deg: 270)
        ),
        locationWeatherDay: AppUtils.convertUTCToDayOfMonth(utcTime: Date(timeIntervalSince1970: 1763305036))
    )
    
    func getCurrentWeather(city: String) async throws -> WeatherItemModel? {
        return MockNetworkService.mockWeather
    }
    
    func getWeatherForecast(city: String) async throws -> [WeatherItemModel]?{
        return [MockNetworkService.mockWeather]
    }
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> WeatherItemModel? {
        return MockNetworkService.mockWeather
    }
    
    func getWeatherForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> [WeatherItemModel]? {
        return [MockNetworkService.mockWeather]
    }
    
    func downloadIcon(path: String) async throws -> Data {
        // Return a dummy data object for preview
        return Data()
    }
}

// 2. Create your PreviewProvider
struct CurrentWeatherView_Previews: PreviewProvider {
    
    // Helper function to create a VM in a "loaded" state
    static func makeLoadedViewModel() -> WeatherViewModel {
        let vm = WeatherViewModel(networkService: MockNetworkService())
        vm.currentWeather = MockNetworkService.mockWeather
        // Create a mock icon (a simple SF Symbol)
        vm.currentIcon = UIImage(named: "cloud.rain")?
            .withRenderingMode(.alwaysOriginal) // Use colors
        return vm
    }
    
    // Helper function to create a VM in a "loading" state
    static func makeLoadingViewModel() -> WeatherViewModel {
        let vm = WeatherViewModel(networkService: MockNetworkService())
        vm.isLoading = true
        return vm
    }
    
    // Helper function to create a VM in an "error" state
    static func makeErrorViewModel() -> WeatherViewModel {
        let vm = WeatherViewModel(networkService: MockNetworkService())
        vm.errorMessage = AppError(title: "An Error Occurred", message: "Failed to connect to server. Please try again.")
        return vm
    }

    static var previews: some View {
        // We use a ZStack with a color to simulate
        // the background of your app
        ZStack {
            // Simulate the blue-ish background from your target
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.7), .blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Preview 1: The "Loaded" state
            CurrentWeatherView(viewModel: makeLoadedViewModel())
                .padding()
                .previewDisplayName("Loaded State")
            
//            // Preview 2: The "Loading" state
//            CurrentWeatherView(viewModel: makeLoadingViewModel())
//                .padding()
//                .previewDisplayName("Loading State")
            
//            // Preview 3: The "Error" state
//            CurrentWeatherView(viewModel: makeErrorViewModel())
//                .padding()
//                .previewDisplayName("Error State")
        }
    }
}
