class Target < ISM::Software
    
    def build
        super

        runPythonCommand(["setup.py", "build"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runPythonCommand(["setup.py", "install", "--root=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath(false)}/#{Ism.settings.rootPath}/usr/share/bash-completion/completions/meson")
    end

end
