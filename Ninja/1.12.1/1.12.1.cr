class Target < ISM::Software
    
    def build
        super

        runPythonCommand(   arguments:  "configure.py --bootstrap",
                            path:       buildDirectoryPath,
                            environment:    {   "PATH" => "/usr/bin/python3.12:$PATH",
                                                "PYTHONPATH" => "/usr/lib/python3.12/site-packages"})
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

end
