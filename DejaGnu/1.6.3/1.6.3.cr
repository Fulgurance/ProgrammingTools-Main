class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr",
                        path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        runMakeinfoCommand(arguments:   "--html             \
                                        --no-split          \
                                        -o                  \
                                        doc/dejagnu.html    \
                                        ../doc/dejagnu.texi",
                            path:       buildDirectoryPath)

        runMakeinfoCommand( arguments:  "--plaintext    \
                                        -o              \
                                        doc/dejagnu.txt \
                                        ../doc/dejagnu.texi",
                            path:       buildDirectoryPath)

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/#{versionName}")

        moveFile(   "#{buildDirectoryPath}/doc/dejagnu.html",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/doc/#{versionName}/dejagnu.html")
        moveFile(   "#{buildDirectoryPath}/doc/dejagnu.txt",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/doc/#{versionName}/dejagnu.txt")
    end

    def install
        super

        runChmodCommand("0755 /usr/share/doc/#{versionName}")
        runChmodCommand("0644 /usr/share/doc/#{versionName}/dejagnu.html")
        runChmodCommand("0644 /usr/share/doc/#{versionName}/dejagnu.txt")
    end

end
