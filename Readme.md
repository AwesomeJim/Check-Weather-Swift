 
#  Check-Weather-Swift
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

This repository is a weather application to display the current weather ☔  at the user’s location and a
5-day forecast using the  [Open Weather API](https://openweathermap.org/api) built with swift and UIKit


Objective of the Project 
---------------
This challenge is aimed at testing my ability to implement API as The best way to learn coding is by coding 

✨Application Features:
--------------
This app enable users to:
- See the weather details as well as a 5 days forecast of their current location
- Search a location and see the weather details 


# [Screenshots 📱](Screenshots/)

|                            Home       (Dark Theme)                            |                           Home  (Light Theme)                            |
|:-----------------------------------------------------------------------------:|:------------------------------------------------------------------------:|
| <img src="Screenshots/Screenshot_home_dark.png" width="300px" height="600px"> | <img src="Screenshots/Screenshot_home.png" width="300px" height="600px"> |

|                            More Details (Dark Theme)                            |                               (Light Theme)                                |
|:-------------------------------------------------------------------------------:|:--------------------------------------------------------------------------:|
| <img src="Screenshots/Screenshot_detail_dark.png" width="300px" height="600px"> | <img src="Screenshots/Screenshot_detail.png" width="300px" height="600px"> |


## Tech-stack used 🛠
| **Tech Tools**                                           | **Usage/Purpose** |
|----------------------------------------------------------|-------------------|
| [Swift](https://www.swift.org/)                          | Language          |
| [UIKit](https://developer.apple.com/documentation/uikit) | UI                |

---
## Development Setup ⚙️ and Pre-requisite 📝
**The Project uses OpenWeather API :**
1. [OpenWeather API 🔑](https://openweathermap.org/current) for Weather Data and.


#### _⚙️ Setup Weather Data API_

![openweathermap.png](Screenshots/openweathermap.png) <br/>
This project fetches weather data from the [OpenWeather API](https://openweathermap.org/current).  
To begin the setup, you'll need to create an account and get a free API key.
1. Create an account at [openweathermap.org](https://home.openweathermap.org/api_keys)
2. Go to settings from the profile icon
3. Click on API
4. Click on Create

create a Config file  `Config.xcconfig` and place your API config there 

```swift
#Insert at ~/ Config.xcconfig

// Configuration settings file format documentation can be found at:
// https://help.apple.com/xcode/#/dev745c5c974
//
API_KEY = <Your API Key>
````

## Build and Runtime Requirements
+ Xcode 14.0 or later
+ iOS v13.0 or later
+ macOS v10.10 or later

## Configuring and Running the Project

Configuring the Xcode project requires a few steps in Xcode to get up and running
1) Configure each Mac and iOS device you plan to test, Create or use an existing Apple ID account.
2) Clone or download the App
3) Open the cloned or downloaded project
4) Configure the Team for each target within the project.
    - Open the project in the Project navigator within Xcode and select each of the targets. Set the Team on the General tab to the team associated with your developer account.
5)  Ensure iOS Developer is chosen for the Code Signing Identity setting in the Code Signing section of Target > Build Settings for the following Targets, and change the Build identifier (package id/name)
6) Select the Device you want the App to run on and Click run


License
--------

      Check-Weather-Swift
      Copyright (c) 2021 Awesome Jim (https://github.com/AwesomeJim/Check-Weather-Swift).

      Licensed under the Apache License, Version 2.0 (the "License");
      you may not use this file except in compliance with the License.
      You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      See the License for the specific language governing permissions and
      limitations under the License.
