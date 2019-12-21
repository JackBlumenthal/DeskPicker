//
//  ViewController.swift
//  Not A Shopping List
//
//  Created by Kenny on 12/20/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class NotAShoppingListVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var deskDealer = FurnitureDealer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        deskDealer.makeDesksNotWar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: Helper Methods
    func youTouchedIt(cell: DeskCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        if cell.desk?.wasTouched != nil {
            cell.desk!.wasTouched = !cell.desk!.wasTouched
        } else { //if desk is nil, set wasTouched to true since it was just touched
            cell.desk!.wasTouched = true
        }
        animateCell(cell: cell)
        deskDealer.touchIt(forDesk: deskDealer.desks[indexPath.item])
    }
    
    func animateCell(cell: DeskCell) {
        if cell.desk!.wasTouched {
            UIView.animate(withDuration: 0.5) {
               cell.backgroundColor = .red
            }
        } else {
            UIView.animate(withDuration: 0.5) {
               cell.backgroundColor = .green
            }
        }
    }

}

extension NotAShoppingListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DeskCell else {return}
        youTouchedIt(cell: cell)
    }
}

extension NotAShoppingListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        deskDealer.desks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DeskCell else {return UICollectionViewCell()}
        cell.desk = deskDealer.desks[indexPath.item]
        animateCell(cell: cell) //doesn't animate, but it does set the cell color
        
        
        
//        if cell.desk!.wasTouched { //assigned on line above
//            //Initially I was reloading the collectionView in the helper method that sets the Bool. This caused a visual bug since all of the cells would animate from green to red (and some back to green depending on the Bool value). Instead, I also animated in the helper method, and removed the reloadData call since it's no longer needed.
//            //can be resolved by moving code to helper method and probably not reloading tableView
//            UIView.animate(withDuration: 0.5) {
//                cell.backgroundColor = .red
//            }
//        } else {
//            UIView.animate(withDuration: 0.5) {
//                cell.backgroundColor = .green
//            }
//        }
        //cell.delegate = self
        return cell
    }
}
