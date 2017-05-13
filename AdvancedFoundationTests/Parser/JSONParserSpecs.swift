class JSONParserSpecs: QuickSpec {
    
    override func spec() {
        let json = "{\"attribute1\":\"value1\",\"attribute2\":[{\"arrayAttribute1\":\"arrayValue1\"},{\"arrayAttribute2\":\"arrayValue2\"}],\"attribute3\":0,\"attribute4\":{\"subAttribute1\":\"subValue1\"}}"
        let jsonParser = JSONParser(withString: json)
        describe("calls init(withString)") {
            context("with valid string") {
                it("returns parser with json") {
                    expect(jsonParser.getDictionary(atPath: ".")).notTo(beNil())
                }
            }
            context("with invalid string") {
                let jsonParser = JSONParser(withString: "test")
                it("returns parser with empty json") {
                    expect(jsonParser.getDictionary(atPath: ".")).to(beNil())
                }
            }
        }
        describe("calls init(withData)") {
            context("with valid data") {
                let jsonParser = JSONParser(withData: json.data(using: .utf8)!)
                it("returns parser with json") {
                    expect(jsonParser.getDictionary(atPath: ".")).notTo(beNil())
                }
            }
            context("with invalid data") {
                let jsonParser = JSONParser(withData: "test".data(using: .utf8)!)
                it("returns parser with empty json") {
                    expect(jsonParser.getDictionary(atPath: ".")).to(beNil())
                }
            }
        }
        describe("calls getString(atPath:fromNode)") {
            context("with root path") {
                it("returns nil") {
                    expect(jsonParser.getString(atPath: "/")).to(beNil())
                }
            }
            context("with incorrect path") {
                it("returns nil") {
                    expect(jsonParser.getString(atPath: "///")).to(beNil())
                }
            }
            context("with non existing path") {
                it("returns nil") {
                    expect(jsonParser.getString(atPath: "attribute5")).to(beNil())
                }
            }
            context("with correct path but wrong type") {
                it("returns nil") {
                    expect(jsonParser.getString(atPath: "attribute2")).to(beNil())
                }
            }
            context("with self node in path and correct type") {
                it("returns value1") {
                    expect(jsonParser.getString(atPath: "./attribute1")) == "value1"
                }
            }
            context("with correct absolute path and correct type") {
                it("returns value1") {
                    expect(jsonParser.getString(atPath: "/attribute1")) == "value1"
                }
            }
            context("with correct relative path and correct type") {
                it("returns value1") {
                    expect(jsonParser.getString(atPath: "attribute1")) == "value1"
                }
            }
            context("with invalid node") {
                it("returns nil") {
                    expect(jsonParser.getString(atPath: "attribute1", fromNode: 1)).to(beNil())
                }
            }
            context("with non existing path and correct node") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getString(atPath: "attribute5", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with correct path, correct node but wrong type") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getString(atPath: "attribute2", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with self node in path, correct type and correct node") {
                it("returns value1") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getString(atPath: "./attribute1", fromNode: dictionaryNode)) == "value1"
                }
            }
            context("with correct absolute path, correct type and correct node") {
                it("returns value1 working as absolute path only") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getString(atPath: "/attribute1", fromNode: dictionaryNode)) == "value1"
                }
            }
            context("with correct related path, correct type and correct node") {
                it("returns value1") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getString(atPath: "attribute1", fromNode: dictionaryNode)) == "value1"
                }
            }
        }
        describe("calls getArray(atPath:fromNode)") {
            context("with root path") {
                it("returns nil") {
                    expect(jsonParser.getArray(atPath: "/")).to(beNil())
                }
            }
            context("with incorrect path") {
                it("returns nil") {
                    expect(jsonParser.getArray(atPath: "///")).to(beNil())
                }
            }
            context("with non existing path") {
                it("returns nil") {
                    expect(jsonParser.getArray(atPath: "attribute5")).to(beNil())
                }
            }
            context("with correct path but wrong type") {
                it("returns nil") {
                    expect(jsonParser.getArray(atPath: "attribute1")).to(beNil())
                }
            }
            context("with self node in path and correct type") {
                it("returns the array") {
                    expect(jsonParser.getArray(atPath: "./attribute2")?.count) == 2
                }
            }
            context("with correct absolute path and correct type") {
                it("returns the array") {
                    expect(jsonParser.getArray(atPath: "/attribute2")?.count) == 2
                }
            }
            context("with correct relative path and correct type") {
                it("returns the array") {
                    expect(jsonParser.getArray(atPath: "attribute2")?.count) == 2
                }
            }
            context("with invalid node") {
                it("returns nil") {
                    expect(jsonParser.getArray(atPath: "attribute2", fromNode: 1)).to(beNil())
                }
            }
            context("with non existing path and correct node") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getArray(atPath: "attribute5", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with correct path, correct node but wrong type") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getArray(atPath: "attribute1", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with self node in path, correct type and correct node") {
                it("returns the array") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getArray(atPath: "./attribute2", fromNode: dictionaryNode)?.count) == 2
                }
            }
            context("with correct absolute path, correct type and correct node") {
                it("returns the array working as absolute path only") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getArray(atPath: "/attribute2", fromNode: dictionaryNode)?.count) == 2
                }
            }
            context("with correct related path, correct type and correct node") {
                it("returns the array") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getArray(atPath: "attribute2", fromNode: dictionaryNode)?.count) == 2
                }
            }
            context("with correct related path, correct type and aiming at sub node") {
                it("returns the arrayValue1") {
                    expect(jsonParser.getString(atPath: "attribute2[0]/arrayAttribute1")) == "arrayValue1"
                }
            }
        }
        describe("calls getDouble(atPath:fromNode)") {
            context("with root path") {
                it("returns nil") {
                    expect(jsonParser.getDouble(atPath: "/")).to(beNil())
                }
            }
            context("with incorrect path") {
                it("returns nil") {
                    expect(jsonParser.getDouble(atPath: "///")).to(beNil())
                }
            }
            context("with non existing path") {
                it("returns nil") {
                    expect(jsonParser.getDouble(atPath: "attribute5")).to(beNil())
                }
            }
            context("with correct path but wrong type") {
                it("returns nil") {
                    expect(jsonParser.getDouble(atPath: "attribute1")).to(beNil())
                }
            }
            context("with self node in path and correct type") {
                it("returns 0") {
                    expect(jsonParser.getDouble(atPath: "./attribute3")) == 0
                }
            }
            context("with correct absolute path and correct type") {
                it("returns 0") {
                    expect(jsonParser.getDouble(atPath: "/attribute3")) == 0
                }
            }
            context("with correct relative path and correct type") {
                it("returns 0") {
                    expect(jsonParser.getDouble(atPath: "attribute3")) == 0
                }
            }
            context("with invalid node") {
                it("returns nil") {
                    expect(jsonParser.getDouble(atPath: "attribute3", fromNode: 1)).to(beNil())
                }
            }
            context("with non existing path and correct node") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDouble(atPath: "attribute5", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with correct path, correct node but wrong type") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDouble(atPath: "attribute1", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with self node in path, correct type and correct node") {
                it("returns 0") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDouble(atPath: "./attribute3", fromNode: dictionaryNode)) == 0
                }
            }
            context("with correct absolute path, correct type and correct node") {
                it("returns 0 working as absolute path only") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDouble(atPath: "/attribute3", fromNode: dictionaryNode)) == 0
                }
            }
            context("with correct related path, correct type and correct node") {
                it("returns 0") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDouble(atPath: "attribute3", fromNode: dictionaryNode)) == 0
                }
            }
        }
        describe("calls getDictionary(atPath:fromNode)") {
            context("with root path") {
                it("returns nil") {
                    expect(jsonParser.getDictionary(atPath: "/")).to(beNil())
                }
            }
            context("with incorrect path") {
                it("returns nil") {
                    expect(jsonParser.getDictionary(atPath: "///")).to(beNil())
                }
            }
            context("with non existing path") {
                it("returns nil") {
                    expect(jsonParser.getDictionary(atPath: "attribute5")).to(beNil())
                }
            }
            context("with correct path but wrong type") {
                it("returns nil") {
                    expect(jsonParser.getDictionary(atPath: "attribute1")).to(beNil())
                }
            }
            context("with self node in path and correct type") {
                it("returns the dictionary") {
                    expect(jsonParser.getDictionary(atPath: "./attribute4")).notTo(beNil())
                }
            }
            context("with correct absolute path and correct type") {
                it("returns the dictionary") {
                    expect(jsonParser.getDictionary(atPath: "/attribute4")).notTo(beNil())
                }
            }
            context("with correct relative path and correct type") {
                it("returns the dictionary") {
                    expect(jsonParser.getDictionary(atPath: "attribute4")).notTo(beNil())
                }
            }
            context("with invalid node") {
                it("returns nil") {
                    expect(jsonParser.getDictionary(atPath: "attribute4", fromNode: 1)).to(beNil())
                }
            }
            context("with non existing path and correct node") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDictionary(atPath: "attribute5", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with correct path, correct node but wrong type") {
                it("returns nil") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDictionary(atPath: "attribute1", fromNode: dictionaryNode)).to(beNil())
                }
            }
            context("with self node in path, correct type and correct node") {
                it("returns the dictionary") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDictionary(atPath: "./attribute4", fromNode: dictionaryNode)).notTo(beNil())
                }
            }
            context("with correct absolute path, correct type and correct node") {
                it("returns the dictionary working as absolute path only") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDictionary(atPath: "/attribute4", fromNode: dictionaryNode)).notTo(beNil())
                }
            }
            context("with correct related path, correct type and correct node") {
                it("returns the dictionary") {
                    let dictionaryNode = jsonParser.getDictionary(atPath: ".")
                    expect(jsonParser.getDictionary(atPath: "attribute4", fromNode: dictionaryNode)).notTo(beNil())
                }
            }
            context("with correct related path, correct type and aiming at sub node") {
                it("returns the subValue1") {
                    expect(jsonParser.getString(atPath: "attribute4/subAttribute1")) == "subValue1"
                }
            }
        }
    }
    
}

import Quick
import Nimble
@testable import AdvancedFoundation
