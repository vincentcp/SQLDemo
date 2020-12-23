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
        stash(name: 'SQLDemoDacpac', includes: 'bin/Debug/SQLDemo.dacpac')
        archiveArtifacts(artifacts: 'bin/Debug/SQLDemo.dacpac', onlyIfSuccessful: true)
        cleanWs(cleanWhenSuccess: true, skipWhenFailed: true)
      }
    }

    stage('Deploy to DEV') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        powershell '& "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"bin/Debug/SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_DEV -TargetServerName:localhost'
      }
    }

    stage('Deploy to INT') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        input(message: 'Should we move to integration?', submitter: 'vincent')
        powershell ' & "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"bin\\Debug\\SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_INT -TargetServerName:localhost'
      }
    }

    stage('Deploy to PRD') {
      agent {
        node {
          label 'Windows'
        }

      }
      steps {
        unstash 'SQLDemoDacpac'
        powershell ' & "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\IDE\\Extensions\\Microsoft\\SQLDB\\DAC\\140\\sqlpackage.exe" -Action:Publish  -Sourcefile:"bin\\Debug\\SQLDemo.dacpac" -TargetDatabaseName:SQLDemo_PRD -TargetServerName:localhost'
      }
    }

    stage('Trigger Deploy to DEV') {
      steps {
        input 'Should we move to integration?'
      }
    }

  }
}