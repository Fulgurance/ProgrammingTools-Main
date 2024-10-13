class Target < ISM::Software
    
    def build
        super

        runXargoCommand(arguments:  "build --release --target #{Ism.settings.systemTarget}",
                        path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/target/#{Ism.settings.systemTarget}/release/cbindgen",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cbindgen")
    end

    def install
        super

        runChmodCommand("0755 /usr/bin/cbindgen")
    end

end
