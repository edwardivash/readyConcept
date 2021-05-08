//
//  MapWithLayersVC.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 5.05.21.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

let maximumZoomLevel: Double = 24
let stepperStarterValue: Double = 14
let roundButtonValue: CGFloat = 5
let alphaComponent: CGFloat = 0.2

class MapWithLayersVC: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var selectedIndexes = Set<Int>()
    
    lazy var arrayOfRiverAnnotations:[MGLPointAnnotation] = {
       let riverAnnotations = MGLPointAnnotation().returnRiverAnnotationsArray()
       return riverAnnotations
    }()
    
    lazy var routesPolylineAnnotationsArray:[MGLPolyline] = {
        let polylineRoutesAnnotations = MGLPolyline().returnRoutesPolylineAnnotationsArray()
        return polylineRoutesAnnotations
    }()
    
    lazy var shopsAnnotationsArray:[MGLPointAnnotation] = {
       let shopsAnnotations = MGLPointAnnotation().returnShopAnnotationsArray()
       return shopsAnnotations
    }()
    
    lazy var layersDetailVC: LayersDetailVC? = {
        let layersDetailVC = LayersDetailVC()
        return layersDetailVC
    }()
    
    lazy var buttonsStackView: UIStackView? = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
        return stackView
    }()
    
    lazy var mapView: NavigationMapView? = {
        let mapView = NavigationMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 54.794503, longitude: 26.190763), zoomLevel: 8, animated: false)
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        mapView.compassView.compassVisibility = .hidden
        mapView.delegate = self
        return mapView
    }()
    
    lazy var layerButton: UIButton? = {
        let layerButton = UIButton()
        layerButton.addTarget(self, action: #selector(presentVCWithLayers), for: .touchUpInside)
        layerButton.translatesAutoresizingMaskIntoConstraints = false
        layerButton.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        layerButton.setImage(UIImage(named: "sheets"), for: .normal)
        layerButton.layer.cornerRadius = roundButtonValue
        return layerButton
    }()
    
    lazy var routeEditionButton: UIButton? = {
        let routeButton = UIButton()
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        routeButton.setImage(UIImage(named: "pencil"), for: .normal)
        routeButton.layer.cornerRadius = roundButtonValue
        return routeButton
    }()
    
    lazy var stepper: UIStepper? = {
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
    
    lazy var locationButton: UIButton? = {
        let locationButton = UIButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(startNavigation), for: .touchUpInside)
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(alphaComponent)
        locationButton.setImage(UIImage(named: "navigation"), for: .normal)
        locationButton.layer.cornerRadius = roundButtonValue
        return locationButton
    }()
    
    lazy var searchBar: UISearchBar? = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search what you want..."
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
// MARK: VC's LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupSearchBar()
        setupButtonStackView()
        
        selectedIndexes.insert(0)
        
        layerAnnotationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
// MARK: Customize methods
    
    private func setupMapView() {
        if let mpView = mapView {
            view.addSubview(mpView)
            NSLayoutConstraint.activate([
                mpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mpView.topAnchor.constraint(equalTo: view.topAnchor),
                mpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }
    
    private func setupButtonStackView() {
        if let btnStackView = buttonsStackView,
           let mapView = mapView,
           let layerBtn = layerButton,
           let routeEditingBtn = routeEditionButton,
           let stepper = stepper,
           let locationBtn = locationButton,
           let serchBar = searchBar {
            
            btnStackView.addArrangedSubview(layerBtn)
            btnStackView.addArrangedSubview(routeEditingBtn)
            btnStackView.addArrangedSubview(stepper)
            btnStackView.addArrangedSubview(locationBtn)
            view.insertSubview(btnStackView, aboveSubview: mapView)
            
            NSLayoutConstraint.activate([
                btnStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                btnStackView.heightAnchor.constraint(equalTo: btnStackView.heightAnchor),
                btnStackView.topAnchor.constraint(equalTo: serchBar.bottomAnchor, constant: btnStackView.frame.height / 2)
            ])
        }
    }
    
    private func setupSearchBar() {
        if let srchBar = searchBar {
            view.insertSubview(srchBar, aboveSubview: mapView!)
            
            NSLayoutConstraint.activate([
                srchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                srchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                srchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
        }
    }
    
// MARK: Target methods
    
    @objc func zoomInOut(_ sender: UIStepper) {
        if let mapView = mapView {
            mapView.zoomLevel = Double(sender.value)
        }
    }
    
    @objc func presentVCWithLayers() {
        if let layersDetailVCC = layersDetailVC,
           let mapView = mapView {
            present(layersDetailVCC, animated: true, completion: nil)
            layersDetailVCC.styleCompletion = { (style) in
                mapView.styleURL = style
            }
        }
    }
    
    @objc func startNavigation() {
        let navigationVC = NavigationVC()
        present(navigationVC, animated: true, completion: nil)
    }
    
// MARK: MapView Delegate
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if selectedIndexes.contains(0) {
            addRiverAnnotations()
        }
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: 1000, pitch: 0, heading: 0)
        mapView.fly(to: camera, completionHandler: nil)
    }
    
// MARK: Drawing delegate methods
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.6
    }

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .red
    }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 5.0
    }
        

// MARK: Add annotations methods
    
    func addRiverAnnotations() {
        if let mapView = mapView {
            mapView.addAnnotations(arrayOfRiverAnnotations)
        }
    }
    
    func addRiverRoutesAnnotations() {
        if let mapView = mapView {
            mapView.addAnnotations(routesPolylineAnnotationsArray)
        }
    }
    
    func addShopAnnotations() {
        if let mapView = mapView {
            mapView.addAnnotations(shopsAnnotationsArray)
        }
    }
    
// MARK: Layer Annotation Manager
    
    func layerAnnotationManager () {
        if let detailVC = layersDetailVC,
           let mapView = mapView {
            detailVC.selectedLayer = { [unowned self] cellIndex in
                switch cellIndex {
                case 0:
                    if selectedIndexes.contains(cellIndex) {
                        mapView.removeAnnotations(arrayOfRiverAnnotations)
                        selectedIndexes.remove(cellIndex)
                    } else {
                        self.addRiverAnnotations()
                        selectedIndexes.insert(cellIndex)
                    }
                case 1:
                    if selectedIndexes.contains(cellIndex) {
                        mapView.removeAnnotations(routesPolylineAnnotationsArray)
                        selectedIndexes.remove(cellIndex)
                    } else {
                        addRiverRoutesAnnotations()
                        selectedIndexes.insert(cellIndex)
                    }
                case 2:
                    if selectedIndexes.contains(cellIndex) {
                        mapView.removeAnnotations(shopsAnnotationsArray)
                        selectedIndexes.remove(cellIndex)
                    } else {
                        addShopAnnotations()
                        selectedIndexes.insert(cellIndex)
                    }
                case 3:
                    print("Photo layer - 3")
                default:
                    break
                }
            }
        }
    }
}
