class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--with-system-readline",
                            "--with-python=/usr/bin/python3"],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","-C","gdb","install"],buildDirectoryPath)
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","-C","gdbserver","install"],buildDirectoryPath)
    end

end
