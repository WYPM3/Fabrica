//
//  Settings.swift
//  Fabrica
//
//  Created by Mason Wyper on 3/9/2025.
//

import Foundation
class Settings: Decodable, Identifiable
{
   
    var quality: String
    var strength: String
    var speed: Int
    var support: String
    var wall: String
    var travel: String
    var layerHeight: Int
    var infillDensity: Int
    var retractionDistance: Int
    var retractionSpeed: Int
    var retractionCount: Int
    var coasting: String
    var wiping: String
    
    init(quality: String, strength: String, speed: Int, support: String, wall: String, travel: String, layerHeight: Int, infillDensity: Int, retractionDistance: Int, retractionSpeed: Int, retractionCount: Int, coasting: String, wiping: String)
    {
        self.quality = quality
        self.strength = strength
        self.speed = speed
        self.support = support
        self.wall = wall
        self.travel = travel
        self.layerHeight = layerHeight
        self.infillDensity = infillDensity
        self.retractionDistance = retractionDistance
        self.retractionSpeed = retractionSpeed
        self.retractionCount = retractionCount
        self.coasting = coasting
        self.wiping = wiping
    }
}











