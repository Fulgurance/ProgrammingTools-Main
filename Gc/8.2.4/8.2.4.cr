class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--enable-cplusplus",
                            "--disable-static",
                            "--docdir=/usr/share/doc/gc-8.2.4"],
                            buildDirectoryPath)
    end
    
    def build
        super
        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3")
        moveFile("#{buildDirectoryPath}doc/gc.man","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/man/man3/gc_malloc.3")
    end

end
