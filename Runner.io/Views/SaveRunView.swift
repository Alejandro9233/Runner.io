import SwiftUI
import CoreLocation
import MapKit

struct SaveRunView: View {
    @State private var routeName: String = ""
    @State private var isSaving: Bool = false
    @State private var saveResult: String = ""
    @State private var showExitAlert: Bool = false
    
    // Run data passed from RunDashboardView
    let startTime: Date
    let endTime: Date
    let totalDistance: Double    // Total distance en metros
    let locations: [CLLocation]
    
    let firestoreManager = FirestoreManager()
    let authService = AuthService.shared
    
    // Cálculo del tiempo de carrera
    private var runDuration: String {
        let interval = endTime.timeIntervalSince(startTime)
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Calcular el pace promedio en min/km
    private var averagePace: String {
        guard totalDistance > 0 else { return "00:00 min/km" }
        let elapsedMinutes = endTime.timeIntervalSince(startTime) / 60.0
        let pace = elapsedMinutes / (totalDistance / 1000)
        let mins = Int(pace)
        let secs = Int((pace - Double(mins)) * 60)
        return String(format: "%02d:%02d min/km", mins, secs)
    }
    
    // Calcular el área conquistada utilizando la fórmula de shoelace sobre MKMapPoints
    private var conqueredArea: String {
        let area = computePolygonArea()
        if area < 1_000_000 { // Mostrar en metros cuadrados
            return String(format: "%.0f m²", area)
        } else {
            let areaKm = area / 1_000_000
            return String(format: "%.2f km²", areaKm)
        }
    }
    
    // Función para calcular el área del polígono formado por las ubicaciones
    private func computePolygonArea() -> Double {
        guard locations.count > 2 else { return 0 }
        let points = locations.map { MKMapPoint($0.coordinate) }
        var area: Double = 0.0
        for i in 0..<points.count {
            let j = (i + 1) % points.count
            area += points[i].x * points[j].y - points[j].x * points[i].y
        }
        return abs(area) * 0.5
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Resumen de la carrera en "cards"
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Run Summary")
                            .font(.headline)
                        HStack {
                            Text("Duration:")
                            Spacer()
                            Text(runDuration)
                        }
                        HStack {
                            Text("Distance:")
                            Spacer()
                            Text(String(format: "%.2f km", totalDistance / 1000))
                        }
                        HStack {
                            Text("Recorded Locations:")
                            Spacer()
                            Text("\(locations.count)")
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Run Metrics")
                            .font(.headline)
                        HStack {
                            Text("Avg Pace:")
                            Spacer()
                            Text(averagePace)
                        }
                        HStack {
                            Text("Conquered Area:")
                            Spacer()
                            Text(conqueredArea)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Campo para introducir el nombre de la ruta
                TextField("Route Name", text: $routeName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if isSaving {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: saveRun) {
                        Text("Save Run")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(routeName.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(routeName.isEmpty)
                }
                
                if !saveResult.isEmpty {
                    Text(saveResult)
                        .foregroundColor(saveResult.contains("Error") ? .red : .green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Save Run")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Cancel") {
                showExitAlert = true
            })
            .alert(isPresented: $showExitAlert) {
                Alert(title: Text("Discard Run?"),
                      message: Text("If you exit now, the run will not be saved."),
                      primaryButton: .destructive(Text("Discard")) {
                          dismissView()
                      },
                      secondaryButton: .cancel())
            }
        }
    }
    
    private func saveRun() {
        guard !routeName.isEmpty else {
            saveResult = "Please enter a route name."
            return
        }
        
        isSaving = true
        saveResult = ""
        
        // Crear un objeto Route a partir de los datos de la carrera
        let route = Route(
            id: UUID(),
            userId: authService.currentUserId,
            name: routeName,
            startTime: startTime,
            endTime: endTime,
            totalDistance: totalDistance / 1000,
            locations: locations
        )
        
        // Guardar la carrera en Firestore
        FirestoreManager.saveRoute(userId: authService.currentUserId, route: route) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success:
                    saveResult = "Run saved successfully!"
                    routeName = ""
                case .failure(let error):
                    saveResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
}