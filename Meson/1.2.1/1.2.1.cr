class Target < ISM::Software
    
    def build
        super

        runPythonCommand(   arguments:  "setup.py build",
                            path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runPythonCommand(   arguments:  "setup.py install --root=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                            path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/meson")
    end

end
