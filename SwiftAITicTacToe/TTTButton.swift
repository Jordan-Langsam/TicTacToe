//
//  TTTButton.swift
//  SwiftAITicTacToe
//
//  Created by Jordan Langsam on 12/19/18.
//  Copyright © 2018 Jordan Langsam. All rights reserved.
//

import UIKit

class TTTButton: UIButton {
	
	var row: Int = Int()
	var column: Int = Int()
	var hasBeenSelected: Bool = false
	
	required init(value: Int = 0) {
		// set myValue before super.init is called
		super.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func resetButton () {
		self.setTitle("", for: .normal)
		self.hasBeenSelected = false
	}
}
