//
//  FaceViewController.swift
//  CameraModule
//
//  Created by Hoang Lam on 26/04/2022.
//

import UIKit

//MARK: - Outlet, Override
class FilterViewController: UIViewController {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collFilter: UICollectionView!
    
    var viewCamera: CameraFilterView!
    let listFilter: [FilterType] = [.none, .invert_color, .photo_instant, .crystallize, .comic, .bloom, .edges, .edge_work, .gloom, .highlight_shadow, .pixellate, .cmyk_halftone, .line_overlay, .posterize]
    
    let cellIdentifier = "CollectionFilterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCameraView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewCamera.stopCapture()
    }
    
    @IBAction func btnCaptureTapped(_ sender: Any) {
        viewCamera.isCapture = true
    }
}

//MARK: - Các hàm khởi tạo
extension FilterViewController {
    private func initComponents() {
        initCollectionView()
    }
    
    private func initCameraView() {
        viewCamera = CameraFilterView(
            bufferQueue: DispatchQueue(label: "Camera"),
            listFilters: self.listFilter,
            onResults: { image, cameraError in
                guard let image = image, cameraError == .none else {return}
                
                DispatchQueue.main.async {
                    guard let vc = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {return}
                    vc.imageResult = image
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        
        viewMain.addSubview(viewCamera)
        viewCamera.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewCamera.centerXAnchor.constraint(equalTo: viewMain.centerXAnchor, constant: 0),
            viewCamera.centerYAnchor.constraint(equalTo: viewMain.centerYAnchor, constant: 0),
            viewCamera.widthAnchor.constraint(equalTo: viewMain.widthAnchor, constant: 0),
            viewCamera.heightAnchor.constraint(equalTo: viewMain.heightAnchor, constant: 0)
        ])
        
        viewCamera.startCapture()
    }
    
    private func initCollectionView() {
        collFilter.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
        collFilter.dataSource = self
        collFilter.delegate = self
        collFilter.showsVerticalScrollIndicator = true
        collFilter.showsHorizontalScrollIndicator = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        collFilter.collectionViewLayout = layout
    }
}

//MARK: - Customize
extension FilterViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension FilterViewController {
    
}

//MARK: - Các hàm chức năng
extension FilterViewController {
    
}

//MARK: - Collection
extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? FilterCell else {return UICollectionViewCell()}
        cell.setupData(listFilter[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collFilter.bounds.height - 10, height: collFilter.bounds.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
