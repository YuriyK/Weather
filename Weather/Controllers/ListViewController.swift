//
//  ListViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController {
    
    var city: [CurrentWeather] = []
    var listCity: [CurrentWeather] = []
    var geoCity: [CurrentWeather] = []
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    var networkDataFetcher = NetworkDataFetcher()
    var collectionView: UICollectionView!
    var tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.hidesBarsOnSwipe = true
        navigationItem.title = "ListCities"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTapped))
        
        (CurrentWeather(currentWeatherData: nil)).map { geoCity = [$0] }
        //        (CurrentWeather(currentWeatherData: nil)).map { listCity = [$0] }
        
        DispatchQueue.global().async {
            self.networkDataFetcher.fetchByCityName(city: "london") { (currentWeather) in
                guard let currentWeather = currentWeather else { return }
                let current = Array(arrayLiteral: currentWeather)
                self.geoCity = current
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
//        DispatchQueue.main.async {
//            self.updateInterface()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        self.tabBarController?.tabBar.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        DispatchQueue.main.async {
            self.addToListCities()
            self.city = StorageManager.shared.getCities()
            self.listCity = self.city
            self.setupTableView()
        }
        DispatchQueue.main.async {
            self.updateInterface()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        updateInterface()
    }
    
    @objc func addTapped() {
        let searchViewController = SearchViewController()
        searchViewController.modalPresentationStyle = .currentContext
        present(searchViewController, animated: true)
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func addToListCities() {
        guard let nameCity = UserDefaults.standard.value(forKey: "city") else { return }
        networkDataFetcher.fetchByCityName(city: nameCity as! String) { [weak self] currentWeather in
            guard let self = self else { return }
            guard let currentWeather = currentWeather else { return }
            DispatchQueue.main.async {
                self.listCity.append(currentWeather)
                StorageManager.shared.saveCity(self.listCity)
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            UserDefaults.standard.removeObject(forKey: "city")
        }
    }
    
    private func updateInterface() {
        let cities = self.city.map { $0.cityName }
        for city in cities {
            self.networkDataFetcher.fetchByCityName(city: city ?? "") { [weak self] currentWeather in
                guard let self = self else { return }
                guard let currentWeather = currentWeather else { return }
                self.listCity.append(currentWeather)
                StorageManager.shared.saveCity(self.listCity)
                self.tableView.reloadData()
                if let index = self.listCity.firstIndex(of: currentWeather) {
                    self.listCity.remove(at: index)
                }
                StorageManager.shared.saveCity(self.listCity)
                self.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .black
        tableView.layer.borderWidth = 1
        tableView.alwaysBounceVertical = true
        
        view.addSubview(tableView)
        
        self.showSpinner()
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
            self.removeSpinner()
        }
        
        self.tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.tableFooterView = UIView()
    }
}

// MARK: - CLLocationManagerDelegate

extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        DispatchQueue.global().async {
            self.networkDataFetcher.fetchByCoordinate(latitude: latitude, longitude: longitude) { [weak self] currentWeather in
                guard let self = self else { return }
                guard let currentWeather = currentWeather else { return }
                let current = Array(arrayLiteral: currentWeather)
                self.geoCity = current
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return geoCity.count
        }
        return listCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        if indexPath.section == 0 {
            (cell as?  ListCell)?.configure(with: self.geoCity[indexPath.row])
            cell.contentView.backgroundColor = .clear
            return cell
        }
        (cell as?  ListCell)?.configure(with: self.listCity[indexPath.row])
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newCity: CurrentWeather?
        if indexPath.section == 0 {
            self.tabBarController?.selectedIndex = 1
        } else {
            newCity = listCity[indexPath.item]
            displayWeather(newCity)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func displayWeather(_ newCity: CurrentWeather?) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let weatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.city = newCity
        self.present(weatherViewController, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if indexPath.section == 1 {
                var newCity: CurrentWeather
                newCity = self.listCity[indexPath.row]
                self.listCity.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                var new = StorageManager.shared.getCities()
                if let index = new.firstIndex(of: newCity) {
                    new.remove(at: index)
                }
                StorageManager.shared.saveCity(new)
                tableView.reloadData()
                completionHandler(true)
            } else { return }
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}
