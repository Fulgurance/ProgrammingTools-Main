class Target < ISM::Software
    
    def configure
        super

        runPythonCommand(   arguments:  "configure.py --bootstrap --verbose",
                            path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/")

        copyFile(   "#{buildDirectoryPath}/ninja",
                    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/")

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/ninja")

        copyFile(   "#{buildDirectoryPath}/misc/bash-completion",
                    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/ninja")

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/zsh/site-functions/_ninja")

        copyFile(   "#{buildDirectoryPath}/misc/zsh-completion",
                    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/zsh/site-functions/_ninja")
    end

    def deploy
        super

        runChownCommand("root:root /usr/share/bash-completion/completions/ninja")
        runChownCommand("root:root /usr/share/zsh/site-functions/_ninja")

        runChmodCommand("0644 /usr/share/bash-completion/completions/ninja")
        runChmodCommand("0644 /usr/share/zsh/site-functions/_ninja")
    end

end
