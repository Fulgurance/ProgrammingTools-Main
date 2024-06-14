class Target < ISM::Software
    
    def prepare
        super

        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}Modules/GNUInstallDirs.cmake",
                                    text:       "set(_LIBDIR_DEFAULT \"lib64\")",
                                    newText:    "set(_LIBDIR_DEFAULT \"lib\")",
                                    lineNumber: 289)
        fileReplaceTextAtLineNumber(path:       "#{buildDirectoryPath}Modules/GNUInstallDirs.cmake",
                                    text:       "set(__LAST_LIBDIR_DEFAULT \"lib64\")",
                                    newText:    "set(__LAST_LIBDIR_DEFAULT \"lib\")",
                                    lineNumber: 291)
    end
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                      \
                                    --system-libs                       \
                                    --mandir=/share/man                 \
                                    --no-system-jsoncpp                 \
                                    --no-system-cppdap                  \
                                    --no-system-librhash                \
                                    #{option("Qt") ? "--qt-gui" : ""}   \
                                    --docdir=/share/doc/cmake-3.27.2"],
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
