class Target < ISM::Software
    
    def build
        super

        runCargoCommand(["build","--release"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile("#{buildDirectoryPath}/target/release/cbindgen","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/cbindgen")
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/bin/cbindgen",0o755)
    end

end
