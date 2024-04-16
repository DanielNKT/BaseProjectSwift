//
//  ViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Toan on 3/16/21.
//
import UIKit
import RxSwift

enum SubVC: Int, CaseIterable {
    case favorite
    case map
    case addNew
}

class HomeViewController: BaseViewController, BindableType {
    
    private lazy var segmentedControlContainerView = UIView().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var segmentedControl = CustomSegmentedControl().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SubViewCell.self, forCellWithReuseIdentifier: "SubViewCell")
        return collectionView
    }()
    
    lazy var favorVC = FavoriteViewController().bind(FavoriteViewModel())
    lazy var mapVC = MapViewController().bind(MapViewModel())
    lazy var addNewVC = AddNewViewController().bind(AddNewViewModel())
    lazy var arrVC = [favorVC, mapVC, addNewVC]
    
    var viewModel: HomeViewModel!

    override func initUI() {
        super.initUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(segmentedControlContainerView)
        view.addSubview(collectionView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControl.delegate = self
        setConstraints()
    }

    fileprivate func setConstraints() {
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .top)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .left)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .right)
        
        segmentedControl.constraintsTo(view: segmentedControlContainerView)
        segmentedControl.heightItem(Constants.Segment.segmentedControlHeight)
        
        collectionView.constraintsTo(view: self.view, positions: .left)
        collectionView.constraintsTo(view: self.view, positions: .right)
        collectionView.constraintsTo(view: self.view, positions: .bottom)
        collectionView.constraintsTo(view: self.segmentedControlContainerView, positions: .topToBottom)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubVC.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubViewCell", for: indexPath) as! SubViewCell
        var vc: BaseViewController
        switch indexPath.item {
        case SubVC.favorite.rawValue:
            vc = FavoriteViewController().bind(FavoriteViewModel())
        case SubVC.map.rawValue:
            vc = MapViewController().bind(MapViewModel())
        default:
            vc = AddNewViewController().bind(AddNewViewModel())
        }
        cell.configCell(vc: vc)
        cell.backgroundColor = .yellow
        //cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        print("size: \(size)")
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.didSelectIndex(index: segmentedControl.currentIndex())
    }
}
                                    
extension HomeViewController: CustomSegmentedControlDelegate {
    func didSelectIndex(index: Int) {
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
            self.collectionView.isPagingEnabled = true
        }
    }
}
