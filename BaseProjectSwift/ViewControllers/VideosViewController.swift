//
//  VideosViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 25/3/25.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

class VideosViewController: BaseViewController, BindableType {
    var viewModel: VideosViewModel!
    
    private var cities = ["Logout"]
    private let videoTap = PublishSubject<Video>()
    
    let bag = DisposeBag()
    
    private lazy var tableView = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(SquareImageCell.self, forCellReuseIdentifier: "cell")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        $0.estimatedRowHeight = 100
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: self.view, positions: .top)
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingTap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingTap))
        self.navigationController?.navigationBar.topItem?.title = "Videos"
        
        videoTap.subscribe { [weak self] video in
            self?.playVideo(video: video)
        }.disposed(by: bag)
    }
    
    @objc func settingTap() {
        print("setting tapped")
        let firstVC = ProfileViewController().bind(ProfileViewModel())
        self.navigationController?.pushViewController(firstVC, animated: true)
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SquareImageCell
        cell.configure(with: files[indexPath.row])
        cell.videoTap.bind(to: self.videoTap).disposed(by: cell.disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VideosViewController {
    func playVideo(video: Video) {
        let player = AVPlayer(url: video.fileURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

final class SquareImageCell: UITableViewCell {
    
    let videoTap = PublishSubject<Video>()
    var disposeBag = DisposeBag()
    
    private var video: Video?
    
    private static let thumbnailCache = NSCache<NSString, UIImage>()
    
    // MARK: - Image View
    private let squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(squareImageView)
        
        squareImageView.constraintsTo(view: contentView, positions: .top)
        squareImageView.constraintsTo(view: contentView, positions: .left)
        squareImageView.constraintsTo(view: contentView, positions: .right)
        squareImageView.constraintsTo(view: contentView, positions: .bottom)
        squareImageView.heightAnchor.constraint(equalTo: squareImageView.widthAnchor).isActive = true

        squareImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(squareImageTapped))
        squareImageView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Gesture
    @objc private func squareImageTapped() {
        guard let video = video else { return }
        videoTap.onNext(video)
    }

    // MARK: - Configure Cell
    func configure(with video: Video) {
        self.video = video
        let cacheKey = video.fileURL.absoluteString as NSString

        if let cachedImage = Self.thumbnailCache.object(forKey: cacheKey) {
            squareImageView.image = cachedImage
            return
        }

        squareImageView.image = UIImage(systemName: "photo") // placeholder

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let thumbnail = self?.generateThumbnail(from: video.fileURL) else { return }

            Self.thumbnailCache.setObject(thumbnail, forKey: cacheKey)

            DispatchQueue.main.async {
                // Protect against reuse
                guard self?.video?.fileURL == video.fileURL else { return }
                self?.squareImageView.image = thumbnail
            }
        }
    }

    // MARK: - Thumbnail Generation
    private func generateThumbnail(from url: URL, at time: CMTime = CMTime(seconds: 1, preferredTimescale: 600)) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        squareImageView.image = nil
        video = nil
    }
}

