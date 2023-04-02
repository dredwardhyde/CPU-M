import SwiftUI

extension Process {
    static func stringFromSysctl(command: String) -> String {
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
    
    static func stringFromSwVers(command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "sw_vers -" + command]
        task.launch()
        var decodedString = ""
        if let decodedData = Data(base64Encoded: pipe.fileHandleForReading.availableData.base64EncodedString()) {
            decodedString = String(data: decodedData, encoding: .utf8)!
        }
        return decodedString.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    static let processor = stringFromSysctl(command: "machdep.cpu.brand_string")
    static let hostname = stringFromSysctl(command: "kern.hostname")
    static let os_build = stringFromSysctl(command: "kern.osversion")
    static let total_memory = stringFromSysctl(command: "hw.memsize")
    
    static let cores_level1_name = stringFromSysctl(command: "hw.perflevel1.name")
    static let cores_level1_count = stringFromSysctl(command: "hw.perflevel1.physicalcpu")
    static let cores_level1_l1icache = stringFromSysctl(command: "hw.perflevel1.l1icachesize")
    static let cores_level1_l1dcache = stringFromSysctl(command: "hw.perflevel1.l1dcachesize")
    static let cores_per_l2_level1 = stringFromSysctl(command: "hw.perflevel1.cpusperl2")
    static let l2_cache_size_level1 = stringFromSysctl(command: "hw.perflevel1.l2cachesize")
    
    static let cores_level0_name = stringFromSysctl(command: "hw.perflevel0.name")
    static let cores_level0_count = stringFromSysctl(command: "hw.perflevel0.physicalcpu")
    static let cores_level0_l1icache = stringFromSysctl(command: "hw.perflevel0.l1icachesize")
    static let cores_level0_l1dcache = stringFromSysctl(command: "hw.perflevel0.l1dcachesize")
    static let cores_per_l2_level0 = stringFromSysctl(command: "hw.perflevel0.cpusperl2")
    static let l2_cache_size_level0 = stringFromSysctl(command: "hw.perflevel0.l2cachesize")
    
    static let os_name = stringFromSwVers(command: "productName")
    static let os_version = stringFromSwVers(command: "productVersion")
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
                Text("CPU-M")
                    .font(.headline)
                    .padding(.top, 6).ignoresSafeArea()
            }.padding(.horizontal, 10)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("OS name")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.os_name + " " + Process.os_version)
                        .frame(width: 100, alignment: .leading).foregroundColor(.gray)
                }
                HStack {
                    Text("OS version")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.os_build)
                        .frame(width: 100, alignment: .leading).foregroundColor(.gray)
                }
                HStack {
                    Text("Hostname")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.hostname)
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Total memory")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(convertToGbString(source: Process.total_memory))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Processor")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.processor)
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text(Process.cores_level1_name + " cores")
                        .font(.headline)
                        .lineLimit(2)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level1_count)
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading)  {
                
                HStack{
                    Text("L1 Data")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level1_count + " x " + convertToKbString(source: Process.cores_level1_l1dcache))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
                HStack{
                    Text("L1 Instruction")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level1_count + " x " + convertToKbString(source: Process.cores_level1_l1icache))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
                HStack{
                    Text("L2 Universal")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_per_l2_level1 + " x " + convertToMbString(source: Process.l2_cache_size_level1))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10)
                
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text(Process.cores_level0_name + " cores")
                        .font(.headline)
                        .lineLimit(2)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level0_count)
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading)  {
                HStack(spacing: 10) {
                    Text("L1 Data")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level0_count + " x " + convertToKbString(source: Process.cores_level0_l1dcache)).foregroundColor(.gray)
                }
                HStack(spacing: 10) {
                    Text("L1 Instruction")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(Process.cores_level0_count + " x " + convertToKbString(source: Process.cores_level0_l1icache))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
                HStack(spacing: 10) {
                    Text("L2 Universal")
                        .font(.headline)
                        .frame(width: 150, alignment: .leading)
                    Text(getL2NumberOfClusters() + " x " + convertToMbString(source: Process.l2_cache_size_level0))
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(minWidth: 270, maxWidth: 270, minHeight: 350, maxHeight: 350, alignment:.top)
        .fixedSize()
        .background(VisualEffectView().ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
