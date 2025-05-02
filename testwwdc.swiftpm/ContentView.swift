import SwiftUI
import AVFoundation
import Vision
import UIKit

struct ContentView: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro: Bool = false

    @State private var consumedProtein: Double = 0
    @State private var consumedCarbs: Double = 0
    @State private var consumedFats: Double = 0
    @State private var consumedSodium: Double = 0
    @State private var consumedSugar: Double = 0
    @State private var consumedCholesterol: Double = 0

    @AppStorage("userWeight") private var userWeight: Double = 85
    var targetProtein: Double { userWeight * 1.5 }
    var targetCarbs: Double { userWeight * 2.0 }
    var targetFats: Double { userWeight * 0.7 }

    var body: some View {
        if hasSeenIntro {
            TabView {
                TabOneView(
                    consumedProtein: $consumedProtein,
                    consumedCarbs: $consumedCarbs,
                    consumedFats: $consumedFats,
                    consumedSodium: $consumedSodium,
                    consumedSugar: $consumedSugar,
                    consumedCholesterol: $consumedCholesterol,
                    targetProtein: targetProtein,
                    targetCarbs: targetCarbs,
                    targetFats: targetFats
                )
                .tabItem {
                    Label("Home", systemImage: "house")
                }

                TabTwoView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }

                TabThreeView()
                    .tabItem {
                        Label("History", systemImage: "fossil.shell")
                    }
            }
            .accentColor(Color.green)
        } else {
            IntroductoryScreens(hasSeenIntro: $hasSeenIntro)
        }
    }
}




struct IntroductoryScreens: View {
    @Binding var hasSeenIntro: Bool
    @State private var userName: String = ""
    @State private var currentPage = 0
    let totalPages = 5
    @Namespace private var animation

    var body: some View {
        ZStack {
            // ✅ Modern Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // ✅ Animated Page Transitions
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 1.1)), removal: .opacity))

                    FeaturesPage()
                        .tag(1)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)), removal: .opacity))

                    GoalsPage()
                        .tag(2)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .opacity))

                    NutritionPage()
                        .tag(3)
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))

                    NamePage(userName: $userName)
                        .tag(4)
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut(duration: 0.5), value: currentPage)

                Spacer()

                // ✅ Modern Navigation Buttons with Animation
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .modernButtonStyle()
                        }
                    }

                    Spacer()

                    if currentPage < totalPages - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .modernButtonStyle()
                        }
                    } else {
                        Button(action: {
                            if !userName.isEmpty {
                                UserDefaults.standard.set(userName, forKey: "userName")
                                UserDefaults.standard.set(true, forKey: "hasSeenIntro")
                                self.hasSeenIntro = true
                            }
                        }) {
                            Text("Start")
                                .modernButtonStyle()
                        }
                    }
                }
                .padding()
            }
        }
    }
}



// ✅ Individual Onboarding Pages

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hi, I'm Nora!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Text("I'm not like your traditional nutrition tracker. Instead, I'm focused on teaching you how to accurately manage and track your nutritional goals!")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(30)
                .foregroundColor(.secondary)
            
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .shadow(radius: 10)
        }
        .padding()
    }
}

struct FeaturesPage: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("How Does NORA Help You?")
                .font(.system(size: 36, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Nora provides personalized nutrition insights based on your goals and educates you on how to reach your goals!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
            
            Image(systemName: "chart.bar.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .shadow(radius: 10)
            
            Text("Fill your goals out in the next pages, to help NORA guide you better!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct GoalsPage: View {
    @AppStorage("selectedGoal") private var selectedGoal: String = "" // Persisted goal
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Health Goals")
                .font(.system(size: 36, weight: .bold))
            
            Text("Select one of the goals below to let Nora guide you.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
            
            VStack(spacing: 20) {
                GoalOptionView(goal: "Weight Loss", selectedGoal: $selectedGoal)
                GoalOptionView(goal: "Muscle Gain", selectedGoal: $selectedGoal)
                GoalOptionView(goal: "General Health", selectedGoal: $selectedGoal)
            }
            
            Spacer()
        }
        .padding()
    }
}

extension GoalsPage {
    struct GoalOptionView: View {
        let goal: String
        @Binding var selectedGoal: String
        
        var body: some View {
            Button(action: {
                selectedGoal = goal
                UserDefaults.standard.set(goal, forKey: "selectedGoal")
            }) {
                HStack {
                    Text(goal)
                        .font(.headline)
                        .foregroundColor(color(for: goal))
                    
                    Spacer()
                    
                    Image(systemName: icon(for: goal))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(color(for: goal))
                }
                .padding()
                .frame(height: 80)  // Fixed height for all boxes
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedGoal == goal ? Color.green : Color.gray, lineWidth: 2)
                )
            }
        }
        
        func icon(for goal: String) -> String {
            switch goal {
            case "Weight Loss": return "flame.fill"
            case "Muscle Gain": return "figure.strengthtraining.traditional"
            case "General Health": return "heart.fill"
            default: return "questionmark.circle"
            }
        }
        
        func color(for goal: String) -> Color {
            return selectedGoal == goal ? .green : .primary
        }
    }
}

// MARK: - NutritionPage with Customizable Weight
struct ImageScannerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onNutritionExtracted: (ExtractedNutrition) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImageScannerView

        init(parent: ImageScannerView) {
            self.parent = parent
        }

        // When an image is picked, process it
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                recognizeText(from: image)
            }
            parent.isPresented = false
        }

        func recognizeText(from image: UIImage) {
            guard let cgImage = image.cgImage else { return }
            
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                let nutritionData = extractNutritionValues(from: extractedText)
                
                DispatchQueue.main.async {
                    self.parent.onNutritionExtracted(nutritionData)
                }
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct NutritionPage: View {
    @AppStorage("userWeight") var userWeight: Double = 85 // Persist user's weight
    var body: some View {
        VStack(spacing: 20) {
            Text("Personalized Nutrition")
                .font(.system(size: 36, weight: .bold))
            
            Text("Analyze your diet and improve your eating habits with Nora’s smart recommendations.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
            
            // Circle displaying the current weight
            ZStack {
                Circle()
                    .stroke(Color.green, lineWidth: 6)
                    .frame(width: 150, height: 150)
                
                Text("\(Int(userWeight))")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.green)
            }
            .shadow(radius: 10)
            
            // Slider to let the user customize their weight
            Slider(value: $userWeight, in: 40...150, step: 1)
                .padding(.horizontal)
            Text("Your weight in kg")
                .font(.subheadline)
        }
        .padding()
    }
}

struct NamePage: View {
    @Binding var userName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Almost There")
                .font(.system(size: 36, weight: .bold))
            
            Text("Before we start, could you tell me your name?")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
            
            TextField("Enter your name", text: $userName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .shadow(radius: 5)
        }
        .padding()
    }
}

// ✅ Modern Button Modifier
extension View {
    func modernButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}

// Custom Fancy Green Button Style for the Scan Button
struct FancyGreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    // Base green background with rounded corners
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.green)
                    
                    // Subtle stroke overlay for a cool highlight effect
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(Color.green.opacity(0.7), lineWidth: 2)
                        .blur(radius: 1)
                }
            )
            .foregroundColor(.white)
            .overlay(
                // A slight gradient overlay for a reflective touch
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct TabOneView: View {
    @Binding var consumedProtein: Double
    @Binding var consumedCarbs: Double
    @Binding var consumedFats: Double
    @Binding var consumedSodium: Double
    @Binding var consumedSugar: Double
    @Binding var consumedCholesterol: Double

    var targetProtein: Double
    var targetCarbs: Double
    var targetFats: Double

    @State private var isShowingScanner = false
    @State private var extractedNutrition: ExtractedNutrition?
    @State private var isShowingConfirmation = false
    @State private var healthScore: Int = 100 // Health score needs to update dynamically

    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)

            Text("Welcome! Scan below to get started!")
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)

            Button(action: {
                isShowingScanner.toggle()
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.title)
                    Text("Take Photo of Nutrition Label")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .buttonStyle(FancyGreenButtonStyle())
            .padding(25)
            .fullScreenCover(isPresented: $isShowingScanner) {
                ImageScannerView(isPresented: $isShowingScanner, onNutritionExtracted: { nutrition in
                    self.extractedNutrition = nutrition
                    self.isShowingConfirmation = true
                })
            }

            // ✅ Alert for Nutrition Data Confirmation
            .alert("Confirm Nutrition Data", isPresented: $isShowingConfirmation) {
                Button("Yes", role: .none) {
                    if let nutrition = extractedNutrition {
                        processExtractedNutrition(nutrition)
                    }
                }
                Button("No", role: .cancel) {}
            } message: {
                if let nutrition = extractedNutrition {
                    Text(nutrition.formatted())
                } else {
                    Text("No nutrition data found.")
                }
            }

            // ✅ Animated Health Score Display
            AnimatedHealthScore(score: healthScore)

            // ✅ Macro Tracker
            MacroTrackerView(
                consumedProtein: consumedProtein,
                consumedCarbs: consumedCarbs,
                consumedFats: consumedFats,
                targetProtein: targetProtein,
                targetCarbs: targetCarbs,
                targetFats: targetFats
            )

            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .onAppear {
            healthScore = calculateHealthScore() // Make sure it updates when the view appears
        }
    }

    // ✅ Process Extracted Nutrition Data
    func processExtractedNutrition(_ nutrition: ExtractedNutrition) {
        DispatchQueue.main.async {
            if let protein = nutrition.protein { consumedProtein += protein }
            if let carbs = nutrition.carbs { consumedCarbs += carbs }
            if let fats = nutrition.fat { consumedFats += fats }
            if let sodium = nutrition.sodium { consumedSodium += sodium }
            if let sugar = nutrition.sugar { consumedSugar += sugar }
            if let cholesterol = nutrition.cholesterol { consumedCholesterol += cholesterol }

            healthScore = calculateHealthScore() // ✅ Recalculate health score
        }
    }

    // ✅ Health Score Calculation
    func calculateHealthScore() -> Int {
        let maxSodium = 2300.0
        let maxSugar = 50.0
        let maxCholesterol = 300.0

        let sodiumPenalty = min(consumedSodium / maxSodium, 1) * 40
        let sugarPenalty = min(consumedSugar / maxSugar, 1) * 40
        let cholesterolPenalty = min(consumedCholesterol / maxCholesterol, 1) * 30

        let proteinBonus = max(1 - abs(consumedProtein / targetProtein - 1), 0) * 40
        let carbBonus = max(1 - abs(consumedCarbs / targetCarbs - 1), 0) * 20
        let fatBonus = max(1 - abs(consumedFats / targetFats - 1), 0) * 15

        let rawScore = 100 - (sodiumPenalty + sugarPenalty + cholesterolPenalty) + (proteinBonus + carbBonus + fatBonus)

        return max(0, min(Int(rawScore), 100))
    }
}



// ✅ Animated Health Score Gauge
struct AnimatedHealthScore: View {
    let score: Int
    @State private var animatedScore: CGFloat = 0.0

    var body: some View {
        VStack {
            Text("Health Score")
                .font(.headline)
                .padding(.bottom, 5)

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: animatedScore / 100)
                    .stroke(getScoreColor(score), lineWidth: 6)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.5), value: animatedScore)

                Text("\(score)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(getScoreColor(score))
            }
            .onAppear {
                withAnimation {
                    animatedScore = CGFloat(score)
                }
            }
        }
        .padding()
    }

    // ✅ Get Color Based on Score
    func getScoreColor(_ score: Int) -> Color {
        switch score {
        case 70...100: return .green
        case 40..<70: return .yellow
        default: return .red
        }
    }
}

// ✅ Improved Macro Tracker View
struct MacroTrackerView: View {
    let consumedProtein: Double
    let consumedCarbs: Double
    let consumedFats: Double
    let targetProtein: Double
    let targetCarbs: Double
    let targetFats: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Macros")
                .font(.headline)
                .padding(.bottom, 5)

            MacroProgressView(macroName: "Protein", consumed: consumedProtein, target: targetProtein, color: .red)
            MacroProgressView(macroName: "Carbohydrates", consumed: consumedCarbs, target: targetCarbs, color: .blue)
            MacroProgressView(macroName: "Fats", consumed: consumedFats, target: targetFats, color: .orange)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(radius: 3)
        )
        .padding(.horizontal)
    }
}

// ✅ Improved Progress View for Macros
struct MacroProgressView: View {
    let macroName: String
    let consumed: Double
    let target: Double
    let color: Color

    var progress: Double {
        return min(consumed / target, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(macroName): \(Int(consumed))g / \(Int(target))g")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
                Text(String(format: "%.0f%%", progress * 100))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(height: 8)
                .cornerRadius(5)
        }
    }
}










// ✅ Improved Macro Tracker View with Better UI



func extractNutritionValues(from text: String) -> ExtractedNutrition {
    let patterns: [String: String] = [
        "Fat": "Fat\\s*:?\\s*(\\d+\\.?\\d*)\\s*g?",
        "Cholesterol": "Cholesterol\\s*:?\\s*(\\d+\\.?\\d*)\\s*mg?",
        "Sodium": "Sodium\\s*:?\\s*(\\d+\\.?\\d*)\\s*mg?",
        "Carbohydrates": "Carbohydrates?|Carbs\\s*:?\\s*(\\d+\\.?\\d*)\\s*g?",
        "Protein": "Protein\\s*:?\\s*(\\d+\\.?\\d*)\\s*g?",
        "Sugar": "Sugar\\s*:?\\s*(\\d+\\.?\\d*)\\s*g?"
    ]
    
    var nutrition = ExtractedNutrition()
    
    for (key, pattern) in patterns {
        if let value = extractValue(from: text, using: pattern) {
            switch key {
                case "Fat": nutrition.fat = value
                case "Cholesterol": nutrition.cholesterol = value
                case "Sodium": nutrition.sodium = value
                case "Carbohydrates": nutrition.carbs = value
                case "Protein": nutrition.protein = value
                case "Sugar": nutrition.sugar = value
                default: break
            }
        }
    }
    
    return nutrition
}

func calculateHealthScore(
    consumedProtein: Double,
    consumedCarbs: Double,
    consumedFats: Double,
    consumedSodium: Double,
    consumedSugar: Double,
    consumedCholesterol: Double,
    targetProtein: Double,
    targetCarbs: Double,
    targetFats: Double
) -> Int {
    let maxSodium = 2300.0  // mg
    let maxSugar = 50.0      // g
    let maxCholesterol = 300.0 // mg

    // Penalties for excessive intake
    let sodiumPenalty = min(consumedSodium / maxSodium, 1) * 20
    let sugarPenalty = min(consumedSugar / maxSugar, 1) * 20
    let cholesterolPenalty = min(consumedCholesterol / maxCholesterol, 1) * 15

    // Bonus for macronutrient balance
    let proteinBonus = max(1 - abs(consumedProtein / targetProtein - 1), 0) * 25
    let carbBonus = max(1 - abs(consumedCarbs / targetCarbs - 1), 0) * 15
    let fatBonus = max(1 - abs(consumedFats / targetFats - 1), 0) * 10

    // Calculate raw score
    let rawScore = 100 - (sodiumPenalty + sugarPenalty + cholesterolPenalty) + (proteinBonus + carbBonus + fatBonus)

    return max(0, min(Int(rawScore), 100))
}



func extractValue(from text: String, using pattern: String) -> Double? {
    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    let matches = regex?.matches(in: text, range: NSRange(text.startIndex..., in: text))
    
    if let match = matches?.first, let range = Range(match.range(at: 1), in: text) {
        return Double(text[range])
    }
    return nil
}


struct ExtractedNutrition {
    var fat: Double?
    var cholesterol: Double?
    var sodium: Double?
    var carbs: Double?
    var protein: Double?
    var sugar: Double?

    func formatted() -> String {
        var result = ""
        if let fat = fat { result += "Fat: \(fat)g\n" }
        if let cholesterol = cholesterol { result += "Cholesterol: \(cholesterol)mg\n" }
        if let sodium = sodium { result += "Sodium: \(sodium)mg\n" }
        if let carbs = carbs { result += "Carbohydrates: \(carbs)g\n" }
        if let protein = protein { result += "Protein: \(protein)g\n" }
        if let sugar = sugar { result += "Sugar: \(sugar)g\n" }
        return result.isEmpty ? "No nutrition data found." : result
    }
}





struct CameraView: View {
    @Binding var isPresented: Bool
    var onNutritionExtracted: (ExtractedNutrition) -> Void
    
    @State private var extractedNutrition: ExtractedNutrition?
    @State private var isShowingConfirmation = false
    
    var body: some View {
        ZStack {
            CameraViewControllerRepresentable { text in
                extractedNutrition = extractNutritionValues(from: text)
                isShowingConfirmation = true  // Show confirmation popup
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .alert("Confirm Nutrition Data", isPresented: $isShowingConfirmation) {
            Button("Yes", role: .none) {
                if let nutrition = extractedNutrition {
                    onNutritionExtracted(nutrition)  // Send extracted values to SwiftUI
                }
                isPresented = false
            }
            Button("No", role: .cancel) {
                isShowingConfirmation = false  // Return to scanning
            }
        } message: {
            if let nutrition = extractedNutrition {
                Text(nutrition.formatted())
            } else {
                Text("No nutrition data found.")
            }
        }
    }
}




// Bridge UIKit ViewController to SwiftUI
struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    var onTextRecognized: (String) -> Void
    
    func makeUIViewController(context: Context) -> CameraViewControllerWrapper {
        let controller = CameraViewControllerWrapper()
        controller.recognizedTextHandler = onTextRecognized
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewControllerWrapper, context: Context) {}
}

// ✅ UIKit-based Camera View Controller
class CameraViewControllerWrapper: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var recognizedTextHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

extension CameraViewControllerWrapper: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let scannedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            DispatchQueue.main.async {
                self.recognizedTextHandler?(scannedText)
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? requestHandler.perform([request])
    }
}

// ✅ AVCaptureSession Wrapper





struct TabTwoView: View {
    @AppStorage("userName") private var userName: String = "User"
    @AppStorage("selectedGoal") private var selectedGoal: String = "Not set"
    @AppStorage("userWeight") private var userWeight: Double = 85
    @AppStorage("hasSeenIntro") private var hasSeenIntro: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 25)

            VStack(spacing: 15) {
                ProfileInfoCard(icon: "person.fill", title: "Name", value: userName)
                ProfileInfoCard(icon: "target", title: "Goal", value: selectedGoal)
                ProfileInfoCard(icon: "scalemass.fill", title: "Weight", value: "\(Int(userWeight * 2.20462)) lbs")
            }
            .padding(.horizontal, 40)

            Spacer()

            Button(action: {
                resetProfile()
            }) {
                Text("Reset Profile")
                    .modernButtonStyle()
            }
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }

    private func resetProfile() {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "selectedGoal")
        UserDefaults.standard.removeObject(forKey: "userWeight")
        UserDefaults.standard.set(false, forKey: "hasSeenIntro")
        exit(0)
    }
}




// ✅ Updated Profile Info Card View
struct ProfileInfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

struct TabThreeView: View {
    @AppStorage("nutritionHistory") private var nutritionHistoryData: Data = Data()
    @State private var historyEntries: [NutritionEntry] = []

    var body: some View {
        VStack {
            Text("Nutrition History")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(historyEntries.indices, id: \.self) { index in
                        NutritionHistoryCard(entry: historyEntries[index])
                            .transition(.move(edge: .trailing))
                            .animation(.spring(), value: historyEntries.count)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.green.opacity(0.5)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .onAppear {
            loadHistory()
        }
    }

    func loadHistory() {
        if let decoded = try? JSONDecoder().decode([NutritionEntry].self, from: nutritionHistoryData) {
            historyEntries = decoded
        }
    }
}



// ✅ History Card UI
struct NutritionHistoryCard: View {
    let entry: NutritionEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.date, formatter: dateFormatter)")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack {
                VStack(alignment: .leading) {
                    Text("Protein: \(Int(entry.protein))g")
                    Text("Carbs: \(Int(entry.carbs))g")
                    Text("Fats: \(Int(entry.fats))g")
                }
                Spacer()
                Text("Score: \(entry.healthScore)")
                    .bold()
                    .foregroundColor(getScoreColor(entry.healthScore))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        .shadow(radius: 2)
    }

    // ✅ Health Score Color Function
    func getScoreColor(_ score: Int) -> Color {
        switch score {
        case 70...100: return .green
        case 40..<70: return .yellow
        default: return .red
        }
    }
}


// ✅ Nutrition Entry Model
struct NutritionEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let protein, carbs, fats, sodium, sugar, cholesterol: Double
    let healthScore: Int
}

// ✅ Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct IntroductoryScreens_Previews: PreviewProvider {
    static var previews: some View {
        IntroductoryScreens(hasSeenIntro: .constant(false))
    }
}
