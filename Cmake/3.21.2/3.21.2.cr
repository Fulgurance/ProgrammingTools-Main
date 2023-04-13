class Target < ISM::Software
    
    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}Modules/GNUInstallDirs.cmake","set(_LIBDIR_DEFAULT \"lib64\")","set(_LIBDIR_DEFAULT \"lib\")",256)
        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}Modules/GNUInstallDirs.cmake","set(__LAST_LIBDIR_DEFAULT \"lib64\")","set(__LAST_LIBDIR_DEFAULT \"lib\")",258)
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--system-libs",
                            "--mandir=/share/man",
                            "--no-system-jsoncpp",
                            "--no-system-librhash",
                            "--docdir=/share/doc/cmake-3.21.2"],
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
