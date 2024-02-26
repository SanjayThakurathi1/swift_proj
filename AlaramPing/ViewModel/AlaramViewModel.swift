import Foundation
import AudioToolbox
import AVFoundation

struct AlarmItem: Identifiable {
    let id = UUID()
    var time: Date
    var state: AlarmState = .pending
}

enum AlarmState {
    case pending, active, canceled
}

class AlarmViewModel: ObservableObject {
    @Published var alarms: [AlarmItem] = []
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var audioSessionConfigured = false

    init() {
        configureAudioSession()
    }

    func setAlarm(for time: Date) {
        let alarm = AlarmItem(time: time)
        alarms.append(alarm)
        scheduleNextAlarm()
    }

    private func scheduleNextAlarm() {
        guard let nextAlarm = alarms.filter({ $0.state == .pending }).min(by: { $0.time < $1.time }),
              nextAlarm.time > Date() else { return }

        timer?.invalidate()  // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: nextAlarm.time.timeIntervalSinceNow, repeats: false) { [weak self] _ in
            self?.activateAlarm(nextAlarm)
        }
    }

    private func activateAlarm(_ alarm: AlarmItem) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].state = .active
        }
        triggerVibration()
        playSound()
    }

    private func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    private func playSound() {
       //configureAudioSession()

        guard audioSessionConfigured else { return }
        
        guard let soundURL = Bundle.main.url(forResource: "alaram_sound", withExtension: "mp3",subdirectory: "Sounds") else
        {
            print("Unable to find alaram_sound.mp3 in the bundle.")
            return
        }
        

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.play()
        } catch {
            print("Failed to play the sound file: \(error)")
        }
    }

    func cancelAlarm(id: UUID)
    {
        guard let index = alarms.firstIndex(where: { $0.id == id }) else { return }
        alarms[index].state = .canceled
        audioPlayer?.stop() // Stop the sound when the alarm is canceled
        scheduleNextAlarm() // Check if there's another alarm to schedule
    }

    private func configureAudioSession() 
    {
        do 
        {

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            audioSessionConfigured = true
            
        } catch {
            
            print("Failed to configure the audio session for background playback: \(error)")
            audioSessionConfigured = false
        }
    }
}
