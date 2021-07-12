//
//  NetworkWeatherManager.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 14.05.2021.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    private let allowedDiskSize = 10 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "gifCache")
    }()
    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        sessionConfiguration.requestCachePolicy = .reloadRevalidatingCacheData
        sessionConfiguration.urlCache = cache
        return URLSession(configuration: sessionConfiguration)
    }
    typealias DownloadCompletionHandler = (Result<Data,Error>) -> ()
    
    // MARK: - current weather
    func requestCurrentWeatherForCity(forCity city: String, currentCompletion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        download(urlString: urlString, completionHandler: currentCompletion)
    }
    
    func requestCurrentWeatherByCoordinate(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping DownloadCompletionHandler) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric"
        downloadCache(urlString: urlString, completionHandler: completionHandler)
    }
    
    // MARK: - hourly weather    
    func requestHourlyWeather(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping DownloadCompletionHandler) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric&cnt=8"
        download(urlString: urlString, completionHandler: completionHandler)
    }
    
    // MARK: - daily weather
    func requestDailyWeather(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping DownloadCompletionHandler) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric&cnt=40"
        download(urlString: urlString, completionHandler: completionHandler)
    }
}

extension NetworkWeatherManager {
    private func downloadCache(urlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        if let cachedData = cache.cachedResponse(for: urlRequest) {
            debugPrint("Cached data in bytes:", cachedData.data)
            completionHandler(.success(cachedData.data))
        } else {
            createAndRetrieveURLSession().dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completionHandler(.failure(error))
                        return
                    }
                    guard let data = data else { return }
                    let cachedData = CachedURLResponse(response: response!, data: data)
                    self.cache.storeCachedResponse(cachedData, for: urlRequest)
                    completionHandler(.success(data))
                }
            }.resume()
        }
        createAndRetrieveURLSession().dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                guard let data = data else { return }
                completionHandler(.success(data))
                let cachedData = CachedURLResponse(response: response!, data: data)
                self.cache.storeCachedResponse(cachedData, for: urlRequest)
            }
        }.resume()
    }
}

extension NetworkWeatherManager {
    private func download(urlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                guard let data = data else { return }
                completionHandler(.success(data))
            }
        }.resume()
    }
}
