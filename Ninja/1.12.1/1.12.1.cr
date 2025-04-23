class Target < ISM::Software
    
    def configure
        super

        runPythonCommand(   arguments:  "configure.py",
                            path:       buildDirectoryPath)
    end

    def build
        super

        runCmakeCommand(arguments:      "--build #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)
    end
    
    def prepareInstallation
        super

        runCmakeCommand(arguments:      "--install #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

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

end
