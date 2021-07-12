//
//  NewWeatherViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 19.05.2021.
//

import UIKit
import CoreLocation

class NewWeatherViewController: UIViewController {
    
    enum Section: Int, CaseIterable, Hashable {
        case  current, hourly, daily
    }
    
    var background: UIImageView = UIImageView()
    var cityObject: [CurrentWeather] = []
    var index = 0
    var itemsDaily: [DailyWeather] = []
    var itemsHourly: [HourlyWeather] = []
    var itemsCurrent: [CurrentWeather] = []
    var timer: Timer?
    var networkDataFetcher = NetworkDataFetcher()
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    var collectionView: UICollectionView!
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (CurrentWeather(currentWeatherData: nil)).map { itemsCurrent = [$0] }
        HourlyWeather().map { itemsHourly = [$0] }
        DailyWeather().map { itemsDaily = [$0] }
        
                DispatchQueue.global().async {
                    self.networkDataFetcher.fetchByCityName(city: "london") { (currentWeather) in
                        guard let currentWeather = currentWeather else { return }
                        let current = Array(arrayLiteral: currentWeather)
                        self.itemsCurrent = current
                        DispatchQueue.main.async {
                            self.reloadData()
                        }
                    }
                    self.networkDataFetcher.fetchDailyWeather(latitude: 51.5, longitude: 0.12) { [weak self] dailyWeather in
                        guard let dailyWeather = dailyWeather else { return }
                        self?.itemsDaily = dailyWeather
                        DispatchQueue.main.async {
                            self?.reloadData()
                        }
                    }
                    self.networkDataFetcher.fetchHourlyWeather(latitude: 51.5, longitude: 0.12) { [weak self] hourlyWeather in
                        guard let hourlyWeather = hourlyWeather else { return }
                        self?.itemsHourly = hourlyWeather
                        DispatchQueue.main.async {
                            self?.reloadData()
                        }
                    }
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupCollectionView()
        createDataSource()
        reloadData()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.backgroundView = background
        view.addSubview(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .never
        background.contentMode = .scaleAspectFill
        
        self.showSpinner()
        timer?.invalidate()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.removeSpinner()
        }
        
        self.collectionView.register(UINib(nibName: "DailyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DailyCell")
        self.collectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCell")
        self.collectionView.register(UINib(nibName: "CurrentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CurrentCell")
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        defer {
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
        snapshot.appendSections([.current, .hourly, .daily])
        snapshot.appendItems(itemsCurrent, toSection: .current)
        snapshot.appendItems(itemsHourly, toSection: .hourly)
        snapshot.appendItems(itemsDaily, toSection: .daily)
    }
}

// MARK: - Data Source
extension NewWeatherViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .current:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentCell", for: indexPath) as? CurrentCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: self.itemsCurrent[indexPath.item])
                cell.contentView.backgroundColor = .clear
                return cell
            case .hourly:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath)
                (cell as? HourlyCollectionViewCell)?.configure(with: self.itemsHourly[indexPath.item])
                cell.contentView.backgroundColor = .clear
                return cell
            case .daily:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath)
                (cell as? DailyCollectionViewCell)?.configure(with: self.itemsDaily[indexPath.item])
                cell.contentView.backgroundColor = .clear
                return cell
            }
        })
    }
}

// MARK: - Setup layout
extension NewWeatherViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .daily:
                return self.createItemsDaily()
            case .hourly:
                return self.createItemsHourly()
            case .current:
                return self.createItemsCurrent()
            }
        }
        return layout
    }
    
    private func createItemsHourly() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(90),
                                               heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createItemsDaily() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(38))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    private func createItemsCurrent() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
}

// MARK: - CLLocationManagerDelegate
extension NewWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        DispatchQueue.global().async {
            self.networkDataFetcher.fetchByCoordinate(latitude: latitude, longitude: longitude) { [weak self] currentWeather in
                DispatchQueue.main.async {
                    guard let currentWeather = currentWeather else { return }
                    let current = Array(arrayLiteral: currentWeather)
                    switch current[0].conditionCode ?? 0 {
                    case 200...232: self?.background.image = UIImage(named: "sketch4")
                    case 300...321: self?.background.image = UIImage(named: "sketch4")
                    case 500...531: self?.background.image = UIImage(named: "sketch4")
                    case 600...622: self?.background.image = UIImage(named: "sketch4")
                    case 701...781: self?.background.image = UIImage(named: "sketch4")
                    case 800: self?.background.image = UIImage(named: "sketch4")
                    case 801...804: self?.background.image = UIImage(named: "sketch4")
                    default: self?.background.image = UIImage(named: "sketch4")
                    }
                    self?.itemsCurrent = current
                    DispatchQueue.main.async {
                        self?.reloadData()
                    }
                }
            }
            
            self.networkDataFetcher.fetchHourlyWeather(latitude: latitude, longitude: longitude) { [weak self] hourlyWeather in
                guard let hourlyWeather = hourlyWeather else { return }
                self?.itemsHourly = hourlyWeather
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
            
            self.networkDataFetcher.fetchDailyWeather(latitude: latitude, longitude: longitude) { [weak self] dailyWeather in
                guard let dailyWeather = dailyWeather else { return }
                var array: [DailyWeather] = []
                for day in dailyWeather {
                    if ((array.filter({$0.day == day.day}).count) == 0) {
                        array.append(day)
                    }
                }
                self?.itemsDaily = array
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
