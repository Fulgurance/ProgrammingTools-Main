class Target < ISM::Software
    
    def prepare
        super

        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}Makefile.in",
                                    text:       "yasm$(EXEEXT) ytasm$(EXEEXT) vsyasm$(EXEEXT)",
                                    newText:    "yasm$(EXEEXT)",
                                    lineNumber: 101)
    end
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
