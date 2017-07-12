class TextHelperSpecs: QuickSpec {
    
    override func spec() {
        describe("has lines") {
            context("if content has comment") {
                let content = "// COMMENT\nLine1\nLine2"
                let txt = TXT.txt(from: content)
                it("is parsed to 2 lines") {
                    expect(txt.lines.count) == 2
                }
            }
            context("if content doesn't have comment") {
                let content = "\nLine2"
                let txt = TXT.txt(from: content)
                it("is parsed to 2 lines") {
                    expect(txt.lines.count) == 2
                }
            }
        }
    }
    
}

import Quick
import Nimble
@testable import AdvancedFoundation

