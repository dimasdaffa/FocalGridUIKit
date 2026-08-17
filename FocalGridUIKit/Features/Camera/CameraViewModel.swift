//
//  CameraViewModel.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import AVFoundation
import UIKit

final class CameraViewModel {

    var selectedType: CompositionType
    var flashMode: AVCaptureDevice.FlashMode = .off

    init(initialType: CompositionType) {
        self.selectedType = initialType
    }

    func toggleFlash() -> AVCaptureDevice.FlashMode {
        switch flashMode {
        case .off:
            flashMode = .on
        case .on:
            flashMode = .auto
        case .auto:
            flashMode = .off
        @unknown default:
            flashMode = .off
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
}
