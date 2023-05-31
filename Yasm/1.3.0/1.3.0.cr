class Target < ISM::Software
    
    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}Makefile.in","yasm$(EXEEXT) ytasm$(EXEEXT) vsyasm$(EXEEXT)","yasm$(EXEEXT)",101)
    end
    
    def configure
        super

        configureSource(["--prefix=/usr"],buildDirectoryPath)
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
