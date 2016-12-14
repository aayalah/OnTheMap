//
//  GCD.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/12/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
