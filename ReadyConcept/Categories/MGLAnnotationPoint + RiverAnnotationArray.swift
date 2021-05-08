//
//  MGLAnnotationPoint + RiverAnnotationArray.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 8.05.21.
//

import Foundation
import Mapbox

extension MGLPointAnnotation {
        
    func returnRiverAnnotationsArray() -> [MGLPointAnnotation] {
        let viliaAnnotation = MGLPointAnnotation()
        viliaAnnotation.coordinate = CLLocationCoordinate2D(latitude: 54.796620, longitude: 26.193940)
        viliaAnnotation.title = "Vilia"
        viliaAnnotation.subtitle = "Viliya is a river in Belarus and Lithuania."
        
        let berezinaAnnotation = MGLPointAnnotation()
        berezinaAnnotation.coordinate = CLLocationCoordinate2D(latitude: 53.695547, longitude: 28.967426)
        berezinaAnnotation.title = "Berezina River"
        berezinaAnnotation.subtitle = "The longest river in Belarus."
        
        let ptichAnnotation = MGLPointAnnotation()
        ptichAnnotation.coordinate = CLLocationCoordinate2D(latitude: 53.388826, longitude: 27.853164)
        ptichAnnotation.title = "Ptich River"
        ptichAnnotation.subtitle = "Interesting river."
        
        let westernDvinaAnnotation = MGLPointAnnotation()
        westernDvinaAnnotation.coordinate = CLLocationCoordinate2D(latitude: 55.203379, longitude: 29.259610)
        westernDvinaAnnotation.title = "Western Dvina"
        westernDvinaAnnotation.subtitle = "Wild river..."
        
        let svislochAnnotation = MGLPointAnnotation()
        svislochAnnotation.coordinate = CLLocationCoordinate2D(latitude: 53.652168, longitude: 28.057518)
        svislochAnnotation.title = "Svisloch River"
        svislochAnnotation.subtitle = "The main waterway of Minsk"
        
        return [viliaAnnotation, berezinaAnnotation, ptichAnnotation, westernDvinaAnnotation, svislochAnnotation]
    }
    
    func returnShopAnnotationsArray() -> [MGLPointAnnotation] {
        
        let shopTitle = "Shop"
        
        let kayakRentAnnotation1 = MGLPointAnnotation()
        kayakRentAnnotation1.coordinate = CLLocationCoordinate2D(latitude: 54.023244, longitude: 26.508186)
        kayakRentAnnotation1.title = shopTitle
        kayakRentAnnotation1.subtitle = "Kayak and bicycle rental in Nalibokskaya Pushcha."
        
        let kayakRentAnnotation2 = MGLPointAnnotation()
        kayakRentAnnotation2.coordinate = CLLocationCoordinate2D(latitude: 53.188589, longitude: 25.590527)
        kayakRentAnnotation2.title = shopTitle
        kayakRentAnnotation2.subtitle = "Kayak rental baydarka.by"
        
        let kayakRentAnnotation3 = MGLPointAnnotation()
        kayakRentAnnotation3.coordinate = CLLocationCoordinate2D(latitude: 53.967551, longitude: 26.834112)
        kayakRentAnnotation3.title = shopTitle
        kayakRentAnnotation3.subtitle = "Country estate 'Ram Khata'."

        let kayakRentAnnotation4 = MGLPointAnnotation()
        kayakRentAnnotation4.coordinate = CLLocationCoordinate2D(latitude: 53.913289, longitude: 27.309726)
        kayakRentAnnotation4.title = shopTitle
        kayakRentAnnotation4.subtitle = "Turpohod.by"
        
        let kayakRentAnnotation5 = MGLPointAnnotation()
        kayakRentAnnotation5.coordinate = CLLocationCoordinate2D(latitude: 54.004104, longitude: 27.681163)
        kayakRentAnnotation5.title = shopTitle
        kayakRentAnnotation5.subtitle = "Xatanga.by"
        
        let kayakRentAnnotation6 = MGLPointAnnotation()
        kayakRentAnnotation6.coordinate = CLLocationCoordinate2D(latitude: 54.035703, longitude: 27.681774)
        kayakRentAnnotation6.title = shopTitle
        kayakRentAnnotation6.subtitle = "Baidarochka.by"
        
        return [kayakRentAnnotation1, kayakRentAnnotation2, kayakRentAnnotation3, kayakRentAnnotation4, kayakRentAnnotation5, kayakRentAnnotation6]
    }
}
