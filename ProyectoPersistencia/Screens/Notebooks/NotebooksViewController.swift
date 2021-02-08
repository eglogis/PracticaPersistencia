//
//  NotebooksViewController.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 7/2/21.
//

import UIKit
import CoreData

class NotebooksViewController: UIViewController {

    @IBOutlet var tableView: UITableView?

    var dataController: DataController?
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    override func viewDidLoad() {
        title = "Notebooks"
        initializeFetchResultsController()
        tableView?.dataSource = self
        tableView?.rowHeight = UITableView.automaticDimension
    }

    private func initializeFetchResultsController() {
        guard let dataController = dataController else { return }
        let viewContext = dataController.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
        let notebookTitleSortDescriptor = NSSortDescriptor(key: "title",
                                                           ascending: true)
        request.sortDescriptors = [notebookTitleSortDescriptor]

        self.fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        self.fetchResultsController?.delegate = self

        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            print("Error while trying to perform a notebook fetch.")
        }
    }
}

extension NotebooksViewController: UITableViewDataSource {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "notebookCell",
                                                 for: indexPath)

        guard let notebook = fetchResultsController?.object(at: indexPath) as? NotebookMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.textLabel?.text = notebook.title
        if let createAt = notebook.createAt {
            cell.detailTextLabel?.text = HelperDateFormatter.textFrom(date: createAt)
        }
        return cell
    }
}

extension NotebooksViewController: NSFetchedResultsControllerDelegate {

    // will change
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
