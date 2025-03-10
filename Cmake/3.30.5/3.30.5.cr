class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                      \
                                    --system-libs                       \
                                    --mandir=/share/man                 \
                                    --no-system-jsoncpp                 \
                                    --no-system-cppdap                  \
                                    --no-system-librhash                \
                                    #{option("Qtbase") ? "--qt-gui" : ""}   \
                                    --disable-doc",
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
