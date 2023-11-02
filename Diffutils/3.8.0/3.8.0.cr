class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
