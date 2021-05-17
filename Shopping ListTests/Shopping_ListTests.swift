//
//  Shopping_ListTests.swift
//  Shopping ListTests
//
//  Created by Gundars Kokins on 10/05/2021.
//

import XCTest
import Firebase
@testable import Shopping_List

class Shopping_ListTests: XCTestCase {
    var database: RealtimeDatabase?

    override func setUpWithError() throws {
        database = RealtimeDatabase(url: "https://shopping-list-6172f-default-rtdb.europe-west1.firebasedatabase.app/", path: "tests/shopping-list/baskets")
        database?.allShoppingItems = []
        database?.baskets = []
        database?.activeShoppingBasket = []
    }

    override func tearDownWithError() throws {
        database?.ref.removeValue()
    }
    
    func testSaveItem() {
        let expectation = XCTestExpectation(description: "Wait for saved items")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(self.database!.activeShoppingBasket.isEmpty)
            XCTAssert(self.database!.allShoppingItems.isEmpty)

            self.database?.addBasket(with: "test save")
            self.database?.saveItem(with: "saved item 1", in: "test save")
            self.database?.saveItem(with: "saved item 2", in: "test save")
            self.database?.saveItem(with: "saved item 3", in: "test save")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.database?.populateActiveShoppingList(with: "test save")
                XCTAssertEqual(self.database?.activeShoppingBasket.map { $0.name }, ["saved item 1", "saved item 2", "saved item 3"])
                XCTAssertEqual(self.database?.allShoppingItems.map { $0.name }, ["saved item 1", "saved item 2", "saved item 3"])
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteItem() {
        let expectation = XCTestExpectation(description: "Wait for deleted items")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(self.database!.activeShoppingBasket.isEmpty)
            
            self.database?.addBasket(with: "test save")
            self.database?.saveItem(with: "saved item 1", in: "test save")
            self.database?.saveItem(with: "saved item 2", in: "test save")
            self.database?.saveItem(with: "saved item 3", in: "test save")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.database?.populateActiveShoppingList(with: "test save")
                XCTAssertEqual(self.database?.activeShoppingBasket.map { $0.name }, ["saved item 1", "saved item 2", "saved item 3"])
                XCTAssertEqual(self.database?.allShoppingItems.map { $0.name }, ["saved item 1", "saved item 2", "saved item 3"])
                
                let indexes = IndexSet(integer: 0)
                
                self.database?.deleteItem(at: indexes)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    XCTAssertEqual(self.database?.activeShoppingBasket.map { $0.name }, ["saved item 2", "saved item 3"])
                    XCTAssertEqual(self.database?.allShoppingItems.map { $0.name }, ["saved item 2", "saved item 3"])
                    
                    let indexes = IndexSet(integersIn: 0...1)
                    
                    self.database?.deleteItem(at: indexes)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        XCTAssert(self.database!.activeShoppingBasket.isEmpty)
                        XCTAssert(self.database!.allShoppingItems.isEmpty)
                        
                        
                        expectation.fulfill()
                        
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddBasket() {
        let expectation = XCTestExpectation(description: "Wait for added baskets")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(self.database!.baskets.isEmpty)

            self.database?.addBasket(with: "test basket 1")
            self.database?.addBasket(with: "test basket 2")
            self.database?.addBasket(with: "test basket 3")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                XCTAssertEqual(self.database?.baskets.map { $0.name }, ["All items", "test basket 1", "test basket 2", "test basket 3"])
                self.database?.baskets.forEach {
                    XCTAssert($0.items.isEmpty)
                }

                expectation.fulfill()
            }
        }
    
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPopulateActiveShoppingList() {
        let expectation = XCTestExpectation(description: "wait for items to populate")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.database?.populateActiveShoppingList(with: "All items")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                XCTAssert(self.database!.activeShoppingBasket.isEmpty)
                XCTAssert(self.database!.allShoppingItems.isEmpty)

                self.database?.addBasket(with: "test")
                self.database?.saveItem(with: "test", in: "test")

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    self.database?.populateActiveShoppingList(with: "test")
                    
                    XCTAssertEqual(self.database?.activeShoppingBasket.map { $0.name }, ["test"])
                    XCTAssertEqual(self.database?.allShoppingItems.map { $0.name }, ["test"])

                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
