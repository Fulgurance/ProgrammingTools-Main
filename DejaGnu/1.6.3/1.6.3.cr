class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath)
    end

    def prepareInstallation
        super

        runMakeinfoCommand(["--html",
                            "--no-split",
                            "-o",
                            "doc/dejagnu.html",
                            "../doc/dejagnu.texi"],
                            buildDirectoryPath)
        runMakeinfoCommand(["--plaintext",
                            "-o",
                            "doc/dejagnu.txt",
                            "../doc/dejagnu.texi"],
                            buildDirectoryPath)
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/dejagnu-1.6.3")
        moveFile("#{buildDirectoryPath(false)}/doc/dejagnu.html","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.html")
        moveFile("#{buildDirectoryPath(false)}/doc/dejagnu.txt","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.txt")
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3",755)
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.html",644)
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.txt",644)
    end

end
