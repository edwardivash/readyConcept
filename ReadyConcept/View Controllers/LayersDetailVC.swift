//
//  LayersDetailVC.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 5.05.21.
//

import UIKit
import Mapbox
import MapboxAnnotationExtension

let cellNibName = "LayersCell"
let cellId = "LayersId"

class LayersDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    var segmentedControl: UISegmentedControl?
    var dataSource: [LayersModel]?
    var styleCompletion:((URL) -> Void)?
    var selectedRows = NSMutableIndexSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 240 / 255, green: 241 / 255, blue: 242 / 255, alpha: 1)
        
        tableView = UITableView()
        tableView?.register(UINib(nibName: cellNibName, bundle: .main), forCellReuseIdentifier: cellId)
        selectedRows.contains(0)
        
        segmentedControl = UISegmentedControl(items: ["Map", "Sattelite"])
        
        dataSource = fillDatasource()
        
        setupSegmentedControl()
        setupTableView()
    }
    
    override func updateViewConstraints() {
        view.frame.size.height = UIScreen.main.bounds.height / 2
        view.frame.origin.y = UIScreen.main.bounds.height - view.frame.size.height
        super.updateViewConstraints()
    }
    
    // MARK: Private methods
    
    private func setupSegmentedControl() {
        if let segmContr = segmentedControl {
            segmContr.translatesAutoresizingMaskIntoConstraints = false
            segmContr.selectedSegmentIndex = 0
            segmContr.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            segmContr.selectedSegmentTintColor = UIColor(red: 127 / 255, green: 153 / 255, blue: 173 / 255, alpha: 1)
            segmContr.addTarget(self, action: #selector(changeStyle(_:)), for: .valueChanged)
            
            view.addSubview(segmContr)
            NSLayoutConstraint.activate([
                segmContr.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                segmContr.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                segmContr.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
            ])
        }
    }
    
    private func setupTableView() {
        if let tablView = tableView,
           let segmControl = segmentedControl {
            tablView.translatesAutoresizingMaskIntoConstraints = false
            tablView.layer.cornerRadius = 10
            tablView.isScrollEnabled = false
            
            tablView.delegate = self
            tablView.dataSource = self
            
            view.addSubview(tablView)
            NSLayoutConstraint.activate([
                tablView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                tablView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                tablView.topAnchor.constraint(equalTo: segmControl.bottomAnchor, constant: 10),
                tablView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }
    
    private func fillDatasource() -> [LayersModel] {
        var resultArray = [LayersModel]()
        let layerNames = ["Rivers", "Routes", "Shops", "Photos"]
        for layer in layerNames {
            resultArray.append(LayersModel(name: layer, selected: false))
        }
        resultArray[0].isSelected = true
        return resultArray
    }
    
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LayersCell
        if let dataSource = dataSource {
            cell.configureCell(layer: dataSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            if dataSource[indexPath.row].isSelected == false {
                dataSource[indexPath.row].isSelected = true
                selectedRows.add(indexPath.row)
            } else {
                dataSource[indexPath.row].isSelected = false
                selectedRows.remove(indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    let viliaCoordinates = [
        (54.794503, 26.190763),
        (54.792952, 26.189289),
        (54.792002, 26.188174),
        (54.790679, 26.186776),
        (54.789215, 26.186256),
        (54.788140, 26.186095),
        (54.786803, 26.186509),
        (54.78532,  26.186258),
        (54.784102, 26.185120),
        (54.783063, 26.185135),
        (54.781938, 26.186435),
        (54.781206, 26.188355),
        (54.780677, 26.190837),
        (54.779834, 26.194826)
    ].map({ CLLocationCoordinate2D(latitude: $0.1, longitude: $0.0)})
    
    // MARK: Target Actions
    
    @objc func changeStyle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            styleCompletion?(MGLStyle.streetsStyleURL)
        case 1:
            styleCompletion?(MGLStyle.satelliteStyleURL)
        default:
            styleCompletion?(MGLStyle.streetsStyleURL)
        }
    }
}
