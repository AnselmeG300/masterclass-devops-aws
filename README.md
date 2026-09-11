# Masterclass DevOps AWS : du commit au deploiement

Projet fil rouge de la masterclass. Une petite application web statique,
poussee sur GitHub, declenche un pipeline AWS qui la construit et la
deploie automatiquement. Toute l'infrastructure est definie en Terraform.

## Le schema en une phrase

GitHub (commit) -> CodePipeline -> CodeBuild (build) -> S3 (site en ligne)

## Arborescence

```
masterclass-devops-aws/
├── buildspec.yml          # ce que CodeBuild execute
├── app/
│   ├── index.html         # la page (contient un marqueur __BUILD_VERSION__)
│   └── styles.css
└── terraform/
    ├── versions.tf        # version de Terraform et du provider AWS
    ├── providers.tf       # provider AWS + ID de compte pour nommer les buckets
    ├── variables.tf       # region, nom de projet, infos GitHub
    ├── s3.tf              # bucket du site + bucket des artefacts
    ├── iam.tf             # roles CodeBuild et CodePipeline
    ├── codebuild.tf       # projet de build
    ├── codepipeline.tf    # connexion GitHub + pipeline 3 etapes
    ├── outputs.tf         # URL du site, ARN de connexion, nom du pipeline
    └── terraform.tfvars.example
```

## Preparation (a faire AVANT la masterclass)

1. Creer un depot GitHub (ex : masterclass-devops-aws) et y pousser ce projet.
2. Avoir des identifiants AWS actifs dans le terminal (aws configure ou variables d'environnement).
3. Dans terraform/, copier terraform.tfvars.example en terraform.tfvars et renseigner github_owner et github_repo.
4. Premier apply pour creer la connexion GitHub :

   ```
   cd terraform
   terraform init
   terraform apply
   ```

5. IMPORTANT : la connexion GitHub est creee au statut PENDING.
   Aller dans la console AWS : Developer Tools > Settings > Connections,
   ouvrir la connexion, cliquer "Update pending connection", installer
   l'application AWS Connector sur le depot, autoriser. Une seule fois.
6. Verifier que tout tourne (un premier passage du pipeline), puis ouvrir
   l'URL donnee par la sortie site_url. La page doit s'afficher.

Astuce demo : gardez ce premier deploiement deja termine sous la main.
Les temps d'attente AWS sont longs et cassent le rythme.

## Deroule de la demo (pilotee par le formateur)

Passe 1 : montrer le resultat final deja en ligne (l'URL site_url), pour
que le public sache ou on va.

Passe 2 : expliquer l'infra couche par couche dans terraform/, en commentant
chaque bloc avant de lancer la commande. Ordre de lecture conseille :
variables -> s3 -> iam -> codebuild -> codepipeline.

Passe 3 : le moment magique. Modifier une ligne de app/index.html (par
exemple le titre), committer via l'interface web de GitHub, puis suivre
ensemble le pipeline dans la console CodePipeline. Quand le Deploy passe au
vert, rafraichir l'URL : la version affichee a change.

## Nettoyage (apres la masterclass)

```
cd terraform
terraform destroy
```

Les buckets sont en force_destroy, la suppression est donc complete.

## Si la page se telecharge au lieu de s'afficher

Rare, mais possible selon le type de contenu detecte par l'etape Deploy.
Dans ce cas, ajouter dans buildspec.yml un deploiement direct via
"aws s3 sync dist/ s3://NOM_DU_BUCKET_SITE/ --delete" et retirer l'etape
Deploy du pipeline. La version a 3 etapes reste la plus parlante en cours.
# masterclass-devops-aws
