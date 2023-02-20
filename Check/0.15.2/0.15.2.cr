class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--disable-static"],
                            buildDirectoryPath)
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"docdir=/usr/share/doc/check-0.15.2","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
