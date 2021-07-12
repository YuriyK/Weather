//
//  SearchViewController.swift
//  Weather
//
//  Created by Yuriy Klymenkp on 03.06.2021.
//

import UIKit

class SearchViewController: UIViewController {

    var networkDataFetcher = NetworkDataFetcher()
    var containerView = UIView()
    let lText = UILabel(text: "City", font: .systemFont(ofSize: 20, weight: .light))
    let tfCity = MyTextField()
    let bCancel = UIButton(title: "Cancel", titleColor: .black, backgroundColor: .clear)
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeElements()
        setupConstraints()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        lText.translatesAutoresizingMaskIntoConstraints = false
        bCancel.translatesAutoresizingMaskIntoConstraints = false
        tfCity.translatesAutoresizingMaskIntoConstraints = false
        tfCity.placeholder = "Enter city"
        lText.textAlignment = .center
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        tfCity.borderStyle = .roundedRect
        
        if let button = tfCity.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendCity), for: .touchUpInside)
        }
        bCancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    @objc private func sendCity() {
        guard let selectedCity = tfCity.text else { return }
        UserDefaults.standard.set(selectedCity, forKey: "city")
        tfCity.text = nil
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let weatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherViewController.addCompletion = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        self.present(weatherViewController, animated:true, completion:nil)
        self.view.endEditing(true)
    }
    
    @objc func cancel() {
        self.view.endEditing(true)
        tfCity.text = nil
        dismiss(animated: true, completion: nil)
    }    
}

extension SearchViewController {
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(lText)
        containerView.addSubview(tfCity)
        containerView.addSubview(bCancel)
        
        NSLayoutConstraint.activate([containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
                                     containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     containerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([tfCity.topAnchor.constraint(equalTo: lText.bottomAnchor, constant: 15),
                                     tfCity.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
                                     tfCity.trailingAnchor.constraint(equalTo: bCancel.trailingAnchor, constant: -85),
                                     tfCity.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([bCancel.topAnchor.constraint(equalTo: lText.bottomAnchor, constant: 15),
                                     bCancel.leadingAnchor.constraint(equalTo: tfCity.trailingAnchor, constant: 15),
                                     bCancel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                                     bCancel.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([lText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
                                     lText.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.view.frame.origin.y = -keyboardReact.height
        }else{
            self.view.frame.origin.y = 0
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
