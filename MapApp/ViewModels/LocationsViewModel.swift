//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Dawid Nowacki on 29/01/2024.
//

import Foundation
import MapKit
import SwiftUI

//class do pobrania danych z modelu Locations
class LocationsViewModel: ObservableObject {
    
    //definicja klasy location - wszystkie załadowane lokalizacje
    @Published var locations: [Location]
    
    //obecna lokacja w mapie
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    //zadeklarowanie mapSpan i mapRegion
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //pokazanie listy lokalizacji
    @Published var showLocationsList: Bool = false
    
    //pokazanie detali lokalizacji przy pomocy sheet
    @Published var sheetLocation: Location? = nil
    
    init() {
        //pobranie danych z LocationsDataService i połączenie z class LocationViewModels
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }
    
    //funkcja dla update widoku lokalizacji po pobraniu koordynatów z Location
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan)
        }
    }
    //przełącznik do rozwijania listy po naciśnięciu strzałki
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    //funkcja która pozwala po naciśnięciu na lokalizację z rozwijanej listy zaktualizowanie widoku mapy
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        //Pobranie indeksu dla lokalizacji
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
            print("Coould not find current index in locations array!")
            return
        }
        //Sprawdzenie czy kolejny indeks jest możliwy do pobrania
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            //Następny indeks nie jest możliwy
            //Restart od miejsca 0
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        let nextLocation = locations[nextIndex]
            showNextLocation(location: nextLocation)
    }
}
