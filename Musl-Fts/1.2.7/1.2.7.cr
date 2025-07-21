class Target < ISM::Software

    def configure
        super

        runFile(file: "bootstrap.sh",
                path: buildDirectoryPath)

        configureSource(arguments:  "--prefix=/usr          \
                                    --sysconfdir=/etc       \
                                    --mandir=/usr/share/man \
                                    --localstatedir=/var",
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
