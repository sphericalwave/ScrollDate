//
//  ContentView.swift
//  ScrollDate
//
//  Created by Aaron Anthony on 2020-08-19.
//  Copyright © 2020 SphericalWaveSoftware. All rights reserved.
//

import SwiftUI

struct TestUI: View
{
    @State var date: Date = Date() {
        didSet {
            print("Tabs date didSet")
        }
    }
    
    var body: some View {
        NavigationView {
            SUIScrollHistory(date: $date)
                .edgesIgnoringSafeArea(.top)
                .navigationBarTitle("History")
                .navigationBarItems(trailing: DateField(date: $date))
        }
    }
}

import UIKit
import SwiftUI
import CoreData

final class SUIScrollHistory: UIViewControllerRepresentable
{
    @Binding var date: Date {
        willSet {
            print("SUI scroll history willSet:")
            print("scroll to appropriate pg")
            print("NOT CALLED")
        }
    }
    
    init(date: Binding<Date>) {
        self._date = date
    }
    
    func makeUIViewController(context: Context) -> ScrollHistory {
        return ScrollHistory(date: _date)
    }
    
    func updateUIViewController(_ uiViewController: ScrollHistory, context: Context) {
        //test
    }
}

import UIKit
import SwiftUI
import CoreData

class ScrollHistory: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    @Binding var date: Date {
        willSet {
            scrollTo(newDate: newValue)
            print("scroll history willSet")
            print("scroll to appropriate pg")
            print("NOT CALLED")
        }
    }
    
    init(date: Binding<Date>) {
        self._date = date
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.setViewControllers( [ UIHostingController(rootView: Rectangle().overlay(Color.blue)) ], direction: .forward, animated: true, completion: nil)
        self.delegate = self
        self.dataSource = self
        self.view.isUserInteractionEnabled = true
        self.title = "Mon, Aug 17"
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func scrollTo(newDate: Date) {
        if newDate > date {  //Slide the PageVC left if date > currentDay
            //let nextDay = date.nextDay()
            
            let edibleJournalTVC = UIHostingController(rootView: Text("inject date"))
            self.setViewControllers([edibleJournalTVC], direction: .forward, animated: true, completion: nil)
        }
        if newDate < date {  //Slide the PageVC right if date < currentDay
            //let previousDay = date.previousDay()
            let edibleJournalTVC = UIHostingController(rootView: Text("inject date")) //self.fdPg(date: date) //FIXME: = FoodPage(date: previousDay)
            
            self.setViewControllers([edibleJournalTVC], direction: .reverse, animated: true, completion: nil)
        }
        self.date = newDate //TODO: Does this loop infinitely?
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //update DateField
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let foodPage = UIHostingController(rootView: Text("inject date")) //FIXME: Binding<Date>(previousDay)))
        return foodPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let foodPage = UIHostingController(rootView: Text("inject date")) //FIXME nextDay))
        return foodPage
    }
}

import SwiftUI
import UIKit

struct DateField: UIViewRepresentable
{
    @Binding var date: Date {
        willSet {
            print("DateField willSet")
            print("NOT CALLED")
        }
        didSet {
            print("DateField didSet")
            print("NOT CALLED")
        }
    }
    private let format: DateFormatter
    
    
    init(date: Binding<Date>, format: DateFormatter = YMDFormat()) {
        self._date = date
        self.format = format
    }
    
    func makeUIView(context: UIViewRepresentableContext<DateField>) -> UITextField {
        let tf = DateTextField(date: $date)  //FIXME: not injected bcs it's a wrapper
        print("makeUIView")
        return tf
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<DateField>) {
        print("updateUIView")
        uiView.text = format.string(from: date)
    }
}


import SwiftUI
import UIKit

class DateTextField: UITextField
{
    @Binding var date: Date {
        willSet {
            print("DateTextField Date")
            print("Is Called")
        }
    }
    private lazy var pickDate: UIDatePicker = { return UIDatePicker() }()
    
    init(date: Binding<Date>) {
        self._date = date
        super.init(frame: .zero)
        self.pickDate.date = date.wrappedValue
        self.pickDate.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.inputView = pickDate
        self.textColor = .black
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
    }
}


import Foundation

class YMDFormat: DateFormatter
{
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd"
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


