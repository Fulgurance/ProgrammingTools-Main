class Target < ISM::Software
    
    def build
        super

        targetData = <<-CODE
        {
            "arch": "x86_64",
            "cpu": "x86-64",
            "crt-static-respected": true,
            "data-layout": "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128",
            "dynamic-linking": true,
            "env": "gnu",
            "has-rpath": true,
            "has-thread-local": true,
            "is-builtin": false,
            "linker-flavor": "gcc",
            "llvm-target": "#{Ism.settings.systemTarget}",
            "max-atomic-width": 64,
            "os": "linux",
            "position-independent-executables": true,
            "pre-link-args": {
                "gcc": [
                "-m64"
                ],
                "ld": [
                "-m64"
                ]
            },
            "relro-level": "full",
            "stack-probes": {
                "kind": "inline"
            },
            "static-position-independent-executables": true,
            "supported-sanitizers": [
                "address",
                "leak",
                "memory",
                "thread",
                "cfi",
                "kcfi"
            ],
            "supported-split-debuginfo": [
                "packed",
                "unpacked",
                "off"
            ],
            "supports-xray": true,
            "target-family": [
                "unix"
            ],
            "target-pointer-width": "64"
        }

        CODE
        fileWriteData("#{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",targetData)

        runCargoCommand(arguments:  "build --release --target #{Ism.settings.systemTarget}",
                        path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/target/#{Ism.settings.systemTarget}/release/xargo",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/xargo")
    end

    def install
        super

        runChmodCommand("0755 /usr/bin/xargo")
    end

end
