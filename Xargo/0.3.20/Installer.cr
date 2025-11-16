class Target < ISM::Software
    
    def build
        super

        runCargoCommand(arguments:  "build --release",
                        path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/target/release/xargo",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/xargo")
    end

end
