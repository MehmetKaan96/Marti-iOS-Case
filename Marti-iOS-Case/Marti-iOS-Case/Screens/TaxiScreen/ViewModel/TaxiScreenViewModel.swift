//
//  TaxiScreenViewModel.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 13.05.2025.
//

import Foundation
import CoreLocation

final class TaxiScreenViewModel: BaseLocationViewModel {
    init() {
        super.init(screenType: .taxi)
    }
}
