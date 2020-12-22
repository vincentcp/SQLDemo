pipeline {
  agent {
    node {
      label 'Windows'
    }

  }
  stages {
    stage('Build SSDT project to dacpac') {
      steps {
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\MSBuild\\Current\\Bin\\MSBuild.exe"'
      }
    }

  }
}