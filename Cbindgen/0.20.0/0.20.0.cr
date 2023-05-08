class Target < ISM::Software
    
    def build
        super

        runCargoCommand(["build","--release"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        copyFile("#{buildDirectoryPath(false)}/target/release/cbindgen","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/cbindgen")
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/bin/cbindgen",0o755)
    end

end
