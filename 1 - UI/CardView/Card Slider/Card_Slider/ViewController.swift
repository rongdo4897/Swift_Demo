//
//  ViewController.swift
//  Card_Slider
//
//  Created by Hoang Tung Lam on 4/9/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collCard: UICollectionView!
    
    let listColors:[UIColor] = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
}

//MARK: - Các hàm init, setup, custom
extension ViewController {
    func initComponents() {
        initCollectionView()
    }
    
    func initCollectionView() {
        collCard.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
        collCard.delegate = self
        collCard.dataSource = self
        collCard.showsHorizontalScrollIndicator = false
        let layout = KVFlowLayout()
        layout.scrollDirection = .horizontal
        collCard.collectionViewLayout = layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {return UICollectionViewCell()}
        cell.setUpData(color: listColors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collCard.bounds.width, height: collCard.bounds.height)
    }
}
