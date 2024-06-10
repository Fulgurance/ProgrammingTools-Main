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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/dejagnu-1.6.3")

        moveFile("#{buildDirectoryPath}/doc/dejagnu.html","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.html")
        moveFile("#{buildDirectoryPath}/doc/dejagnu.txt","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/doc/dejagnu-1.6.3/dejagnu.txt")
    end

    def install
        super

        runChmodCommand(["0755","/usr/share/doc/dejagnu-1.6.3"])
        runChmodCommand(["0644","/usr/share/doc/dejagnu-1.6.3/dejagnu.html"])
        runChmodCommand(["0644","/usr/share/doc/dejagnu-1.6.3/dejagnu.txt"])
    end

end
