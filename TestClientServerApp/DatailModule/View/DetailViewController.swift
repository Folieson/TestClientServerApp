//
//  DetailViewController.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 15.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: -UIScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: -InfoViews
    @IBOutlet weak var companyInfoView: InfoView!
    @IBOutlet weak var introducedInfoView: InfoView!
    @IBOutlet weak var discountedInfoView: InfoView!
    @IBOutlet weak var descriptionInfoView: InfoView!
    // MARK: -UIImageView
    @IBOutlet weak var itemImageView: UIImageView!
    // MARK: -SimilarItems
    @IBOutlet weak var similarItemsView: UIView!
    @IBOutlet weak var similarItem1Button: UIButton!
    @IBOutlet weak var similarItem2Button: UIButton!
    @IBOutlet weak var similarItem3Button: UIButton!
    @IBOutlet weak var similarItem4Button: UIButton!
    @IBOutlet weak var similarItem5Button: UIButton!
    // MARK: -Constraints
    @IBOutlet weak var companyInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyInfoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var introducedInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var introducedInfoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var discountedInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountedInfoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionInfoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var similarItemsViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarItemsViewTopConstraint: NSLayoutConstraint!
    // MARK: -IBActions
    @IBAction func computer1ButtonTapped(_ sender: UIButton) {
        guard let itemId = self.presenter.similarItems?[0].id else { return }
        presenter.tapOnTheSimilarItem(itemId: itemId)
    }
    @IBAction func computer2ButtonTapped(_ sender: UIButton) {
        guard let itemId = self.presenter.similarItems?[1].id else { return }
        presenter.tapOnTheSimilarItem(itemId: itemId)
    }
    @IBAction func computer3ButtonTapped(_ sender: UIButton) {
        guard let itemId = self.presenter.similarItems?[2].id else { return }
        presenter.tapOnTheSimilarItem(itemId: itemId)
    }
    @IBAction func computer4ButtonTapped(_ sender: UIButton) {
        guard let itemId = self.presenter.similarItems?[3].id else { return }
        presenter.tapOnTheSimilarItem(itemId: itemId)
    }
    @IBAction func computer5ButtonTapped(_ sender: UIButton) {
        guard let itemId = self.presenter.similarItems?[4].id else { return }
        presenter.tapOnTheSimilarItem(itemId: itemId)
    }
    
    var presenter: DetailPresenterProtocol!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeBarButton()
        self.setInfoNames()
        hideView(view: similarItemsView, heightConstraint: similarItemsViewHeighConstraint, topConstraint: similarItemsViewTopConstraint)
    }
    
    private func setHomeBarButton() {
        let homeBarButton = UIBarButtonItem()
        homeBarButton.target = self
        homeBarButton.image = UIImage(systemName: "house")
        homeBarButton.action = #selector(onHomeBarButtonTapped(sender:))
        navigationItem.rightBarButtonItem = homeBarButton
    }
    
    private func setInfoNames() {
        self.companyInfoView.infoName.text = "Company"
        self.introducedInfoView.infoName.text = "Introduced"
        self.discountedInfoView.infoName.text = "Discounted"
        self.descriptionInfoView.infoName.text = "Desciption"
    }
    
    @objc func onHomeBarButtonTapped(sender: UIButton) {
        print("onHomeBarButtonTapped")
        self.presenter.tapOnTheReturnToTheMainScreen()
    }
}

extension DetailViewController: DetailViewProtocol {
    func setItemDetails() {
        guard let itemDetails = presenter.itemDetails else { return }
        self.navigationItem.title = itemDetails.name
        setCompanyInfo()
        setIntroducedInfo()
        setDiscountedInfo()
        setDescriptionInfo()
        setImageView()
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        if scrollView.visibleSize.height >= scrollView.contentSize.height {
            presenter.getSimilarItems()
        }
    }
    
    func setSimilarItems() {
        guard let similarItems = presenter.similarItems else { return }
        let similarItemsButtons = [similarItem1Button, similarItem2Button, similarItem3Button, similarItem4Button, similarItem5Button]
        if similarItemsButtons.count > similarItems.count {
            for index in similarItems.count-1...similarItemsButtons.count-1 {
                similarItemsButtons[index]?.removeFromSuperview()
            }
        }
        for index in 0..<similarItems.count {
            similarItemsButtons[index]?.setTitle(similarItems[index].name, for: .normal)
        }
        
        similarItemsView.isHidden = false
        similarItemsViewTopConstraint.constant = 32
        similarItemsViewHeighConstraint.priority = .defaultLow
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 8 {
            self.presenter.getSimilarItems()
        }
    }
}

// MARK: -for setItemDetails()
extension DetailViewController {
    private func setCompanyInfo() {
        setInfo(data: presenter.itemDetails?.company?.name, view: companyInfoView,
                heightConstraint: companyInfoViewHeightConstraint, topConstraint: companyInfoViewTopConstraint)
    }
    
    private func setIntroducedInfo() {
        setInfo(data: presenter.formatDateFromISO8601(date: presenter.itemDetails?.introduced), view: introducedInfoView,
                heightConstraint: introducedInfoViewHeightConstraint, topConstraint: introducedInfoViewTopConstraint)
    }
    
    private func setDiscountedInfo() {
        setInfo(data: presenter.formatDateFromISO8601(date: presenter.itemDetails?.discounted), view: discountedInfoView,
                heightConstraint: discountedInfoViewHeightConstraint, topConstraint: discountedInfoViewTopConstraint)
    }
    
    private func setDescriptionInfo() {
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.descriptionInfoTapped(_:)))
        self.descriptionInfoView.isUserInteractionEnabled = true
        self.descriptionInfoView.addGestureRecognizer(tapAction)
        setInfo(data: presenter.itemDetails?.description, view: descriptionInfoView,
                heightConstraint: descriptionInfoViewHeightConstraint, topConstraint: descriptionInfoViewTopConstraint)
    }
    
    private func setInfo(data: String?, view: InfoView, heightConstraint: NSLayoutConstraint, topConstraint: NSLayoutConstraint) {
        if let data = data {
            view.info.text = data
        } else {
            self.hideView(view: view, heightConstraint: heightConstraint, topConstraint: topConstraint)
        }
    }
    
    private func setImageView() {
        guard let imageData = presenter.itemImageData else {
            self.hideView(view: self.itemImageView, heightConstraint: imageViewHeightConstraint, topConstraint: imageViewTopConstraint)
            return
        }
        self.itemImageView.image = UIImage(data: imageData)
    }
    
    private func hideView(view: UIView, heightConstraint: NSLayoutConstraint, topConstraint: NSLayoutConstraint) {
        view.isHidden = true
        heightConstraint.constant = 0
        topConstraint.constant = 0
    }
    
    @objc private func descriptionInfoTapped(_ sender: UITapGestureRecognizer) {
        if self.descriptionInfoView.info.numberOfLines == 0 {
            self.descriptionInfoView.info.numberOfLines = 2
            self.descriptionInfoViewHeightConstraint.priority = .defaultHigh
        } else {
            self.descriptionInfoView.info.numberOfLines = 0
            self.descriptionInfoViewHeightConstraint.priority = .defaultLow
        }
    }
}
