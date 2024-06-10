class Target < ISM::Software
    
    def build
        super

        runPythonCommand(["configure.py", "--bootstrap"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/")
        copyFile("#{buildDirectoryPath}/ninja","#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/")

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/ninja")
        copyFile("#{buildDirectoryPath}/misc/bash-completion","#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/ninja")

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/zsh/site-functions/_ninja")
        copyFile("#{buildDirectoryPath}/misc/zsh-completion","#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/zsh/site-functions/_ninja")
    end

    def install
        super

        runChmodCommand(["0755","/usr/bin/ninja"])
        runChmodCommand(["0644","/usr/share/bash-completion/completions/ninja"])
        runChmodCommand(["0644","/usr/share/zsh/site-functions/_ninja"])
    end

end
