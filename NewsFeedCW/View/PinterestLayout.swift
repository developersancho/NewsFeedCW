//
//  Pinterest.swift
//  NewsFeedCW
//
//  Created by developersancho on 28.10.2018.
//  Copyright © 2018 developersancho. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    // memory leak olur
    // var controller: NewsFeedCollectionViewController?
    var delegate: PinterestLayoutDelegate?
    
    var numberOfColumns: CGFloat = 2
    var cellPadding: CGFloat = 5.0
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let inset = collectionView!.contentInset
        return (collectionView!.bounds.width - inset.left + inset.right)
    }
    private var attributesCache = [PinterestLayoutAttributes]()
    
    
    // calculate attributes for each of cell
    override func prepare() {
        if attributesCache.isEmpty {
            let columnWidth = contentWidth/numberOfColumns
            var xOffset = [CGFloat]()
            for column in 0 ..< Int(numberOfColumns) {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: Int(numberOfColumns))
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0){
                let indexPath = IndexPath(item: item, section: 0)
                // calculate to frame
                let width = columnWidth - cellPadding * 2
                
                let photoHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!, heightForPhotoAt: indexPath, with: width))!
                
                let captionHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!, heightForCaptionAt: indexPath, with: width))!
                
                let height: CGFloat = cellPadding + photoHeight + captionHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                // create cell attributes
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributesCache.append(attributes)
                
                // update column, yOffset
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                if column >= Int((numberOfColumns - 1)) {
                    column = 0
                } else {
                    column += 1
                }
                
            }
            
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // set content height for collection view
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache {
            if attributes.frame.intersects(rect){
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
}


class PinterestLayoutAttributes: UICollectionViewLayoutAttributes
{
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        
        return false
    }
}
