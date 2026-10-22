//
//  ToDoIpadUITests.swift
//  ToDoIpadUITests
//
//  Created by Rafael Cabrera on 10/22/26.
//

import XCTest

final class ToDoIpadUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testLaunchInEnglish() {
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        
        let header = app.staticTexts["Choose a profile"]
        
        XCTAssertTrue(header.exists, "The english header 'who is working today' is not found on the initial screen")
    }
    
    func testCreateNewTaskGroup() {
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        
        let profileSelected = app.buttons["profileProfessorBtn"]
        profileSelected.tap()
        
        let addBtn = app.buttons["addGroupBtn"]
        addBtn.tap()
        
        let titleNewGroup = app.staticTexts["New Group Creator"]
        XCTAssertTrue(titleNewGroup.exists, "The text fields for creating a new group is not found")
    }

    func testAddGroupInEnglish() {
        addGroup(languageCode: "en", locale: "en_US", newGroupTitle: "New Group Creator")
    }

    func testAddGroupInSpanish() {
        addGroup(languageCode: "es-419", locale: "es_419", newGroupTitle: "Creador de nuevo grupo")
    }

    func testAddGroupInJapanese() {
        addGroup(languageCode: "ja", locale: "ja_JP", newGroupTitle: "新規グループ作成")
    }

    func testAddGroupInArabic() {
        addGroup(languageCode: "ar", locale: "ar", newGroupTitle: "إنشاء مجموعة جديدة")
    }

    private func element(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }

    private func addGroup(languageCode: String, locale: String, newGroupTitle: String) {
        let groupName = "UITest\(languageCode)"

        app.launchArguments = ["-AppleLanguages", "(\(languageCode))", "-AppleLocale", locale]
        app.launch()

        let profile = element("profileProfessorBtn")
        XCTAssertTrue(profile.waitForExistence(timeout: 5), "Profile button not found in \(languageCode)")
        profile.tap()

        let addGroupBtn = element("addGroupBtn")
        XCTAssertTrue(addGroupBtn.waitForExistence(timeout: 5), "Add group button not found in \(languageCode)")
        addGroupBtn.tap()

        XCTAssertTrue(app.navigationBars[newGroupTitle].waitForExistence(timeout: 5), "New group title is not localized in \(languageCode)")

        let nameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5), "Group name field not found in \(languageCode)")
        nameField.tap()
        nameField.typeText(groupName)

        element("iconSelectedstar.fillBtn").tap()
        element("saveNewGroupBtn").tap()

        XCTAssertTrue(element("group\(groupName)Btn").waitForExistence(timeout: 5), "New group was not added in \(languageCode)")
    }
}
