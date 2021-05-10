//
//  NavigationVC.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 6.05.21.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class NavigationVC: UIViewController {
    
    var origin = CLLocationCoordinate2D()
    var destination = CLLocationCoordinate2D()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityInd = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        activityInd.startAnimating()
        return activityInd
    }()

// MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        view.backgroundColor = .lightGray
        
        origin = CLLocationCoordinate2DMake(54.794503, 26.190763)
        destination = CLLocationCoordinate2DMake(54.779834, 26.194826)
        
        startNavigating(origin: origin, destination: destination)
    }
    
// MARK: Private methods
    
    private func startNavigating(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let options = NavigationRouteOptions(coordinates: [origin, destination])
        
        Directions.shared.calculate(options) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                
                let navigationService = MapboxNavigationService(route: route, routeIndex: 0, routeOptions: options, simulating: .always)
                let navigationOptions = NavigationOptions(navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: route, routeIndex: 0, routeOptions: options, navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                
                strongSelf.present(navigationViewController, animated: true) {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
