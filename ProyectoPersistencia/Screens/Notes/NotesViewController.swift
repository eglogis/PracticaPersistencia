//
//  NotesViewController.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 9/2/21.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    @IBOutlet var tableView: UITableView?

    var dataController: DataController?
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var notebook: NotebookMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        initializeFetchResultsController()
        setupTable()
    }

    func initializeFetchResultsController() {

        guard let dataController = dataController,
              let notebook = notebook else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")

        let noteCreateAtSortDescriptor = NSSortDescriptor(key: "createAt", ascending: true)
        fetchRequest.sortDescriptors = [noteCreateAtSortDescriptor]

        fetchRequest.predicate = NSPredicate(format: "notebook == %@", notebook)

        let managedObjectContext = dataController.viewContext

        fetchResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchResultsController?.delegate = self

        do {
            try fetchResultsController?.performFetch()
        } catch {
            fatalError("couldn't find notes \(error.localizedDescription) ")
        }
    }

    private func setupTable() {
        tableView?.dataSource = self
        // tableView?.delegate = self
        tableView?.rowHeight = UITableView.automaticDimension
    }
}

extension NotesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchResultsController = fetchResultsController {
            return fetchResultsController.sections![section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                 for: indexPath)

        guard let note = fetchResultsController?.object(at: indexPath) as? NoteMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.textLabel?.text = note.title
        if let createAt = note.createAt {
            cell.detailTextLabel?.text = HelperDateFormatter.textFrom(date: createAt)
        }
        return cell
    }
}

extension NotesViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }

    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move, .update:
                break
            @unknown default: fatalError()
        }
    }

    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView?.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView?.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                tableView?.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                tableView?.moveRow(at: indexPath!, to: newIndexPath!)
            @unknown default:
                fatalError()
        }
    }

    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
