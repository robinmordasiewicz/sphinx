pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: kaniko
            image: gcr.io/kaniko-project/executor:debug
            imagePullPolicy: IfNotPresent
            command:
            - /busybox/cat
            tty: true
            volumeMounts:
              - name: kaniko-secret
                mountPath: /kaniko/.docker
          restartPolicy: Never
          volumes:
            - name: kaniko-secret
              secret:
                secretName: regcred
                items:
                  - key: .dockerconfigjson
                    path: config.json
        '''
    }
  }
  stages {
    stage('build sphinx container') {
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          script {
            sh '''
            /kaniko/executor --dockerfile=Dockerfile \
                             --context=git://github.com/robinmordasiewicz/sphinx-container.git \
                             --destination=robinhoodis/sphinx:`cat VERSION` \
                             --destination=robinhoodis/sphinx:latest \
                             --skip-tls-verify
            '''
          }
        }
      }
    }
    stage('create new manifest') {
      steps {
        sh 'mkdir argocd'
        dir ( 'argocd' ) {
          git branch: 'main', url: 'https://github.com/robinmordasiewicz/argocd.git'
          sh 'sh increment-version.sh'
        }
      }
    }
    stage('commit new manifest') {
      steps {
        dir ( 'argocd' ) {
          sh 'git config user.email "robin@mordasiewicz.com"'
          sh 'git config user.name "Robin Mordasiewicz"'
          sh 'git add .'
          sh 'git commit -m "`cat sphinx/VERSION`"'
          withCredentials([gitUsernamePassword(credentialsId: 'github-pat', gitToolName: 'git')]) {
            sh '/usr/bin/git push origin main'
          }
        }
      }
    }
    stage('clean up') {
      steps {
        sh 'rm -rf argocd'
      }
    }
  }
//  post {
//    always {
//      cleanWs(cleanWhenNotBuilt: false,
//            deleteDirs: true,
//            disableDeferredWipeout: true,
//            notFailBuild: true,
//            patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
//                     [pattern: '.propsfile', type: 'EXCLUDE']])
//    }
//  }
}
