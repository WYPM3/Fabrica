//
//  Models.swift
//  Fabrica
//
//  Created by Mason Wyper on 28/8/2025.
//

import Foundation

import CoreGraphics

struct DetectedObject: Identifiable
{
    let id = UUID()
    let name: String
    let confidence: Double
    let boundingBox: CGRect
}



