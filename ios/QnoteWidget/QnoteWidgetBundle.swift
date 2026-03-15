//
//  QnoteWidgetBundle.swift
//  QnoteWidget
//
//  Created by 豊川哲次 on 2026/03/15.
//

import WidgetKit
import SwiftUI

@main
struct QnoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        QnoteWidgetSmall()
        QnoteWidgetMedium()
        QnoteWidgetLarge()
    }
}
