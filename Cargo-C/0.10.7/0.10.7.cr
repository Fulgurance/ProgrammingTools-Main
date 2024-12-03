class Target < ISM::Software
    
    def build
        super

        runCargoCommand(arguments:  "build --release",
                        path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/target/release/cargo-capi",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cargo-capi")

        copyFile(   "#{buildDirectoryPath}/target/release/cargo-cbuild",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cargo-cbuild")

        copyFile(   "#{buildDirectoryPath}/target/release/cargo-cinstall",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cargo-cinstall")

        copyFile(   "#{buildDirectoryPath}/target/release/cargo-ctest",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cargo-ctest")
    end

    def install
        super

        runChmodCommand("0755 /usr/bin/cargo-capi")
        runChmodCommand("0755 /usr/bin/cargo-cbuild")
        runChmodCommand("0755 /usr/bin/cargo-cinstall")
        runChmodCommand("0755 /usr/bin/cargo-ctest")
    end

end
