class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--enable-cplusplus",
                            "--disable-static",
                            "--docdir=/usr/share/doc/gc-8.2.2"],
                            buildDirectoryPath)
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man3")
        moveFile("#{buildDirectoryPath(false)}doc/gc.man","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man3/gc_malloc.3")
    end

end
