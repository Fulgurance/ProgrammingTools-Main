class Target < ISM::Software
    
    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath}Modules/GNUInstallDirs.cmake","set(_LIBDIR_DEFAULT \"lib64\")","set(_LIBDIR_DEFAULT \"lib\")",289)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath}Modules/GNUInstallDirs.cmake","set(__LAST_LIBDIR_DEFAULT \"lib64\")","set(__LAST_LIBDIR_DEFAULT \"lib\")",291)
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--system-libs",
                            "--mandir=/share/man",
                            "--no-system-jsoncpp",
                            "--no-system-cppdap",
                            "--no-system-librhash",
                            "#{option("Qt") ? "--qt-gui" : ""}",
                            "--docdir=/share/doc/cmake-3.27.2"],
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
