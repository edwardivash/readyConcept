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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origin = CLLocationCoordinate2DMake(54.794503, 26.190763)
        let destination = CLLocationCoordinate2DMake(54.779834, 26.194826)
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
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
}
