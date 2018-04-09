//
//  DarkSkyClient.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 15/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

public typealias DarkSkyHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

struct DarkSkyClient {

    private static let darkSkyUrl = "https://api.darksky.net/forecast/"
    private static let darkSkyAPIKey: String? = valueForAPIKey("DARK_SKY_API_KEY")
    private static let ukSuffix   = "units=uk2"

    fileprivate let url: URL

    /// Initialises a `DarkSkyClient` with a set location.
    ///
    /// - parameter location: A location on the Earth's surface.
    /// - returns: A `DarkSkyClient` dedicated to the suppled location.
    ///
    init(location: Location) {
        if let darkSkyAPIKey = DarkSkyClient.darkSkyAPIKey {
            url = URL(string: DarkSkyClient.darkSkyUrl + darkSkyAPIKey +
                "/\(location.latitude),\(location.longitude)" +
                "?units=\(AppSettings.retrieve(key: "units", defaultValue: "auto"))")!
        } else {
            fatalError("Dark Sky API key required.")
        }
    }

    /// Initialiser: Utilises "dependency injection" to initialise the client with a predefined URL.
    ///
    /// - parameter url: A URL (usually containing test data).
    /// - returns: A `DarkSkyClient` initialised with test data.
    ///
    public init(url: URL) {
        self.url = url
    }

    func fetchData(completionHandler handler: @escaping DarkSkyHandler) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: handler)
        task.resume()
    }

    func fetchForecast(
        completionHandler: @escaping (DarkSkyForecast, DarkSkyForecastCodable) -> Void,
        errorHandler: @escaping (String) -> Void) {

        fetchData {(data, _, error) in
            guard let data = data else {
                if let error = error {
                    errorHandler(error.localizedDescription)
                }
                return
            }
            do {
                print("A")
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let forecastCodable = try decoder.decode(DarkSkyForecastCodable.self, from: data)
                print("B")
                if let json = try JSONSerialization.jsonObject(
                    with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] {
                    print("\(json)")
                    if let forecast = DarkSkyForecast(dictionary: json) {
                        completionHandler(forecast, forecastCodable)
                    } else {
                        errorHandler("Unable to create a forecast from the weather data.")
                    }
                }
                print("Z")
            } catch {
                errorHandler("Unable to read the weather data.")
            }
        }
    }
}
