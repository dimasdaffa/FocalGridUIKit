//
//  Markdown.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 12/07/26.
//

import UIKit

enum Markdown {
    static func attributed(_ text: String, font: UIFont, color: UIColor, lineSpacing: CGFloat = 0) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing

        guard let parsed = try? AttributedString(
            markdown: text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) else {
            return NSAttributedString(string: text, attributes: [
                .font: font, .foregroundColor: color, .paragraphStyle: paragraph
            ])
        }

        let result = NSMutableAttributedString()
        for run in parsed.runs {
            let piece = String(parsed[run.range].characters)
            var runFont = font

            if let intent = run.inlinePresentationIntent {
                var traits: UIFontDescriptor.SymbolicTraits = []
                if intent.contains(.stronglyEmphasized) { traits.insert(.traitBold) }
                if intent.contains(.emphasized) { traits.insert(.traitItalic) }
                if !traits.isEmpty,
                   let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                    runFont = UIFont(descriptor: descriptor, size: font.pointSize)
                }
            }

            result.append(NSAttributedString(
                string: piece,
                attributes: [.font: runFont, .foregroundColor: color, .paragraphStyle: paragraph]
            ))
        }
        return result
    }
}
