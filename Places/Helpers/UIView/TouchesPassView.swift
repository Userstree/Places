//
// Created by Dossymkhan Zhulamanov on 04.07.2022.
//

import UIKit

class TouchesPassView: UIView {

    override func hitTest(_ point: CGPoint,
                          with event: UIEvent?) -> UIView?
    {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        return view
    }
}
