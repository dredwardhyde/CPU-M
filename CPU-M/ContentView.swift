import SwiftUI

extension Process {
    static func stringFromTerminal(command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "sysctl -n " + command]
        task.launch()
        var decodedString = ""
        if let decodedData = Data(base64Encoded: pipe.fileHandleForReading.availableData.base64EncodedString()) {
            decodedString = String(data: decodedData, encoding: .utf8)!
        }
        return decodedString.trimmingCharacters(in: CharacterSet.newlines)
    }
    static let processor = stringFromTerminal(command: "machdep.cpu.brand_string")
    static let hostname = stringFromTerminal(command: "kern.hostname")
    static let os_version = stringFromTerminal(command: "kern.osversion")
    static let total_memory = stringFromTerminal(command: "hw.memsize")
    
    static let cores_level1_name = stringFromTerminal(command: "hw.perflevel1.name")
    static let cores_level1_count = stringFromTerminal(command: "hw.perflevel1.physicalcpu")
    static let cores_level1_l1icache = stringFromTerminal(command: "hw.perflevel1.l1icachesize")
    static let cores_level1_l1dcache = stringFromTerminal(command: "hw.perflevel1.l1dcachesize")
    static let cores_per_l2_level1 = stringFromTerminal(command: "hw.perflevel1.cpusperl2")
    static let l2_cache_size_level1 = stringFromTerminal(command: "hw.perflevel1.l2cachesize")
    
    static let cores_level0_name = stringFromTerminal(command: "hw.perflevel0.name")
    static let cores_level0_count = stringFromTerminal(command: "hw.perflevel0.physicalcpu")
    static let cores_level0_l1icache = stringFromTerminal(command: "hw.perflevel0.l1icachesize")
    static let cores_level0_l1dcache = stringFromTerminal(command: "hw.perflevel0.l1dcachesize")
    static let cores_per_l2_level0 = stringFromTerminal(command: "hw.perflevel0.cpusperl2")
    static let l2_cache_size_level0 = stringFromTerminal(command: "hw.perflevel0.l2cachesize")
}


struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()

        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        //
    }
}

struct ContentView: View {

    
    func convertToGbString(source: String) -> String {
        let targetGb = (UInt64(source) ?? 0) / UInt64(1024 * 1024 * 1024)
        return String(targetGb) + " GB"
    }
    
    func convertToKbString(source: String) -> String {
        let targetGb = (UInt64(source) ?? 0) / UInt64(1024)
        return String(targetGb) + " KB"
    }
    
    func convertToMbString(source: String) -> String {
        let targetGb = (UInt64(source) ?? 0) / UInt64(1024 * 1024)
        return String(targetGb) + " MB"
    }
    
    func getL2NumberOfClusters() -> String {
        return String((Int8(Process.cores_level0_count) ?? 0) / (Int8(Process.cores_per_l2_level0) ?? 1))
    }
    
    var body: some View {
        
        VStack {
            VStack {
                Text("System Information").padding(.top, 6).ignoresSafeArea()
                HStack(spacing: 10) {
                    Text("OS version")
                    Text(Process.os_version)
                }
                HStack(spacing: 10) {
                    Text("Hostname")
                    Text(Process.hostname)
                }
                HStack(spacing: 10) {
                    Text("Processor")
                    Text(Process.processor)
                }
               
                HStack(spacing: 10) {
                    Text("Hostname")
                    Text(Process.hostname)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .ignoresSafeArea()
            
            VStack {
                
                HStack(spacing: 10) {
                    Text("Total memory")
                    Text(convertToGbString(source: Process.total_memory))
                }
                Text(Process.cores_level1_name + " cores: " + Process.cores_level1_count).padding(.top, 6).ignoresSafeArea()
                HStack(spacing: 10) {
                    Text("L1d")
                    Text(Process.cores_level1_count + " x " + convertToKbString(source: Process.cores_level1_l1dcache))
                }
                HStack(spacing: 10) {
                    Text("L1i")
                    Text(Process.cores_level1_count + " x " + convertToKbString(source: Process.cores_level1_l1icache))
                }
                HStack(spacing: 10) {
                    Text("L2")
                    Text(Process.cores_per_l2_level1 + " x " + convertToMbString(source: Process.l2_cache_size_level1))
                }
                
                
                Text(Process.cores_level0_name + " cores: " + Process.cores_level0_count).padding(.top, 6).ignoresSafeArea()
                HStack(spacing: 10) {
                    Text("L1d")
                    Text(Process.cores_level0_count + " x " + convertToKbString(source: Process.cores_level0_l1dcache))
                }
                HStack(spacing: 10) {
                    Text("L1i")
                    Text(Process.cores_level0_count + " x " + convertToKbString(source: Process.cores_level0_l1icache))
                }
                HStack(spacing: 10) {
                    Text("L2")
                    Text(getL2NumberOfClusters() + " x " + convertToMbString(source: Process.l2_cache_size_level0))
                }
            }
        }
        .frame(minWidth: 300, maxWidth: 300, minHeight: 400, maxHeight: 400, alignment: .top)
        .fixedSize()
        .background(VisualEffectView().ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
