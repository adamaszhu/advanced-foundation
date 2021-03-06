class VersionHelperSpecs: QuickSpec {
    
    override func spec() {
        let versionFlag = "VersionFlag"
        let versionHelper = VersionHelper.standard
        afterEach {
            versionHelper?.deleteVersionFlag()
        }
        describe("has shared object") {
            it("is not nil") {
                expect(VersionHelper.standard).toNot(beNil())
            }
        }
        describe("has grand version") {
            context("with valid version") {
                let versionHelper = VersionHelper(version: "1.0.0", versionFlag: versionFlag)
                it("returns grand version") {
                    expect(versionHelper?.grandVersion) == 1
                }
            }
            context("with invalid character in version") {
                let versionHelper = VersionHelper(version: "1.c", versionFlag: versionFlag)
                it("returns nil") {
                    expect(versionHelper?.grandVersion).to(beNil())
                }
            }
            context("with invalid format in version") {
                let versionHelper = VersionHelper(version: "1..0", versionFlag: versionFlag)
                it("returns nil") {
                    expect(versionHelper?.grandVersion).to(beNil())
                }
            }
        }
        describe("has hasVersionFlag") {
            context("without version flag saved") {
                it("misses flag") {
                    expect(versionHelper?.hasVersionFlag) == false
                }
            }
            context("with version flag saved") {
                it("finds flag") {
                    versionHelper?.createVersionFlag()
                    expect(versionHelper?.hasVersionFlag) == true
                }
            }
        }
        describe("calls compareCurrentVersion(toVersion)") {
            let versionHelper = VersionHelper(version: "1.0.0", versionFlag: versionFlag)!
            context("with earlier version") {
                it("returns bigger result") {
                    expect(versionHelper.compareCurrentVersion(toVersion: "0.9.9")) == 1
                }
            }
            context("with later version") {
                it("returns smaller result") {
                    expect(versionHelper.compareCurrentVersion(toVersion: "1.0.1")) == -1
                }
            }
            context("with equal version") {
                it("returns equal result") {
                    expect(versionHelper.compareCurrentVersion(toVersion: "1.0.0")) == 0
                }
            }
            context("with invalid character in version") {
                it("returns invalid result") {
                    expect(versionHelper.compareCurrentVersion(toVersion: "1.c")).to(beNil())
                }
            }
            context("with invalid format in version") {
                it("returns invalid result") {
                    expect(versionHelper.compareCurrentVersion(toVersion: ".1")).to(beNil())
                }
            }
        }
        describe("calls createVersionFlag()") {
            context("without version flag saved") {
                it("misses flag") {
                    versionHelper?.createVersionFlag()
                    expect(versionHelper?.hasVersionFlag) == true
                }
            }
            context("with version flag saved") {
                it("finds flag") {
                    versionHelper?.createVersionFlag()
                    versionHelper?.createVersionFlag()
                    expect(versionHelper?.hasVersionFlag) == true
                }
            }
        }
        describe("calls deleteVersionFlag()") {
            context("without version flag saved") {
                it("misses flag") {
                    versionHelper?.deleteVersionFlag()
                    expect(versionHelper?.hasVersionFlag) == false
                }
            }
            context("with version flag saved") {
                it("misses flag") {
                    versionHelper?.createVersionFlag()
                    versionHelper?.deleteVersionFlag()
                    expect(versionHelper?.hasVersionFlag) == false
                }
            }
        }
        describe("calls init(version:versionFlag)") {
            context("with valid version") {
                let versionHelper = VersionHelper(version: "1.0.0", versionFlag: versionFlag)
                it("returns object") {
                    expect(versionHelper).toNot(beNil())
                }
            }
            context("with invalid character in version") {
                let versionHelper = VersionHelper(version: "1.c", versionFlag: versionFlag)
                it("returns nil") {
                    expect(versionHelper).to(beNil())
                }
            }
            context("with invalid format in version") {
                let versionHelper = VersionHelper(version: "1..0", versionFlag: versionFlag)
                it("returns nil") {
                    expect(versionHelper).to(beNil())
                }
            }
        }
    }
}

import Nimble
import Quick
@testable import AdvancedFoundation
