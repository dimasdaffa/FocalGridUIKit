//
//  CameraViewModel.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import AVFoundation
import UIKit

enum CameraAspectRatio: String, CaseIterable {
    case fourByThree = "4:3"
    case oneByOne = "1:1"

    var heightRatio: CGFloat {
        switch self {
        case .fourByThree: return 4.0 / 3.0
        case .oneByOne: return 1.0
        }
    }
}

struct LensOption {
    let title: String
    let displayZoom: CGFloat
    let hardwareZoom: CGFloat
}

final class CameraViewModel {

    var selectedType: CompositionType
    var flashMode: AVCaptureDevice.FlashMode = .off
    var currentAspectRatio: CameraAspectRatio = .fourByThree
    var currentHardwareZoom: CGFloat = 1.0
    var gridRotationDegrees: CGFloat = 0.0

    init(initialType: CompositionType) {
        self.selectedType = initialType
    }

    // MARK: - Flash Control

    func toggleFlash() -> AVCaptureDevice.FlashMode {
        switch flashMode {
        case .off: flashMode = .on
        case .on: flashMode = .auto
        case .auto: flashMode = .off
        @unknown default: flashMode = .off
        }
        return flashMode
    }

    func flashIconName() -> String {
        switch flashMode {
        case .on: return "bolt.fill"
        case .auto: return "bolt.badge.a.fill"
        case .off: return "bolt.slash.fill"
        @unknown default: return "bolt.slash.fill"
        }
    }

    func flashTintColor() -> UIColor {
        switch flashMode {
        case .on, .auto: return .systemYellow
        case .off: return .white
        @unknown default: return .white
        }
    }

    // MARK: - Aspect Ratio Control

    func cycleAspectRatio() -> CameraAspectRatio {
        currentAspectRatio = (currentAspectRatio == .fourByThree) ? .oneByOne : .fourByThree
        return currentAspectRatio
    }

    // MARK: - Grid Rotation Control

    func rotateGrid() -> CGFloat {
        gridRotationDegrees = (gridRotationDegrees + 90).truncatingRemainder(dividingBy: 360)
        return gridRotationDegrees
    }
}
