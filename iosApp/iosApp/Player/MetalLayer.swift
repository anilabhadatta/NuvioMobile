import Foundation
import UIKit

class MetalLayer: CAMetalLayer {
    override var drawableSize: CGSize {
        get { return super.drawableSize }
        set {
            if Int(newValue.width) > 1 && Int(newValue.height) > 1 {
                super.drawableSize = newValue
            }
        }
    }

    override var wantsExtendedDynamicRangeContent: Bool {
        get { return super.wantsExtendedDynamicRangeContent }
        set {
            if Thread.isMainThread {
                super.wantsExtendedDynamicRangeContent = newValue
            } else {
                DispatchQueue.main.sync {
                    super.wantsExtendedDynamicRangeContent = newValue
                }
            }
        }
    }
}

final class MetalLayerView: UIView {
    override class var layerClass: AnyClass {
        MetalLayer.self
    }

    var metalLayer: MetalLayer {
        layer as! MetalLayer
    }

    private var lastAppliedDrawableSize: CGSize = .zero

    override func layoutSubviews() {
        super.layoutSubviews()
        syncDrawableSize()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        syncDrawableSize()
    }

    func syncDrawableSize() {
        let boundsSize = bounds.size
        guard boundsSize.width > 1, boundsSize.height > 1 else { return }

        let scale = window?.screen.nativeScale ?? UIScreen.main.nativeScale
        let drawableSize = CGSize(
            width: (boundsSize.width * scale).rounded(.toNearestOrAwayFromZero),
            height: (boundsSize.height * scale).rounded(.toNearestOrAwayFromZero)
        )

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        metalLayer.contentsScale = scale
        if drawableSize != lastAppliedDrawableSize {
            metalLayer.drawableSize = drawableSize
            lastAppliedDrawableSize = drawableSize
        }
        CATransaction.commit()
    }
}
