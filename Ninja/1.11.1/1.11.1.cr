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

        setPermissions("#{Ism.settings.rootPath}usr/bin/ninja",755)
        setPermissions("#{Ism.settings.rootPath}usr/share/bash-completion/completions/ninja",644)
        setPermissions("#{Ism.settings.rootPath}usr/share/zsh/site-functions/_ninja",644)
    end

end
