pipeline {
    agent any

    stages {
        /*
        This is a comment 1
        */
        // This is a comment 2

        // stage('Build') {
        //     agent {
        //         docker {
        //             image 'node:18-alpine'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         sh '''
        //         ls -la
        //         node --version
        //         npm --version
        //         npm ci
        //         npm run build
        //         ls -la
        //         '''
        //     }
        // }

        stage('tests') {
            parallel {
                stage('Test') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                        echo "Test Stage"
                        ls -la
                        test -f build/index.html
                        npm test
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                        }
                    }
                }
                stage('E2E') {
                    agent {
                        docker {
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                        echo "E2E Stage"
                        npm install serve
                        node_modules/.bin/serve -s build &
                        sleep 10
                        npx playwright test --reporter=html
                        '''
                    }
                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }
        stage('Deploy staging') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            environment {
                NETLIFY_SITE_ID = 'bd61fbd8-7752-4e66-b012-199b24160882'
                NETLIFY_AUTH_TOKEN = credentials('netlify_id')
            }
            steps {
                sh '''
                echo "Deploy staging"
                npm install netlify-cli@20.1.1
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build
                '''
            }
        }
        stage('Approval') {
            steps {
                timeout(time: 60, unit: 'SECONDS') {
                    input message: 'Ready to deploy to Production?', ok: 'Yes'
                }
            }
        }
        stage('Deploy production') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            environment {
                NETLIFY_SITE_ID = '55f54b1c-e3dc-4028-9ed1-ae6c94832252'
                NETLIFY_AUTH_TOKEN = credentials('netlify_id')
            }
            steps {
                sh '''
                echo "Deploy stage"
                npm install netlify-cli@20.1.1
                node_modules/.bin/netlify status
                node_modules/.bin/netlify deploy --dir=build --prod
                '''
            }
        }
    //             stage('E2E') {
    //                 agent {
    //                     docker {
    //                         image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
    //                         reuseNode true
    //                     }
    //                 }
    //                 environment {
    //                     CI_ENVIRONMENT_URL = 'https://iridescent-trifle-2bfeba.netlify.app'
    //                 }
    //                 steps {
    //                     sh '''
    //                     echo "E2E Stage"
    //                     // npx playwright test --reporter=html
    //                     '''
    //                 }
    //                 post {
    //                     always {
    //                         publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, icon: '', keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright E2E Report', reportTitles: '', useWrapperFileDirectly: true])
    //                     }
    //                 }
    //             }
    }
}