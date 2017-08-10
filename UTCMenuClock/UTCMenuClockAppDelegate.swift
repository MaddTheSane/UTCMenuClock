//
//  UTCMenuClockAppDelegate.swift
//  UTCMenuClock
//
//  Created by C.W. Betts on 8/10/17.
//

import Cocoa


var ourStatus: NSStatusItem?
var dateMenuItem: NSMenuItem?
var showTimeZoneItem: NSMenuItem?
var show24HrTimeItem: NSMenuItem?

var showDatePreferenceKey: String {
	return "ShowDate"
}
var showSecondsPreferenceKey: String {
	return "ShowSeconds"
}
var showJulianDatePreferenceKey: String {
	return "ShowJulianDate"
}
var showTimeZonePreferenceKey: String {
	return "ShowTimeZone"
}
var show24HourPreferenceKey: String {
	return "24HRTime"
}

class UTCMenuClockAppDelegateSwift: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!
	@IBOutlet var mainMenu: NSMenu!
	var statusItem: NSStatusItem?
	
	@objc func toggleLaunch(_ sender: NSMenuItem?) {
		guard let sender = sender else {
			return
		}
		let state = sender.state
		let launchController = LaunchAtLoginController()
		
		if state == NSOffState {
			sender.state = NSOnState
			launchController.launchAtLogin = true
		} else {
			sender.state = NSOffState
			launchController.launchAtLogin = false
		}
	}
	
	@objc func togglePreference(_ sender: NSMenuItem?) {
        guard let sender = sender, let preference = sender.representedObject as? String else {
            return
        }
        let state = sender.state
        
        if state == NSOffState {
            sender.state = NSOnState
            UserDefaults.standard.set(true, forKey: preference)
        } else {
            sender.state = NSOffState
            UserDefaults.standard.set(false, forKey: preference)
        }
	}

	@objc func openGithubURL(_ sender: Any?) {
		NSWorkspace.shared().open(URL(string: "http://github.com/netik/UTCMenuClock")!)
	}
	
	func doDateUpdate() {
		let date = Date()
		let UTCdf = DateFormatter()
		let UTCdateDF = DateFormatter()
		let UTCdateShortDF = DateFormatter()
		let UTCdaynum = DateFormatter()
		
		let UTCtz = TimeZone(abbreviation: "UTC")!
		
		UTCdf.timeZone = UTCtz
		UTCdateDF.timeZone = UTCtz
		UTCdateShortDF.timeZone = UTCtz
		UTCdaynum.timeZone = UTCtz
		
		let defaults = UserDefaults.standard
		let showDate = defaults.bool(forKey: showDatePreferenceKey)
		let showSeconds = defaults.bool(forKey: showSecondsPreferenceKey)
		let showJulian = defaults.bool(forKey: showJulianDatePreferenceKey)
		let showTimeZone = defaults.bool(forKey: showTimeZonePreferenceKey)
		let show24HrTime = defaults.bool(forKey: show24HourPreferenceKey)

		if showSeconds {
			if show24HrTime {
				UTCdf.dateFormat = "HH:mm:ss"
			} else {
				UTCdf.dateFormat = "hh:mm:ss a"
			}
		} else {
			if show24HrTime {
				UTCdf.dateFormat = "HH:mm"
				
			} else {
				UTCdf.dateFormat = "hh:mm a"
			}
		}
		UTCdateDF.dateStyle = .full
		UTCdateShortDF.dateStyle = .short
		UTCdaynum.dateFormat = "D/"
		
		let UTCtimepart = UTCdf.string(from: date)
		let UTCdatepart = UTCdateDF.string(from: date)
		let UTCdateShort = UTCdateShortDF.string(from: date)
		let UTCJulianDay: String
		let UTCTzString: String
		
		if showJulian {
			UTCJulianDay = UTCdaynum.string(from: date)
		} else {
			UTCJulianDay = ""
		}
		
		if showTimeZone {
			UTCTzString = " UTC"
		} else {
			UTCTzString = ""
		}
		
		if showDate {
			ourStatus?.title = "\(UTCdateShort) \(UTCJulianDay)\(UTCtimepart)\(UTCTzString)"
		} else {
			ourStatus?.title = "\(UTCJulianDay)\(UTCtimepart)\(UTCTzString)"
		}
		
		dateMenuItem?.title = UTCdatepart
	}
	
	/// this is the main work loop, fired on 1s intervals.
	@objc private func fireTimer(_ theTimer: Timer) {
		doDateUpdate()
	}
	
    override init() {
        super.init()
        let standardUserDefaults = UserDefaults.standard
        let appDefaults: [String: Any] = [showTimeZonePreferenceKey: true,
                                          show24HourPreferenceKey: true,
                                          showDatePreferenceKey: false,
                                          showJulianDatePreferenceKey: false,
                                          showSecondsPreferenceKey: false]
        standardUserDefaults.register(defaults: appDefaults)
    }
    
	func applicationDidFinishLaunching(_ notification: Notification) {
		doDateUpdate()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
        mainMenu = NSMenu()

		//Create Image for menu item
		let bar = NSStatusBar.system()
		let theItem = bar.statusItem(withLength: NSVariableStatusItemLength)
		
		// retain a reference to the item so we don't have to find it again
		ourStatus = theItem;
		
		//Set Image
		//[theItem setImage:(NSImage *)menuicon];
		theItem.title = ""
		
		//Make it turn blue when you click on it
		theItem.highlightMode = true
		theItem.isEnabled = true
		
		// build the menu
		let mainItem = NSMenuItem()
		dateMenuItem = mainItem;
		
		let cp1Item = NSMenuItem();
		let cp2Item = NSMenuItem();
		let cp3Item = NSMenuItem();
		let quitItem = NSMenuItem();
		let launchItem = NSMenuItem();
		let showDateItem = NSMenuItem();
		let show24Item = NSMenuItem();
		let showSecondsItem = NSMenuItem();
		let showJulianItem = NSMenuItem();
		//   NSMenuItem *changeFontItem = [[[NSMenuItem alloc] init] autorelease];
		
		showTimeZoneItem = NSMenuItem()
		
		mainItem.title = ""
		
		cp1Item.title = "UTC Menu Clock v1.2.3"
		cp2Item.title = "jna@retina.net"
		cp3Item.title = "http://github.com/netik/UTCMenuClock"
		
		cp3Item.isEnabled = true
		cp3Item.action = #selector(UTCMenuClockAppDelegateSwift.openGithubURL(_:))
		
		launchItem.title = "Open At Login"
		launchItem.isEnabled = true
		launchItem.action = #selector(UTCMenuClockAppDelegateSwift.toggleLaunch(_:))
		
		show24Item.title = "24 HR Time"
		show24Item.isEnabled = true
		show24Item.action = #selector(UTCMenuClockAppDelegateSwift.togglePreference(_:))
		show24Item.representedObject = show24HourPreferenceKey
		
		showDateItem.title = "Show Date"
		showDateItem.isEnabled = true
		showDateItem.action = #selector(UTCMenuClockAppDelegateSwift.togglePreference(_:))
		showDateItem.representedObject = showDatePreferenceKey
		
		showSecondsItem.title = "Show Seconds"
		showSecondsItem.isEnabled = true
		showSecondsItem.action = #selector(UTCMenuClockAppDelegateSwift.togglePreference(_:))
		showSecondsItem.representedObject = showSecondsPreferenceKey
		
		showJulianItem.title = "Show Julian Date"
		showJulianItem.isEnabled = true
		showJulianItem.action = #selector(UTCMenuClockAppDelegateSwift.togglePreference(_:))
		showJulianItem.representedObject = showJulianDatePreferenceKey
		
		showTimeZoneItem?.title = "Show Time Zone"
		showTimeZoneItem?.isEnabled = true
		showTimeZoneItem?.action = #selector(UTCMenuClockAppDelegateSwift.togglePreference(_:))
		showTimeZoneItem?.tag = 5
		
		quitItem.title = "Quit"
		quitItem.isEnabled = true
		quitItem.target = NSApp
		quitItem.action = #selector(NSApplication.terminate(_:))
		
		
		mainMenu.addItem(mainItem)
		mainMenu.addItem(.separator())
		mainMenu.addItem(cp1Item)
		mainMenu.addItem(cp2Item)
		mainMenu.addItem(.separator())
		mainMenu.addItem(cp3Item)
		mainMenu.addItem(.separator())
		
		let defaults = UserDefaults.standard
		
		// showDateItem
		let showDate = defaults.bool(forKey: showDatePreferenceKey)
		let showSeconds = defaults.bool(forKey: showSecondsPreferenceKey)
		let showJulian = defaults.bool(forKey: showJulianDatePreferenceKey)
		let showTimeZone = defaults.bool(forKey: showTimeZonePreferenceKey)
		let show24HrTime = defaults.bool(forKey: show24HourPreferenceKey)
		
		// TODO: DRY this up a bit.
		if show24HrTime {
			show24Item.state = NSOnState
		} else {
			show24Item.state = NSOffState
		}
		
		if showDate {
			showDateItem.state = NSOnState
		} else {
			showDateItem.state = NSOffState
		}
		
		if showSeconds {
			showSecondsItem.state = NSOnState
		} else {
			showSecondsItem.state = NSOffState
		}
		
		if showJulian {
			showJulianItem.state = NSOnState
		} else {
			showJulianItem.state = NSOffState
		}
		
		if showTimeZone {
			showTimeZoneItem?.state = NSOnState
		} else {
			showTimeZoneItem?.state = NSOffState
		}
		
		// latsly, deal with Launch at Login
		let launch: Bool = LaunchAtLoginController().launchAtLogin
		
		if launch {
			launchItem.state = NSOnState
		} else {
			launchItem.state = NSOffState
		}
		
		mainMenu.addItem(launchItem)
		mainMenu.addItem(show24Item)
		mainMenu.addItem(showDateItem)
		mainMenu.addItem(showSecondsItem)
		mainMenu.addItem(showJulianItem)
		mainMenu.addItem(showTimeZoneItem!)
		//  [mainMenu addItem:changeFontItem];
		// "---"
		mainMenu.addItem(.separator())
		mainMenu.addItem(quitItem)
		
		theItem.menu = mainMenu
		
		// Update the date immediately after setup so that there is no timer lag
		doDateUpdate()
		
		Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UTCMenuClockAppDelegateSwift.fireTimer(_:)), userInfo: nil, repeats: true)
		/*
		NSNumber *myInt = @1;
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fireTimer:) userInfo:myInt repeats:YES];
		*/
	}
}
