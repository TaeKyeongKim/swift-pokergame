//
//  PokerGame.swift
//  포커게임
//
//  Created by Kai Kim on 2022/02/25.
//

import Foundation
struct PokerGame {

    //게임이 생성되면 한명의 딜러는 자동 으로 카드 덱과 생성된다.
    private let dealer = Dealer(gameDeck: Deck())
    //딜러를 포함한 플레이어 리스트
    private var totalPlayerList = [Person]()
    
    //플레이어수 (딜러 미포함)
    var numberOfPlayers : NumberOfPlayer
    var gameMode : GameMode
    
    //게임 플레이 횟수
    private var numberOfSet = 1
    
    init(numberOfPlayers : NumberOfPlayer , mode : GameMode){
        self.numberOfPlayers = numberOfPlayers
        self.gameMode = mode
    }
    
    mutating func run() {
        setUp()
        while true {
            showGameInfo()
            playOneSet()
            showAllCards()
            resetPlayerCards()
        }
    }

    //나중 스텝에 게임 관련 세팅작업이 필요할경우를 위해 setUp 번들 을 만들어줌.
    private mutating func setUp() {
        setPlayers()
    }
    
    //세팅된 딜러 와 플레이어 의 수만큼 playerList 에 넣어준다.
    private mutating func setPlayers() {
        let roster = Roster.allCases.map{$0.rawValue}
        for i in 0..<numberOfPlayers.rawValue {
            totalPlayerList.append(Player(name: roster[i]))
        }
        totalPlayerList.append(dealer)
    }
    
    //딜러가 카드를 gameMode 에 맞게 플레이어들에게 나누어준다.
    private mutating func playOneSet() {
        do{
            try dealer.dealCard(to: totalPlayerList, on: gameMode)
            self.numberOfSet += 1
        } catch {
            switch error {
            case Errors.InsufficientCard :
                print(Errors.InsufficientCard.rawValue)
                exit(1)
            default :
                print("unknown error occurred")
            }
        }
    }
    
    private func showGameInfo() {
        print("현재 게임 모드: \(self.gameMode.rawValue)카드 \n플레이어 수 : \(self.numberOfPlayers.rawValue)명 \n게임 실행 횟수 : \(self.numberOfSet)회")
    }
    
    private func showAllCards() {
        for player in totalPlayerList {
            print(player)
        }
    }
    
    private func resetPlayerCards() {
        for player in totalPlayerList {
            player.resetCards()
        }
    }

    enum Roster : String,CaseIterable {
        case Kai
        case Tim
        case Luan
        case Hana
        case Dealer
    }
    enum NumberOfPlayer : Int{
        case One = 1
        case Two
        case Three
        case Four
    }
    enum GameMode :Int {
        case SevenStud = 7
        case FiveStud = 5
    }
    enum Errors : String, Error {
        case InsufficientCard = "-카드가 부족해 더이상 게임 진행 불가능 합니다-"
    
    }

    
}

