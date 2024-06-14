class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --with-system-readline  \
                                    --with-python=/usr/bin/python3",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} -C gdb install",
                    path:       buildDirectoryPath)

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} -C gdbserver install",
                    path:       buildDirectoryPath)
    end

end
