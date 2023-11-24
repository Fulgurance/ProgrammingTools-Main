class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/bison-3.8.2"],
                            buildDirectoryPath)
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
