//
//  RoutePlannerVC.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 8.05.21.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxCoreNavigation
import MapboxDirections


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

class RoutePlannerVC: UIViewController, MGLMapViewDelegate {
    
// MARK: Properties
        
    private lazy var currentAnnotationsOnMap:[MGLAnnotation] = {
        let annotations = [MGLAnnotation]()
        return annotations
    }()
    
    private lazy var customPointsCoordinates:[CLLocationCoordinate2D] = {
        let coordinates = [CLLocationCoordinate2D]()
        return coordinates
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var layerButton: UIButton = {
        let layerButton = UIButton()
//        layerButton.addTarget(self, action: #selector(presentVCWithLayers), for: .touchUpInside)
        layerButton.translatesAutoresizingMaskIntoConstraints = false
        layerButton.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        layerButton.setImage(UIImage(named: layerButtonImg), for: .normal)
        layerButton.layer.cornerRadius = roundButtonValue
        return layerButton
    }()
    
    private lazy var navigationButton: UIButton = {
        let locationButton = UIButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(startNavigation), for: .touchUpInside)
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        locationButton.setImage(UIImage(named: navigationButtonImg), for: .normal)
        locationButton.layer.cornerRadius = roundButtonValue
        locationButton.isEnabled = false
        return locationButton
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.autorepeat = true
        stepper.maximumValue = maximumZoomLevel
        stepper.value = stepperStarterValue
        stepper.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        stepper.transform = CGAffineTransform(scaleX: 1, y: 0.8).rotated(by: -(.pi/2))
        stepper.addTarget(self, action: #selector(zoomInOut(_:)), for: UIControl.Event.touchUpInside)
        return stepper
    }()
    
    private lazy var flexibleSpace: UIBarButtonItem = {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        return flexibleSpace
    }()
    
    private lazy var leftArrow: UIBarButtonItem = {
        let left = UIBarButtonItem(image: UIImage(named: undoBarbuttonImg), style: .plain, target: self, action: nil)
        return left
    }()

    private lazy var rightArrow: UIBarButtonItem = {
        let rigt = UIBarButtonItem(image: UIImage(named: redoBarbuttonImg), style: .plain, target: self, action: nil)
        return rigt
    }()
    
    private lazy var markerButton: UIButton = {
       let markerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        markerButton.setImage(UIImage(named: markerBarbuttonImg), for: .normal)
        markerButton.setImage(UIImage(named: selectedMarkerBarbuttonImg), for: .selected)
        markerButton.addTarget(self, action: #selector(markerAction(_:)), for: .touchUpInside)
        return markerButton
    }()

    private lazy var routeButton: UIButton = {
        let routeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        routeButton.setImage(UIImage(named: routeBarbuttonImg), for: .normal)
        routeButton.setImage(UIImage(named: selectedRouteBarbuttonImg), for: .selected)
        routeButton.addTarget(self, action: #selector(routeAction(_:)), for: .touchUpInside)
        return routeButton
    }()

    private lazy var routeColorButton: UIBarButtonItem = {
        let routeClrBtn = UIBarButtonItem(image: UIImage(named: colorBarbuttonImg), style: .plain, target: self, action: nil)
        routeClrBtn.tintColor = UIColor(red: 0, green: 68 / 255, blue: 100 / 255, alpha: 1)
        return routeClrBtn
    }()
    
    private lazy var mapView: NavigationMapView = {
        let mapView = NavigationMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 54.794503, longitude: 26.190763), zoomLevel: 8, animated: false)
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        mapView.compassView.compassVisibility = .hidden
        return mapView
    }()
    
    private lazy var toolBarWithButtons: UIToolbar = {
        let toolBarr = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBarr.translatesAutoresizingMaskIntoConstraints = false
        toolBarr.tintColor = .white
        toolBarr.barTintColor = .darkGray
        toolBarr.isTranslucent = false
        toolBarr.setItems([leftArrow,flexibleSpace,rightArrow,flexibleSpace,UIBarButtonItem(customView: markerButton),flexibleSpace, UIBarButtonItem(customView: routeButton),flexibleSpace,routeColorButton], animated: false)
        return toolBarr
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(RoutePlannerVC.longPressAction(sender:)))
        gesture.minimumPressDuration = 1
        return gesture
    }()
    
// MARK: VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        customizeToolBar()
        setupMapView()
        setupButtonStackView()
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
    
// MARK: Private methods
    
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
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: toolBarWithButtons.topAnchor),
        ])
    }
    
    private func addLongpressGestureRecognizer() {
        for recognizer in mapView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            longPressGesture.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    private func removeLongpressGestureRecognizer() {
        for recognizer in mapView.gestureRecognizers! where recognizer is UILongPressGestureRecognizer {
            mapView.removeGestureRecognizer(recognizer)
        }
    }
    
    private func setupButtonStackView() {
        if let nvcBar = navigationController?.navigationBar {
            buttonsStackView.addArrangedSubview(layerButton)
            buttonsStackView.addArrangedSubview(stepper)
            buttonsStackView.addArrangedSubview(navigationButton)
            view.insertSubview(buttonsStackView, aboveSubview: mapView)
            
            NSLayoutConstraint.activate([
                buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                buttonsStackView.heightAnchor.constraint(equalTo: buttonsStackView.heightAnchor),
                buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: nvcBar.frame.height * 2)
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
        sender.isSelected ? addLongpressGestureRecognizer() : removeLongpressGestureRecognizer()
    }
    
    @objc func routeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print("Start draw your personal route")
        }
    }
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let point = sender.location(in: sender.view!)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            customPointsCoordinates.append(coordinate)
            let annotation = MGLPointAnnotation()
            annotation.coordinate = coordinate
            currentAnnotationsOnMap.append(annotation)
            mapView.addAnnotation(annotation)
            
            if customPointsCoordinates.count == 2 {
                navigationButton.isEnabled = true
            } else {
                navigationButton.isEnabled = false
                if currentAnnotationsOnMap.count > 2 {
                    mapView.removeAnnotations(currentAnnotationsOnMap)
                    customPointsCoordinates.removeAll()
                    currentAnnotationsOnMap.removeAll()
                }
            }
        } else {
            return
        }
    }
    
    @objc func zoomInOut(_ sender: UIStepper) {
        mapView.zoomLevel = Double(sender.value)
    }
    
    @objc func startNavigation(sender: UIButton) {
        let options = NavigationRouteOptions(coordinates: customPointsCoordinates)
        options.profileIdentifier = .automobile
        
        Directions.shared.calculate(options) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else { return }
                
                let navigationVC = NavigationViewController(for: route, routeIndex: 0, routeOptions: options)
                strongSelf.present(navigationVC, animated: true, completion: nil)
            }
        }
    }
}
