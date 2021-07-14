//
//  AppFont.swift
//  Hackers
//
//  Created by Weiran Zhang on 09/01/2019.
//  Copyright © 2019 Weiran Zhang. All rights reserved.
//

import UIKit

enum AppFont {
    static func commentUsernameFont(collapsed: Bool) -> UIFont {
        let fontFunc = collapsed ? scaledItalicFont : scaledFont
        return fontFunc(.subheadline, 15, .medium)
    }

    static func commentDateFont(collapsed: Bool) -> UIFont {
        let fontFunc = collapsed ? scaledItalicFont : scaledFont
        return fontFunc(.subheadline, 15, .regular)
    }

    private static func scaledFont(for textStyle: UIFont.TextStyle,
                                   of size: CGFloat,
                                   with weight: UIFont.Weight) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let scaledFont = fontMetrics.scaledFont(for: font)
        return scaledFont
    }

    private static func scaledItalicFont(for textStyle: UIFont.TextStyle,
                                         of size: CGFloat,
                                         with weight: UIFont.Weight) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let font = UIFont.italicSystemFont(ofSize: size)
        let scaledFont = fontMetrics.scaledFont(for: font)
        return scaledFont
    }
}
