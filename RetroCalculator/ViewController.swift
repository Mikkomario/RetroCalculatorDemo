//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Mikko Hilpinen on 1.9.2016.
//  Copyright © 2016 Mikko Hilpinen. All rights reserved.
//

import UIKit
import AVFoundation // Used in audio play

class ViewController: UIViewController
{
	@IBOutlet weak var counterLabel: UILabel!
	
	var buttonSound: AVAudioPlayer!
	
	enum Operation: String
	{
		case Divide = "/"
		case Multiply = "*"
		case Subtract = "-"
		case Add = "+"
		case Empty = "Empty"
	}
	
	var runningNumber = ""
	var currentOperation = Operation.Empty
	var currentNumber = 0.0
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		// Loading the sound
		let path = Bundle.main.path(forResource: "btn", ofType: "wav")
		let soundURL = URL(fileURLWithPath: path!) // Good to have a crash for missing resource (...)
		
		do
		{
			try buttonSound = AVAudioPlayer(contentsOf: soundURL)
			buttonSound.prepareToPlay()
		}
		catch let err as NSError
		{
			print(err.debugDescription)
			fatalError()
		}
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func numberPressed(sender: UIButton)
	{
		playSound()
		
		// Running number is appended
		runningNumber += "\(sender.tag)"
		
		// Counter label text is updated as well
		updateCounterLabel()
	}
	
	// TODO: WET WET
	@IBAction func addPressed(sender: AnyObject)
	{
		playSound()
		processOperation(Operation.Add)
	}
	
	@IBAction func subtractPressed(sender: AnyObject)
	{
		playSound()
		processOperation(Operation.Subtract)
	}
	
	@IBAction func multiplyPressed(sender: AnyObject)
	{
		playSound()
		processOperation(Operation.Multiply)
	}
	
	@IBAction func dividePressed(sender: AnyObject)
	{
		playSound()
		processOperation(Operation.Divide)
	}
	
	@IBAction func equalPressed(sender: AnyObject)
	{
		playSound()
		processOperation(Operation.Empty)
	}
	
	private func processOperation(_ operation: Operation)
	{
		// Case a: There is no leftmost number / no operation selected yet -> New number becomes the left number
		// Case b: There was left number -> old operation is performed on left number, new operation in place
		
		if !runningNumber.isEmpty
		{
			let rightNumber = Double(runningNumber)!
			
			switch (currentOperation)
			{
			case .Add: currentNumber += rightNumber
			case .Subtract: currentNumber -= rightNumber
			case .Divide: currentNumber /= rightNumber
			case .Multiply: currentNumber *= rightNumber
			case .Empty: currentNumber = rightNumber
			}
		}
		
		currentOperation = operation
		runningNumber = ""
		
		// Updates the label afterwards
		updateCounterLabel()
	}

	private func playSound()
	{
		if buttonSound.isPlaying
		{
			buttonSound.stop()
		}
		buttonSound.play()
	}
	
	private func updateCounterLabel()
	{
		if currentOperation == Operation.Empty
		{
			if runningNumber.isEmpty
			{
				counterLabel.text = "\(currentNumber)"
			}
			else
			{
				counterLabel.text = runningNumber
			}
		}
		else
		{
			counterLabel.text = "\(currentNumber) \(currentOperation.rawValue) \(runningNumber)"
		}
	}
}

