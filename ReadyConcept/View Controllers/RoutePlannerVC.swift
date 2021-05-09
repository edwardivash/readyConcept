//
//  RoutePlannerVC.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 8.05.21.
//

import UIKit
import Mapbox
import MapboxNavigation

let leftBarItemTitle = "Cancel"
let rightBarItemTitle = "Save"
let vcTitle = "Route Planner"
let undoBarbuttonImg = "undoBarbuttonItem"
let redoBarbuttonImg = "redoBarbuttonItem"
let markerBarbuttonImg = "markerBarbuttonItem"
let selectedMarkerBarbuttonImg = "selectedMarkerItem"
let routeBarbuttonImg = "routeBarbuttonItem"
let selectedRouteBarbuttonImg = "selectedRouteItem"
let colorBarbuttonImg = "colorBarbuttonItem"

class RoutePlannerVC: UIViewController {
    
// MARK: Properties
    
    lazy var flexibleSpace: UIBarButtonItem = {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        return flexibleSpace
    }()
    
    lazy var leftArrow: UIBarButtonItem = {
        let left = UIBarButtonItem(image: UIImage(named: undoBarbuttonImg), style: .plain, target: self, action: nil)
        return left
    }()

    lazy var rightArrow: UIBarButtonItem = {
        let rigt = UIBarButtonItem(image: UIImage(named: redoBarbuttonImg), style: .plain, target: self, action: nil)
        return rigt
    }()
    
    lazy var markerButton: UIButton = {
       let markerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        markerButton.setImage(UIImage(named: markerBarbuttonImg), for: .normal)
        markerButton.setImage(UIImage(named: selectedMarkerBarbuttonImg), for: .selected)
        markerButton.addTarget(self, action: #selector(markerAction(_:)), for: .touchUpInside)
        return markerButton
    }()

    lazy var routeButton: UIButton = {
        let routeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        routeButton.setImage(UIImage(named: routeBarbuttonImg), for: .normal)
        routeButton.setImage(UIImage(named: selectedRouteBarbuttonImg), for: .selected)
        routeButton.addTarget(self, action: #selector(routeAction(_:)), for: .touchUpInside)
        return routeButton
    }()

    lazy var routeColorButton: UIBarButtonItem = {
        let routeClrBtn = UIBarButtonItem(image: UIImage(named: colorBarbuttonImg), style: .plain, target: self, action: nil)
        routeClrBtn.tintColor = UIColor(red: 0, green: 68 / 255, blue: 100 / 255, alpha: 1)
        return routeClrBtn
    }()
    
    private lazy var mapView: NavigationMapView? = {
        let mapView = NavigationMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 54.794503, longitude: 26.190763), zoomLevel: 8, animated: false)
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        mapView.compassView.compassVisibility = .hidden
        return mapView
    }()
    
    lazy var toolBarWithButtons: UIToolbar = {
        let toolBarr = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBarr.translatesAutoresizingMaskIntoConstraints = false
        toolBarr.tintColor = .white
        toolBarr.barTintColor = .darkGray
        toolBarr.isTranslucent = false
        toolBarr.setItems([leftArrow,flexibleSpace,rightArrow,flexibleSpace,UIBarButtonItem(customView: markerButton),flexibleSpace, UIBarButtonItem(customView: routeButton),flexibleSpace,routeColorButton], animated: false)
        return toolBarr
    }()
    
// MARK: VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        customizeToolBar()
        setupMapView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        customizeNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let nvc = navigationController {
            nvc.navigationBar.isHidden = true
        }
    }
    
// Private methods
    
    private func customizeNavigationBar() {
        if let nvc = navigationController {
            nvc.navigationBar.isHidden = false
            nvc.navigationBar.barTintColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1.0)
            nvc.navigationBar.tintColor = UIColor.white
            nvc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarItemTitle, style: .done, target: self, action: #selector(saveNewRoute))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftBarItemTitle, style: .plain, target: self, action: #selector(cancelAction))
        title = vcTitle
    }
    
    private func customizeToolBar() {
        view.addSubview(toolBarWithButtons)

        NSLayoutConstraint.activate([
            toolBarWithButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarWithButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBarWithButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupMapView() {
        if let mpView = mapView {
            view.addSubview(mpView)
            NSLayoutConstraint.activate([
                mpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mpView.topAnchor.constraint(equalTo: view.topAnchor),
                mpView.bottomAnchor.constraint(equalTo: toolBarWithButtons.topAnchor),
            ])
        }
    }
    
// MARK: Target actions
    
    @objc func saveNewRoute() {
        print("Save context...")
    }
    
    @objc func cancelAction() {
        if let nvc = navigationController {
            nvc.popViewController(animated: true)
        }
    }
    
    @objc func markerAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print("Set marker")
        }
    }
    
    @objc func routeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print("Start draw your personal route")
        }
    }
    
}
