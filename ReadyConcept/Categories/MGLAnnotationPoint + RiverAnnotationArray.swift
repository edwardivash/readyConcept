//
//  MGLAnnotationPoint + RiverAnnotationArray.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 8.05.21.
//

import Foundation
import Mapbox

extension MGLPointAnnotation {
        
    func returnRiverAnnotationsArray() -> [RiverAnnotationModel] {
                
        let viliaAnnotation = RiverAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 54.812750, longitude: 25.990287), title: "Vilia", subtitle: "Viliya is a river in Belarus and Lithuania.")
        
        let berezinaAnnotation = RiverAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.695547, longitude: 28.967426), title: "Berezina River", subtitle: "The longest river in Belarus.")
        
        let ptichAnnotation = RiverAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.388826, longitude: 27.853164), title: "Ptich River", subtitle: "Interesting river.")
        
        let westernDvinaAnnotation = RiverAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 55.203379, longitude: 29.259610), title: "Western Dvina", subtitle: "Wild river...")
        
        let svislochAnnotation = RiverAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.652168, longitude: 28.057518), title: "Svisloch River", subtitle: "The main waterway of Minsk")
        
        return [viliaAnnotation, berezinaAnnotation, ptichAnnotation, westernDvinaAnnotation, svislochAnnotation]
    }
    
    func returnShopAnnotationsArray() -> [ShopAnnotationModel] {
        
        let shopTitle = "Hiking Store"
        
        let kayakRentAnnotation1 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 54.023244, longitude: 26.508186), title: shopTitle, subtitle: "Kayak and bicycle rental in Nalibokskaya Pushcha.")
        
        let kayakRentAnnotation2 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.188589, longitude: 25.590527), title: shopTitle, subtitle: "Kayak rental baydarka.by")
        
        let kayakRentAnnotation3 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.967551, longitude: 26.834112), title: shopTitle, subtitle: "Country estate 'Ram Khata'.")

        let kayakRentAnnotation4 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.913289, longitude: 27.309726), title: shopTitle, subtitle: "Turpohod.by")
        
        let kayakRentAnnotation5 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 54.004104, longitude: 27.681163), title: shopTitle, subtitle: "Xatanga.by")
        
        let kayakRentAnnotation6 = ShopAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 54.035703, longitude: 27.681774), title: shopTitle, subtitle: "Baidarochka.by")
        
        return [kayakRentAnnotation1, kayakRentAnnotation2, kayakRentAnnotation3, kayakRentAnnotation4, kayakRentAnnotation5, kayakRentAnnotation6]
    }
    
    func returnRoutesAnnotationsArray() -> [RouteAnnotationModel] {
        
        let startViliaRouteAnnotation = RouteAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 54.795355, longitude: 26.191101), title: "Starting Vilia route.", subtitle: nil)
        
        let startBerezinaRouteAnnotation = RouteAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 53.664466, longitude: 28.944372), title: "Starting Berezina route.", subtitle: nil)

        return [startViliaRouteAnnotation, startBerezinaRouteAnnotation]
    }
}
