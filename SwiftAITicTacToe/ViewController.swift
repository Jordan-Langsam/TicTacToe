//
//  ViewController.swift
//  SwiftAITicTacToe
//
//  Created by Jordan Langsam on 12/19/18.
//  Copyright © 2018 Jordan Langsam. All rights reserved.
//

import UIKit

enum winState: String {
	case none, win, tie
}

class ViewController: UIViewController {
	
	//properties
	var board: Array = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
	
	let newGameButton: UIButton = UIButton()
	
	var playerTurn: Bool = true
	
	var gameInProgress: Bool = false
	
	var moveCount: Int = 0
	
	var currentWinState: winState = winState.none
	
	// MARK: viewController lifeCycle methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for row in (0...2) {
			for column in (0...2){
				initButton(row: row, column: column)
			}
		}
		
		newGameButton.backgroundColor = UIColor.black
		newGameButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
		newGameButton.titleLabel?.numberOfLines = 0
		newGameButtonUpdate()
		self.view.addSubview(newGameButton)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		self.drawButtons()
		
		newGameButton.frame = newGameButtonFrame()
		
	}
	
	
	// MARK: tictactoe buttons
	func drawButtons() {
		
		let bounds = UIScreen.main.bounds
		let buttonHeight = Int(bounds.height / 3)
		let width = Int(bounds.width / 3)
		
		for view in self.view.subviews {
			if let tttButton = view as? TTTButton {
				tttButton.frame = CGRect(x: tttButton.column * width, y: tttButton.row * buttonHeight, width: width, height: buttonHeight)
			}
		}
	}
	
	func initButton(row: Int, column: Int) {
			let button: TTTButton = TTTButton.init()
			button.addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
			button.backgroundColor = UIColor.green
			button.layer.borderWidth = 3
			button.layer.borderColor = UIColor.red.cgColor
			button.row = row
			button.column = column
			self.view.addSubview(button)
		}
	
	//newGameButton
	func newGameButtonFrame () -> CGRect {
		let originX = (UIScreen.main.bounds.width / 2) - 100
		let originY = (UIScreen.main.bounds.height / 2) - 20
		
		return CGRect(x: originX, y: originY, width: 200, height: 80)
	}
	
	@objc func buttonWasPressed (button: TTTButton){
		if (button.hasBeenSelected == false && gameInProgress == true && playerTurn == true){
			let titleToUse = (playerTurn == true ? "X" : "O")
			button.setTitle(titleToUse, for: .normal)
			button.hasBeenSelected = true
			board[button.row][button.column] = (playerTurn ? 1 : 2)
			self.processTurn()
		}
	}
	
	func newGameButtonUpdate(){
		func newGameButtonVisibilityUpdate(){
			switch currentWinState {
			case .win, .tie:
				self.newGameButton.isHidden = false
			default:
				self.newGameButton.isHidden = self.gameInProgress
			}
		}
		
		func newGameButtonTitleUpdate(){
			
			var buttonTitleToUse: String = ""
			
			switch currentWinState {
			case .win:
				let playerTitle = (self.playerTurn ? "X" : "O")
				buttonTitleToUse = "Player " + playerTitle + " Wins"
			case .tie:
				buttonTitleToUse = "Tie. Play Again?"
			case .none:
				buttonTitleToUse = "New Game?"
			}
			
			self.newGameButton.setTitle(buttonTitleToUse, for: .normal)
		}
		
		newGameButtonTitleUpdate()
		newGameButtonVisibilityUpdate()
	}
	
	//MARK: process turn
	func processTurn() {
		moveCount += 1
		
		currentWinState = self.updateCurrentWinState()
		
		if (currentWinState == winState.win || currentWinState == winState.tie){
			gameInProgress = false
		}
		
		self.newGameButtonUpdate()
		
		playerTurn = !playerTurn
		
		if (playerTurn == false && gameInProgress == true){
			self.processComputerTurn()
		}
	}
	
	func processComputerTurn () {
		
		var availableButtons: Array = [TTTButton]()
		
		//find available buttons
		for view in self.view.subviews {
			if let tttButton = view as? TTTButton {
				if (tttButton.hasBeenSelected == false){
					availableButtons.append(tttButton)
				}
			}
		}
		
		//select a random available button
		let randomButtonIndex = Int.random(in: 0..<availableButtons.count)
		let selectedButton = availableButtons[randomButtonIndex]
		selectedButton.hasBeenSelected = true
		selectedButton.setTitle("O", for: .normal)
		board[selectedButton.row][selectedButton.column] = 2
		
		self.processTurn()
	}
	
	//MARK: win state
	func updateCurrentWinState () -> winState {
		
		//if any checks come back as win immediately return as a win, otherwise continue
		
		switch self.checkRows() {
		case .win:
			return winState.win
		default:
			break
		}
		
		switch self.checkColumns() {
		case .win:
			return winState.win
		default:
			break
		}
		
		switch self.checkDiagonals() {
		case .win:
			return winState.win
		case .none:
			//if last check comes does not produce a win and we've reached the max amount of possible moves, the game is a tie
			if (moveCount == 9){
				return winState.tie
			} else {
				return winState.none
			}
		case .tie:
			fatalError("Should never be tied up at this point")
		}
	}
	
	//MARK: win checks
	func checkRows() -> winState {
		
		for row in stride(from: 0, to: 3, by: 1){
			
			var player1Counter = 0
			var player2Counter = 0
			
			for column in stride(from: 0, to: 3, by: 1){
				if (board[row][column] == 1){
					player1Counter += 1
				} else if (board[row][column] == 2){
					player2Counter += 1
				}
				
				if (player1Counter == 3 || player2Counter == 3){
					return winState.win
				}
			}
		}
		
		return winState.none
	}
	
	func checkColumns() -> winState {
		for row in stride(from: 0, to: 3, by: 1){
			
			var player1Counter = 0
			var player2Counter = 0
			
			for column in stride(from: 0, to: 3, by: 1){
				if (board[column][row] == 1){
					player1Counter += 1
				} else if (board[column][row] == 2){
					player2Counter += 1
				}
				
				if (player1Counter == 3 || player2Counter == 3){
					return winState.win
				}
			}
		}
		
		return winState.none
	}
	
	func checkDiagonals() -> winState {
		var player1Counter = 0
		var player2Counter = 0
		
		//top left to bottom right
		for row in (0...2){
			if (board[row][row] == 1){
				player1Counter += 1
			} else if (board[row][row] == 2){
				player2Counter += 1
			}
			
			if (player1Counter == 3 || player2Counter == 3){
				return winState.win
			}
		}
		
		player1Counter = 0
		player2Counter = 0
		
		//bottom left to top right
		for row in (0...2).reversed(){
			if (board[row][2 - row] == 1){
				player1Counter += 1
			}  else if (board[row][2 - row] == 2){
				player2Counter += 1
			}
		}
		
		if (player1Counter == 3 || player2Counter == 3){
			return winState.win
		}
		
		return winState.none
	}
	
	//MARK: reset game
	@objc func resetGame(){
		board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
		playerTurn = true
		moveCount = 0
		currentWinState = winState.none
		gameInProgress = true
		resetTicTacToeButtons()
		newGameButtonUpdate()
	}
	
	func resetTicTacToeButtons() {
		for view in self.view.subviews {
			if let tttButton = view as? TTTButton {
				tttButton.resetButton()
			}
		}
	}
}


