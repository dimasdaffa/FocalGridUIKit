//
//  CameraViewController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import UIKit
import AVFoundation
import SnapKit

final class CameraViewController: UIViewController {

    private let viewModel: CameraViewModel

    // AVFoundation
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var activeDevice: AVCaptureDevice?

    // Viewport Container (Masking Aspect Ratio)
    private let cameraViewport = UIView()
    private let gridOverlay = GridOverlayView()

    // UI Controls (Top & Bottom)
    private let topBarView = UIView()
    private let bottomControlsView = UIView()
    private let rotateButton = UIButton(type: .system)
    private let ratioButton = UIButton(type: .system)
    private let flashButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let shutterButton = UIButton(type: .custom)

    // Zoom Lens Switcher
    private let lensStackView = UIStackView()
    private var lensOptions: [LensOption] = []
    private var lensButtons: [UIButton] = []

    // Pinch Gesture
    private var initialPinchZoom: CGFloat = 1.0

    // MARK: - Photo Preview Overlay (Discard / Save)
    private let previewContainerView = UIView()
    private let previewImageView = UIImageView()
    private let previewBottomBar = UIView()
    private let discardButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private var currentCapturedImage: UIImage?

    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupPreviewOverlayUI()
        setupGestures()
        checkCameraPermissions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = cameraViewport.bounds
    }

    // MARK: - UI Setup

    private func setupUI() {
        // 1. Camera Viewport
        cameraViewport.clipsToBounds = true
        cameraViewport.backgroundColor = .black
        view.addSubview(cameraViewport)

        // 2. Grid Overlay
        gridOverlay.compositionType = viewModel.selectedType
        cameraViewport.addSubview(gridOverlay)
        gridOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 3. Top Bar
        view.addSubview(topBarView)
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(54)
        }
        setupTopBarControls()

        // 4. Bottom Controls
        view.addSubview(bottomControlsView)
        bottomControlsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.height.equalTo(130)
        }
        setupBottomControls()

        updateViewportConstraint()
    }

    private func setupTopBarControls() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        closeButton.layer.cornerRadius = 20
        closeButton.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        rotateButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        rotateButton.tintColor = .white
        rotateButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        rotateButton.layer.cornerRadius = 20
        rotateButton.clipsToBounds = true
        rotateButton.addTarget(self, action: #selector(rotateTapped), for: .touchUpInside)

        ratioButton.setTitle(viewModel.currentAspectRatio.rawValue, for: .normal)
        ratioButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        ratioButton.tintColor = .white
        ratioButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        ratioButton.layer.cornerRadius = 15
        ratioButton.clipsToBounds = true
        ratioButton.addTarget(self, action: #selector(ratioTapped), for: .touchUpInside)

        flashButton.setImage(UIImage(systemName: viewModel.flashIconName()), for: .normal)
        flashButton.tintColor = viewModel.flashTintColor()
        flashButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        flashButton.layer.cornerRadius = 20
        flashButton.clipsToBounds = true
        flashButton.addTarget(self, action: #selector(flashTapped), for: .touchUpInside)

        topBarView.addSubview(closeButton)
        topBarView.addSubview(rotateButton)
        topBarView.addSubview(ratioButton)
        topBarView.addSubview(flashButton)

        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        flashButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        ratioButton.snp.makeConstraints { make in
            make.trailing.equalTo(flashButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(48)
            make.height.equalTo(30)
        }

        rotateButton.snp.makeConstraints { make in
            make.trailing.equalTo(ratioButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }

    private func setupBottomControls() {
        // Lens Switcher Stack
        lensStackView.axis = .horizontal
        lensStackView.spacing = 10
        lensStackView.alignment = .center
        lensStackView.distribution = .equalCentering
        lensStackView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        lensStackView.layer.cornerRadius = 18
        lensStackView.clipsToBounds = true
        lensStackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        lensStackView.isLayoutMarginsRelativeArrangement = true

        bottomControlsView.addSubview(lensStackView)
        lensStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }

        // Shutter Button
        shutterButton.layer.cornerRadius = 38
        shutterButton.layer.borderWidth = 4
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.backgroundColor = .clear

        let innerCircle = UIView()
        innerCircle.backgroundColor = .white
        innerCircle.layer.cornerRadius = 30
        innerCircle.isUserInteractionEnabled = false
        shutterButton.addSubview(innerCircle)
        innerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }

        shutterButton.addTarget(self, action: #selector(shutterTapped), for: .touchUpInside)
        bottomControlsView.addSubview(shutterButton)
        shutterButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(76)
        }
    }

    // MARK: - Preview Overlay Setup

    private func setupPreviewOverlayUI() {
        previewContainerView.backgroundColor = .black
        previewContainerView.isHidden = true
        previewContainerView.alpha = 0
        view.addSubview(previewContainerView)
        previewContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        previewImageView.contentMode = .scaleAspectFit
        previewImageView.clipsToBounds = true
        previewContainerView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
        }

        previewContainerView.addSubview(previewBottomBar)
        previewBottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(80)
        }

        // Discard / Retake Button
        discardButton.setTitle("Retake", for: .normal)
        discardButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        discardButton.tintColor = .white
        discardButton.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        discardButton.layer.cornerRadius = 24
        discardButton.addTarget(self, action: #selector(discardTapped), for: .touchUpInside)
        previewBottomBar.addSubview(discardButton)
        discardButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(48)
        }

        // Save Button (Placeholder)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .themePrimary
        saveButton.layer.cornerRadius = 24
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        previewBottomBar.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
    }

    private func updateViewportConstraint() {
        cameraViewport.snp.remakeConstraints { make in
            switch viewModel.currentAspectRatio {
            case .fourByThree:
                make.top.equalTo(topBarView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(cameraViewport.snp.width).multipliedBy(4.0 / 3.0)
            case .oneByOne:
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(cameraViewport.snp.width)
            }
        }

        view.bringSubviewToFront(cameraViewport)
        view.bringSubviewToFront(topBarView)
        view.bringSubviewToFront(bottomControlsView)
        view.bringSubviewToFront(previewContainerView)

        view.layoutIfNeeded()
        previewLayer?.frame = cameraViewport.bounds
    }

    // MARK: - Gestures & Zoom

    private func setupGestures() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        cameraViewport.addGestureRecognizer(pinch)
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let device = activeDevice else { return }
        if gesture.state == .began {
            initialPinchZoom = device.videoZoomFactor
        }
        let targetZoom = initialPinchZoom * gesture.scale
        applyZoom(hardwareFactor: targetZoom)
    }

    // MARK: - AVFoundation Pipeline

    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { self?.setupCaptureSession() }
                }
            }
        default:
            print("Camera access denied.")
        }
    }

    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo

        let deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInTripleCamera,
            .builtInDualWideCamera,
            .builtInDualCamera,
            .builtInWideAngleCamera
        ]
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .back
        )

        guard let camera = discovery.devices.first,
              let input = try? AVCaptureDeviceInput(device: camera),
              captureSession.canAddInput(input) else {
            captureSession.commitConfiguration()
            return
        }

        self.activeDevice = camera
        captureSession.addInput(input)

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        captureSession.commitConfiguration()

        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        cameraViewport.layer.insertSublayer(preview, at: 0)
        self.previewLayer = preview

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }

        configureLensOptions(for: camera)
    }

    // MARK: - Lens Configuration

    private func configureLensOptions(for device: AVCaptureDevice) {
        let hasUltraWide = device.constituentDevices.contains { $0.deviceType == .builtInUltraWideCamera }
        let switchOvers = device.virtualDeviceSwitchOverVideoZoomFactors.map { CGFloat($0.doubleValue) }

        lensOptions.removeAll()

        if hasUltraWide {
            let wideHW = switchOvers.first ?? 2.0
            lensOptions.append(LensOption(title: ".5", displayZoom: 0.5, hardwareZoom: 1.0))
            lensOptions.append(LensOption(title: "1x", displayZoom: 1.0, hardwareZoom: wideHW))

            if switchOvers.count > 1 {
                let teleHW = switchOvers[1]
                let teleDisplay = (teleHW / wideHW).rounded()
                lensOptions.append(LensOption(title: "\(Int(teleDisplay))x", displayZoom: teleDisplay, hardwareZoom: teleHW))
            } else {
                let teleHW = wideHW * 2.0
                if teleHW <= device.maxAvailableVideoZoomFactor {
                    lensOptions.append(LensOption(title: "2x", displayZoom: 2.0, hardwareZoom: teleHW))
                }
            }

            applyZoom(hardwareFactor: wideHW)
        } else {
            lensOptions.append(LensOption(title: "1x", displayZoom: 1.0, hardwareZoom: 1.0))
            if let teleHW = switchOvers.first {
                let teleDisplay = teleHW.rounded()
                lensOptions.append(LensOption(title: "\(Int(teleDisplay))x", displayZoom: teleDisplay, hardwareZoom: teleHW))
            } else if device.maxAvailableVideoZoomFactor >= 2.0 {
                lensOptions.append(LensOption(title: "2x", displayZoom: 2.0, hardwareZoom: 2.0))
            }
            applyZoom(hardwareFactor: 1.0)
        }

        rebuildLensButtons()
    }

    private func rebuildLensButtons() {
        lensButtons.forEach { $0.removeFromSuperview() }
        lensButtons.removeAll()

        for (index, option) in lensOptions.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(option.title, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
            btn.tag = index
            btn.layer.cornerRadius = 14
            btn.addTarget(self, action: #selector(lensButtonTapped(_:)), for: .touchUpInside)
            btn.snp.makeConstraints { make in make.width.height.equalTo(28) }
            lensButtons.append(btn)
            lensStackView.addArrangedSubview(btn)
        }

        updateLensButtonsHighlight()
    }

    private func applyZoom(hardwareFactor: CGFloat) {
        guard let device = activeDevice else { return }
        do {
            try device.lockForConfiguration()
            let minZoom = device.minAvailableVideoZoomFactor
            let maxZoom = min(device.maxAvailableVideoZoomFactor, 15.0)
            let clamped = max(minZoom, min(hardwareFactor, maxZoom))
            device.videoZoomFactor = clamped
            device.unlockForConfiguration()

            viewModel.currentHardwareZoom = clamped
            updateLensButtonsHighlight()
        } catch {
            print("Gagal konfigurasi zoom: \(error)")
        }
    }

    private func updateLensButtonsHighlight() {
        let current = viewModel.currentHardwareZoom
        for (index, btn) in lensButtons.enumerated() {
            guard index < lensOptions.count else { continue }
            let option = lensOptions[index]
            let isSelected = abs(current - option.hardwareZoom) < 0.15
            btn.tintColor = isSelected ? .systemYellow : .white
            btn.backgroundColor = isSelected ? UIColor.white.withAlphaComponent(0.2) : .clear
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        captureSession.stopRunning()
        dismiss(animated: true)
    }

    @objc private func rotateTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        gridOverlay.rotationDegrees = viewModel.rotateGrid()
    }

    @objc private func flashTapped() {
        _ = viewModel.toggleFlash()
        flashButton.setImage(UIImage(systemName: viewModel.flashIconName()), for: .normal)
        flashButton.tintColor = viewModel.flashTintColor()
    }

    @objc private func ratioTapped() {
        let nextRatio = viewModel.cycleAspectRatio()
        ratioButton.setTitle(nextRatio.rawValue, for: .normal)

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.updateViewportConstraint()
        }
    }

    @objc private func lensButtonTapped(_ sender: UIButton) {
        guard sender.tag < lensOptions.count else { return }
        let selectedOption = lensOptions[sender.tag]
        applyZoom(hardwareFactor: selectedOption.hardwareZoom)
    }

    @objc private func shutterTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let settings = AVCapturePhotoSettings()
        if let device = activeDevice, device.hasFlash, device.isFlashAvailable,
           photoOutput.supportedFlashModes.contains(viewModel.flashMode) {
            settings.flashMode = viewModel.flashMode
        } else {
            settings.flashMode = .off
        }

        photoOutput.capturePhoto(with: settings, delegate: self)

        // Shutter blink animation
        UIView.animate(withDuration: 0.08, animations: {
            self.cameraViewport.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.08) {
                self.cameraViewport.alpha = 1.0
            }
        }
    }

    // MARK: - Preview Overlay Actions

    private func showPreview(image: UIImage) {
        currentCapturedImage = image
        previewImageView.image = image
        previewContainerView.isHidden = false

        UIView.animate(withDuration: 0.25) {
            self.previewContainerView.alpha = 1.0
        }
    }

    @objc private func discardTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.previewContainerView.alpha = 0.0
        }) { _ in
            self.previewContainerView.isHidden = true
            self.previewImageView.image = nil
            self.currentCapturedImage = nil
        }
    }

    @objc private func saveTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Placeholder: Disiapkan untuk penyimpanan SwiftData & Gallery app
        print("Foto berhasil disimpan (Placeholder).")

        UIView.animate(withDuration: 0.2, animations: {
            self.previewContainerView.alpha = 0.0
        }) { _ in
            self.previewContainerView.isHidden = true
            self.previewImageView.image = nil
            self.currentCapturedImage = nil
            self.closeTapped() // Tutup kamera setelah menyimpan
        }
    }
}

// MARK: - Photo Capture Delegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let originalImage = UIImage(data: data) else {
            print("Gagal mengambil foto: \(String(describing: error))")
            return
        }

        let croppedImage = cropToRatio(image: originalImage, ratio: viewModel.currentAspectRatio)

        DispatchQueue.main.async { [weak self] in
            self?.showPreview(image: croppedImage)
        }
    }

    private func cropToRatio(image: UIImage, ratio: CameraAspectRatio) -> UIImage {
        guard ratio != .fourByThree, let cgImage = image.cgImage else { return image }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        var cropWidth = width
        var cropHeight = width * ratio.heightRatio

        if cropHeight > height {
            cropHeight = height
            cropWidth = height / ratio.heightRatio
        }

        let originX = (width - cropWidth) / 2.0
        let originY = (height - cropHeight) / 2.0
        let cropRect = CGRect(x: originX, y: originY, width: cropWidth, height: cropHeight)

        guard let croppedCG = cgImage.cropping(to: cropRect) else { return image }
        return UIImage(cgImage: croppedCG, scale: image.scale, orientation: image.imageOrientation)
    }
}
