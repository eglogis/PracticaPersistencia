//
//  NoteDetailViewController.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 10/2/21.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {

    @IBOutlet var titleNote: UITextField?
    @IBOutlet var contentNote: UITextView?

    var dataController: DataController?
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var note: NoteMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoteDetails()
    }

    private func setupNoteDetails() {
        title = "Details"
        guard note != nil else { return }
        titleNote?.text = note?.title
        contentNote?.text = note?.contents
    }
}
