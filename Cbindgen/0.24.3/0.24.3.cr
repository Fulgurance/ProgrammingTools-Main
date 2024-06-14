class Target < ISM::Software
    
    def build
        super

        runCargoCommand(arguments:  "build --release",
                        path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/target/release/cbindgen",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cbindgen")
    end

    def install
        super

        runChmodCommand("0755 /usr/bin/cbindgen")
    end

end
