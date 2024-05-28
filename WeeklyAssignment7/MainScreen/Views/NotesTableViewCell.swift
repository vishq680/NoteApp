//
//  NotesTableViewCell.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelNote: UILabel!
    var deleteButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelNote()
        setupDeleteButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDeleteButton() {
        deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.isUserInteractionEnabled = true // Enable user interaction
        contentView.addSubview(deleteButton)
    }
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelNote(){
        labelNote = UILabel()
        labelNote.font = UIFont.boldSystemFont(ofSize: 20)
        labelNote.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelNote)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelNote.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelNote.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelNote.heightAnchor.constraint(equalToConstant: 20),
            labelNote.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: wrapperCellView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            // Ensure the delete button is positioned correctly within the cell's bounds
            deleteButton.frame = CGRect(x: contentView.bounds.width - 50, y: 0, width: 50, height: contentView.bounds.height)
        }
    
    @objc func deleteButtonTapped() {
        guard let viewController = findViewController() as? ViewController else { return }
        guard let indexPath = viewController.mainScreen.tableViewNotes.indexPath(for: self) else { return }
        let note = viewController.notesList[indexPath.row]
        viewController.handleDeleteAction(for: note)
    }
    func findViewController() -> UIViewController? {
            var responder: UIResponder? = self
            while let nextResponder = responder?.next {
                if let viewController = nextResponder as? UIViewController {
                    return viewController
                }
                responder = nextResponder
            }
            return nil
        }
    
}

