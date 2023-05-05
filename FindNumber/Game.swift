//
//  Game.swift
//  FindNumber
//
//  Created by Alex on 02.05.2023.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game{
    struct Item{
        var title: String
        var isFound = false
        var isError = false
    }
    
    
    private let data = Array(1...99)
    var items: [Item] = []
    private var countItem: Int
    
    var nextItem: Item?
    
    var status: StatusGame = .start {
        didSet{
            if status != .start{
                stopGame()
            }
        }
    }
    
    private var timeForGame: Int
    private var secondsGame: Int{
        didSet{
            if secondsGame == 0 {
                status = .lose
            }
            
            updateTimer(status, secondsGame)
        }
    }
    
    private var timer: Timer?
    private var updateTimer: (StatusGame, Int)-> Void
    
    init(countItem: Int, time: Int, updateTimer:@escaping (_ status: StatusGame,_ seconds: Int) -> Void) {
        self.countItem = countItem
        self.secondsGame = time
        self.timeForGame = time
        self.updateTimer = updateTimer
        setUpGame()
    }
    
    private func setUpGame(){
        var digits = data.shuffled()
        items.removeAll()
        
        while items.count < countItem {
            let item = Item (title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.shuffled().first
        
        updateTimer(status, secondsGame)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.secondsGame -= 1
        })
    }
    
    func newGame(){
        status = .start
        self.secondsGame = self.timeForGame
        setUpGame()
        
    }
    
    func check (index: Int) {
        guard status == .start else {return}
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })
        } else {
            items[index].isError = true
        }
        
        if nextItem == nil {
            status = .win
        }
    }
    
    private func stopGame(){
        timer?.invalidate()
    }
}

extension Int{
    func secondsToString()-> String{
        let min = self / 60
        let sec = self % 60
        
        return String(format: "%d:%02d", min, sec)
    }
}
