class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        # if option("Pass1")
        #     makeLink(   target: "ld-linux-x86-64.so.2",
        #                 path:   "#{Ism.settings.rootPath}/lib64/ld-lsb-x86-64.so.3",
        #                 type:   :symbolicLinkByOverwrite)
        # end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                      \
                                        --host=#{Ism.settings.chrootTarget} \
                                        --disable-warnings                  \
                                        --enable-shared                     \
                                        --disable-static",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                      \
                                        --disable-warnings                  \
                                        --enable-shared                     \
                                        --disable-static",
                            path:       buildDirectoryPath)
        end
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
