class Target < ISM::Software

    def prepare
        super

        runAutoreconfCommand(   arguments: "-fiv",
                                path: buildDirectoryPath)
    end
    
    def configure
        super
        configureSource(arguments:  "--prefix=/usr                  \
                                    --with-gitconfig=/etc/gitconfig \
                                    --with-editor=nano              \
                                    --with-python=python3",
                        path:       buildDirectoryPath)
    end

    def build
        super
        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super
        makeSource( arguments:  "perllibdir=/usr/lib/perl5/5.40/site_perl DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
