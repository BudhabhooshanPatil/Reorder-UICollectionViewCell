//
//  ViewController.swift
//  Reorder-Swift
//
//  Created by Neebal Tech on 30/10/19.
//  Copyright © 2019 Neebal Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let numberOfCellsPerRow:CGFloat = 2
    let reuseIdentifier = "Cell"
    var items = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints for UICollectionView
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: ["collectionView":collectionView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["collectionView":collectionView]);
        self.view.addConstraints(horizontal);
        self.view.addConstraints(vertical);
    }
    
    
    lazy var collectionView: UICollectionView = {
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout());
        collectionview.dataSource = self;
        collectionview.delegate = self;
        collectionview.dragDelegate = self
        collectionview.dropDelegate = self
        collectionview.dragInteractionEnabled = true
        collectionview.alwaysBounceVertical = true;
        collectionview.backgroundColor = .white;
        collectionview.register(ReorderCell.self, forCellWithReuseIdentifier: reuseIdentifier);
        return collectionview;
        
    }()
    
    fileprivate func reorderItems(cordinator:UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView:UICollectionView ) {
        
        if let item = cordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                
            }, completion: nil)
            
            cordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
extension ViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ReorderCell {
            cell.tag = indexPath.row;
            return cell;
        }
        return UICollectionViewCell();
    }
}
//extension ViewController:UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        print("Starting Index: \(sourceIndexPath.item)")
//        print("Ending Index: \(destinationIndexPath.item)")
//
//        items.insert(items.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
//
//    }
//}
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalwidth = collectionView.bounds.size.width;
        let dimensions = CGSize(width: (totalwidth/numberOfCellsPerRow) - 16.0, height: totalwidth/numberOfCellsPerRow)
        
        return dimensions;
    }
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
extension ViewController :UICollectionViewDragDelegate {


    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

}
extension ViewController :UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        var estinationIndexPath:IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            estinationIndexPath = indexPath
        }else
        {
            let row = collectionView.numberOfItems(inSection: 0)
            estinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(cordinator: coordinator, destinationIndexPath: estinationIndexPath, collectionView: collectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
}
