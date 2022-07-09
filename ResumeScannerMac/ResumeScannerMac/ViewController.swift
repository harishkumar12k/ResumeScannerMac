//
//  ViewController.swift
//  ResumeScannerMac
//
//  Created by Harish Kumar on 09/07/22.
//

import Cocoa
import PDFKit

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var skillsVerification: [String:Bool] = [:]
    var skillSets: [String] = []
    var resumeContent = ""
    
    @IBOutlet weak var skillTextField: NSTextField!
    @IBOutlet weak var skillSetTableView: NSTableView!
    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var pdfViewer: PDFView!
    
    @IBAction func selectAction(_ sender: NSButton) {
        selectFile()
    }
    
    @IBAction func addSkillAction(_ sender: NSButton) {
        let skill = "\(skillTextField.stringValue.lowercased())"
        if !skillSets.contains(skill) {
            skillSets.append(skill)
            if resumeContent.contains(skill) {
                skillsVerification[skill] = true
            } else {
                skillsVerification[skill] = false
            }
            skillSetTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.title = "Select File"
        skillSetTableView.delegate = self
        skillSetTableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return skillSets.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
     
        let skill = skillSets[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "skillColumn") {
         
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "skillCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = "\(skill)"
            return cellView
         
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "okColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "okCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = skillsVerification[skill]! ? "OK" : "Not OK"
            return cellView
        } else {
         
        }
        
        return nil
    }

    func selectFile() {
        let dialog = NSOpenPanel();

        dialog.title = "Choose an PDF File";
        dialog.showsResizeIndicator = true;
        dialog.showsHiddenFiles = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.allowsOtherFileTypes = true

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                print(path)
                let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))
                pdfViewer.displayMode = .singlePageContinuous
                pdfViewer.autoScales = true
                pdfViewer.displayDirection = .vertical
                pdfViewer.document = pdfDocument
                resumeContent = pdfDocument!.string!.lowercased()
                print(resumeContent)
            }
        } else {
            return
        }
    }
    
}

