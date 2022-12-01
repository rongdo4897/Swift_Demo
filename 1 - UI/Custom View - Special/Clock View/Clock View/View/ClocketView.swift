//
//  ClockView.swift
//  Clock View
//
//  Created by V002861 on 11/24/22.
//

import UIKit

class ClocketView: UIView {
    public struct LocalTime {
        var hour: Int = 10
        var minute: Int = 10
        var second: Int = 25
    }
    
    weak open var clocketDelegate: ClocketDelegate?
    
    @IBInspectable open var displayRealTime: Bool = false
    @IBInspectable open var reverseTime: Bool = false
    @IBInspectable open var manualTimeSetAllowed: Bool = true
    @IBInspectable open var countDownTimer: Bool = false
    @IBInspectable open var handShadow: Bool = true
    
    open var localTime = LocalTime()
    open var timer = Timer()
    open var refreshInterval: TimeInterval = 1.0
    
    // Chuyển về góc tọa độ
    private let translateToRadian = Double.pi / 180
    
    // Vẽ kim giờ
    private var hourHandColor: UIColor = .yellow
    private var hourHandLength: CGFloat = 0.6 // Chiếm 60% của bán kính
    private var hourHandWidth: CGFloat = 0.1
    private var hourHandTailLength: CGFloat = 0.2
    
    // Vẽ kim phút
    private var minuteHandColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    private var minuteHandLength: CGFloat = 0.8
    private var minuteHandWidth: CGFloat = 0.07
    private var minuteHandTailLength: CGFloat = 0.2
    
    // Vẽ kim giây
    private var secondHandColor: UIColor = UIColor(red: 232/255, green: 60/255, blue: 60/255, alpha: 1.0)
    private var secondHandLength: CGFloat = 0.9
    private var secondHandWidth: CGFloat = 0.03
    private var secondHandTailLength: CGFloat = 0.2
    
    // Vẽ chấm tròn trung tâm
    private var circleCenterDiameter: CGFloat = 4.0
    private var circleCenterColor: UIColor = UIColor(red: 232/255, green: 60/255, blue: 60/255, alpha: 1.0)
    
    // Các hệ số tính toán cho center circle
    private var lineWidthFactor: CGFloat = 100
    private var diameter: CGFloat { return min(bounds.width, bounds.height) }
    private var lineWidth: CGFloat { return diameter / lineWidthFactor }
    
    private var clockFace = UIImageView()
    private var hourHand = ClockViewHand()
    private var minuteHand = ClockViewHand()
    private var secondHand = ClockViewHand()
    private var centerCircle = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        initComponents()
    }
}

//MARK: - Init
extension ClocketView {
    private func initComponents() {
        setupHands()
        setupClockFace()
        setupGestures()
    }
    
    private func setupHands() {
        let hourHandParameters = ClockViewHandParameters(frame: frame,
                                                     length: hourHandLength,
                                                     width: hourHandWidth,
                                                     tailLength: hourHandTailLength,
                                                     color: hourHandColor,
                                                     shadowIsOn: handShadow,
                                                     initValue: Double(localTime.hour * 30))
        hourHand = ClockViewHand(parameters: hourHandParameters)
        
        let minuteHandParameters = ClockViewHandParameters(frame: frame,
                                                       length: minuteHandLength,
                                                       width: minuteHandWidth,
                                                       tailLength: minuteHandTailLength,
                                                       color: minuteHandColor,
                                                       shadowIsOn: handShadow,
                                                       initValue: Double(localTime.minute * 6))
        minuteHand = ClockViewHand(parameters: minuteHandParameters)
        
        let secondHandParameters = ClockViewHandParameters(frame: frame,
                                                       length: secondHandLength,
                                                       width: secondHandWidth,
                                                       tailLength: secondHandTailLength,
                                                       color: secondHandColor,
                                                       shadowIsOn: handShadow,
                                                       initValue: Double(localTime.second * 6))
        secondHand = ClockViewHand(parameters: secondHandParameters)
        
        centerCircle = ClockViewCenterCircle(radius: diameter/2,
                                            circleDiameter: circleCenterDiameter,
                                            lineWidth: lineWidth,
                                            color: secondHandColor)
    }
    
    
    private func setupClockFace() {
        clockFace = ClockViewFace(frame: frame)
        //    clockFace = ClockFace(frame: self.frame, staticClockFaceImage: UIImage(named: "clockface"))
        
        addSubview(clockFace)
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
        addSubview(centerCircle)
        
        clockFace.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        clockFace.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        clockFace.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        clockFace.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        
        centerCircle.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor).isActive = true
        centerCircle.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor).isActive = true
        centerCircle.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        centerCircle.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        
        hourHand.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor).isActive = true
        hourHand.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor).isActive = true
        hourHand.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        hourHand.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        
        minuteHand.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor).isActive = true
        minuteHand.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor).isActive = true
        minuteHand.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        minuteHand.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        
        secondHand.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor).isActive = true
        secondHand.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor).isActive = true
        secondHand.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        secondHand.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    
    private func setupGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(recognizer:)))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(handlePan(recognizer:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    public func setLocalTime(hour: Int, minute: Int, second: Int) {
        localTime.hour = hour % 12
        localTime.minute = minute % 60
        localTime.second = second % 60
        updateHands()
    }
    
    
    public func startClock() {
        if timer.isValid {
            timer.invalidate()
            return
        }
        if displayRealTime {
            refreshInterval = 1.0
        }
        if countDownTimer {
            reverseTime = true
        }
        timer = Timer.scheduledTimer(timeInterval: refreshInterval, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    
    public func stopClock() {
        timer.invalidate()
    }
    
    @objc private func tick() {
        if displayRealTime {
            let localTimeComponents: Set<Calendar.Component> = [.hour, .minute, .second]
            let realTimeComponents = Calendar.current.dateComponents(localTimeComponents, from: Date())
            localTime.second = realTimeComponents.second ?? 0
            localTime.minute = realTimeComponents.minute ?? 10
            localTime.hour = realTimeComponents.hour ?? 10
        } else {
            localTime.second += reverseTime ? -1 : 1
            if localTime.second == 60 {
                localTime.second = 0
                localTime.minute = (localTime.minute + 1) % 60
                if localTime.minute == 0 {
                    localTime.hour = (localTime.hour + 1) % 12
                }
            } else if localTime.second == -1 {
                localTime.second = 59
                localTime.minute -= 1
                if localTime.minute == -1 {
                    localTime.minute = 59
                    localTime.hour = (localTime.hour - 1) % 12
                }
            }
            if countDownTimer {
                if localTime.hour <= 0 && localTime.minute <= 0 && localTime.second <= 0 {
                    setLocalTime(hour: 0, minute: 0, second: 0)
                    stopClock()
                    countDownTimerAlert()
                    return
                }
            }
        }
        updateHands()
    }
    
    
    private func updateHands() {
        secondHand.updateHandAngle(angle: CGFloat(Double(localTime.second * 6) * translateToRadian))
        minuteHand.updateHandAngle(angle: CGFloat(Double(localTime.minute * 6) * translateToRadian))
        let hourDegree = Double(localTime.hour) * 30.0 + Double(localTime.minute) * 0.5
        hourHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian))
    }
    
    private func countDownTimerAlert() {
        //implement any alert actions here for the countDown timer expiring
        clocketDelegate?.countDownExpired()
    }
    
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        if !manualTimeSetAllowed {return}
        switch recognizer.state {
        case .changed:
            handleTap(recognizer: recognizer)
        case .ended:
            clocketDelegate?.timeIsSetManually()
        default:
            break
        }
    }
    
    @objc private func handleTap(recognizer: UIPanGestureRecognizer){
        if !manualTimeSetAllowed {return}
        let tapLocation = recognizer.location(in: self)
        guard let view = recognizer.view else { return }
        let viewSize = min(view.bounds.size.width, view.bounds.size.height)
        let center = CGPoint(x: viewSize/2.0, y: viewSize/2.0)
        let distanceToCenter = sqrt(pow((tapLocation.x - center.x), 2) + pow((tapLocation.y - center.y), 2))
        
        //tap within the circle smaller than hand tail to set the second hand to zero
        if distanceToCenter < min(10.0, viewSize/10.0) {
            if localTime.second != 0 {
                secondHand.updateHandAngle(angle: CGFloat(0), duration: 0.5)
            } else {
                secondHand.updateHandAngle(angle: CGFloat(2*Double.pi/3), duration: 1.0)
                secondHand.updateHandAngle(angle: CGFloat(4*Double.pi/3), duration: 1.0)
                secondHand.updateHandAngle(angle: CGFloat(0.0), duration: 1.0)
            }
            localTime.second = 0
            clocketDelegate?.timeIsSetManually()
            return
        }
        let handRadianAngle = Double(Float.pi - atan2f((Float(tapLocation.x - center.x)),
                                                       (Float(tapLocation.y - center.y))))
        
        //tap or pan on the outer area of the clockface to set the minute hand
        if distanceToCenter / max(10.0, viewSize/2) > hourHandLength * 1.1 {
            minuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.1)
            let newMinuteValue = Int(0.5 + handRadianAngle * 30 / Double.pi) % 60
            
            if newMinuteValue == 0 && localTime.minute == 59 {
                localTime.hour = (localTime.hour + 1) % 12
            } else if newMinuteValue == 59 && localTime.minute == 0 {
                localTime.hour = (localTime.hour - 1) % 12
            }
            localTime.minute = newMinuteValue
            
            //tap or pan on the area of the clockface between the center and the edge to set the hour hand
        } else if distanceToCenter / (viewSize/2) < hourHandLength {
            localTime.hour = Int(handRadianAngle * 6 / Double.pi)
        }
        let hourDegree = Double(localTime.hour) * 30.0 + Double(localTime.minute) * 0.5
        hourHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian), duration: 0.5)
        clocketDelegate?.timeIsSetManually()
    }
}

//MARK: - Set and Get
extension ClocketView {
    func drawHour(
        color: UIColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0),
        length: CGFloat = 0.6,
        width: CGFloat = 0.1,
        tailLength: CGFloat = 0.2
    ) {
        self.hourHandColor = color
        self.hourHandWidth = width
        self.hourHandLength = length
        self.hourHandTailLength = tailLength
    }
    
    func drawMinute(
        color: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0),
        length: CGFloat = 0.8,
        width: CGFloat = 0.07,
        tailLength: CGFloat = 0.2
    ) {
        self.minuteHandColor = color
        self.minuteHandWidth = width
        self.minuteHandLength = length
        self.minuteHandTailLength = tailLength
    }
    
    func drawSecond(
        color: UIColor = UIColor(red: 232/255, green: 60/255, blue: 60/255, alpha: 1.0),
        length: CGFloat = 0.9,
        width: CGFloat = 0.03,
        tailLength: CGFloat = 0.2
    ) {
        self.secondHandColor = color
        self.secondHandWidth = width
        self.secondHandLength = length
        self.secondHandTailLength = tailLength
    }
    
    func drawCircleCenter(
        diameter: CGFloat = 4.0,
        color: UIColor = UIColor(red: 232/255, green: 60/255, blue: 60/255, alpha: 1.0)
    ) {
        self.circleCenterColor = color
        self.circleCenterDiameter = diameter
    }
}

extension ClocketView: UIGestureRecognizerDelegate {}


public protocol ClocketDelegate: AnyObject {
    
    func timeIsSetManually()
    
    func clockStopped()
    
    func countDownExpired()
}
