class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--disable-static"],
                            buildDirectoryPath)
    end
    
    def build
        super
        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource(["docdir=/usr/share/doc/check-0.15.2","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
