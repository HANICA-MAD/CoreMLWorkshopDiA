//#!/usr/bin/swift <--script

import Foundation
import CreateML


let baseUrl = "/Users/agit/Desktop/DiA/repository/dia-nj-2018-agit-tunc/WorkShop/CameraApp/"
// Specify Data
let trainDirectory = URL(fileURLWithPath: baseUrl + "datasets/dog-cat-data/training-data")
let testDirectory = URL(fileURLWithPath:  baseUrl + "datasets/dog-cat-data/testing-data")

// Create Model
let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainDirectory))
// Evaluate Model
let evaluation = model.evaluation(on: .labeledDirectories(at: testDirectory))

// Save Model
try model.write(to: URL(fileURLWithPath: baseUrl + "models/CatDog.mlmodel"))



