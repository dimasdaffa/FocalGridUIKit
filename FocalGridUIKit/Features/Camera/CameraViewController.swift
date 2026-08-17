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

    // UI Components
    private let gridOverlay = GridOverlayView()
    private let topBarView = UIView()
    private let bottomBarView = UIView()
    private let shutterButton = UIButton(type: .custom)
    private let flashButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let titlePill = UILabel()

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
        checkCameraPermissions()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    // MARK: - Setup UI

    private func setupUI() {
        // 1. Grid Overlay
        gridOverlay.compositionType = viewModel.selectedType
        view.addSubview(gridOverlay)
        gridOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 2. Top Bar
        view.addSubview(topBarView)
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        topBarView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        titlePill.text = viewModel.selectedType.title
        titlePill.font = .systemFont(ofSize: 14, weight: .semibold)
        titlePill.textColor = .white
        titlePill.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        titlePill.textAlignment = .center
        titlePill.layer.cornerRadius = 14
        titlePill.clipsToBounds = true
        topBarView.addSubview(titlePill)
        titlePill.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(28)
            make.width.greaterThanOrEqualTo(120)
        }

        flashButton.setImage(UIImage(systemName: viewModel.flashIconName()), for: .normal)
        flashButton.tintColor = .white
        flashButton.addTarget(self, action: #selector(flashTapped), for: .touchUpInside)
        topBarView.addSubview(flashButton)
        flashButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        // 3. Bottom Bar & Shutter
        view.addSubview(bottomBarView)
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }

        setupShutterButton()
    }

    private func setupShutterButton() {
        shutterButton.layer.cornerRadius = 36
        shutterButton.layer.borderWidth = 4
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.backgroundColor = .clear

        let innerCircle = UIView()
        innerCircle.backgroundColor = .white
        innerCircle.layer.cornerRadius = 28
        innerCircle.isUserInteractionEnabled = false
        shutterButton.addSubview(innerCircle)
        innerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(56)
        }

        shutterButton.addTarget(self, action: #selector(shutterTapped), for: .touchUpInside)
        bottomBarView.addSubview(shutterButton)
        shutterButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(72)
        }
    }

    // MARK: - AVFoundation Session

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

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              captureSession.canAddInput(input) else {
            captureSession.commitConfiguration()
            return
        }

        captureSession.addInput(input)

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        captureSession.commitConfiguration()

        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(preview, at: 0)
        self.previewLayer = preview

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        captureSession.stopRunning()
        dismiss(animated: true)
    }

    @objc private func flashTapped() {
        _ = viewModel.toggleFlash()
        flashButton.setImage(UIImage(systemName: viewModel.flashIconName()), for: .normal)
    }

    @objc private func shutterTapped() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = viewModel.flashMode
        photoOutput.capturePhoto(with: settings, delegate: self)

        // Visual shutter animation
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.view.alpha = 1.0
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
