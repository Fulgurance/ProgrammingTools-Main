class Target < ISM::Software
    
    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--with-gitconfig=/etc/gitconfig",
                            "--with-python=python3"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource([Ism.settings.makeOptions,"perllibdir=/usr/lib/perl5/5.34/site_perl","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
