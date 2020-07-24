node{
    // limpa a pasta de exceuções anteriores
	deleteDir()
   
    def awskey = ""
    def awssecret = ""

    // define a pasta do projeto onde será executado o terraform
	def folder = "projetos/${TFProject}"
	
	// dependendo do ambientes define a key e secret da AWS
	// isso direciona em qual ambiente serão criados os recursos
	// *** NÃO ESTÃO DETALHADAS AS BUSCA DE CADA CHAVE DA AWS, É SOMENTE PARA PASSAR A IDEIA ***
	switch(${TFEnvironment}) {
		case (dev) {
			def awskey = "chave_da_aws_dev"
			def awssecret = "secret_da_aws_dev"
		}
		case (homo) { }
		case (prod) { }
	}

    // faz o pull do projeto no repositório com credenciais já configuradas
    git(
        url: '${TFRepository}',
        credentialsId: 'RepositoryCredentials',
        branch: "master"
    )
    
	// como o arquivo de backend.tf não permite variáveis, faz o replace do nome do bucket concatenando com ambiente
    contentReplace(
        configs: [
            fileContentReplaceConfig(
                configs: [
                    fileContentReplaceItemConfig(
                        search: '__BUCKETNAME__',
                        replace: "nome_do_bucket-${TFEnvironment}",
                        matchCount: 1)
                    ],
                fileEncoding: 'UTF-8',
                filePath: "${env.WORKSPACE}/projetos/${TFProject}/backend.tf")
            ]
    ) 
    
    // executa o terraform dentro de um container
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
        docker.image("hashicorp/terraform:light").inside(""" -e "AWS_ACCESS_KEY_ID=${awskey}" -e "AWS_SECRET_ACCESS_KEY=${awssecret}" --entrypoint="" """) {
            dir("${folder}") {
                
				// copia o devido profile para a pasta do projeto onde será executado o terraform com o nome de main.tf
				sh 'cp ../../ambientes/${TFEnvironment}/profile.tf main.tf'
                
				// copia as variaveis dos ambiente para a pasta onde será executado o terraform
				sh 'cp ${TFEnvironment}/* .'

				// copia os recursos que serão criados para a pasta onde será executado o terraform
				sh 'cp ../../recursos/${TFResource}/* .'

				// inicializa o terraform
                sh 'terraform init'
				
				// executa o plano do terraform
                sh 'terraform plan'
                
				// se a opção for aplicar a mudança, executa o apply do terraform
				if("${TFAction}" == "apply") {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}